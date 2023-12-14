import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os
from cloudevents.http import CloudEvent
import functions_framework
from google.events.cloud import firestore
from google.cloud import firestore as fs
import firebase_admin

@functions_framework.cloud_event
def hello_firestore(cloud_event: CloudEvent) -> None:
    firebase_admin.initialize_app()
    fsdb = fs.Client(project="coffee-dao-org")
    orderRef = fsdb.collection('orders')

    firestore_payload = firestore.DocumentEventData()
    firestore_payload._pb.ParseFromString(cloud_event.data)
    newOrder = firestore_payload.value

    shippingEmailSent = newOrder.fields['shippingEmailSent'].boolean_value
    trackingNum = newOrder.fields['tracking'].string_value
    status = newOrder.fields['status'].string_value
    userEmail = newOrder.fields['email'].string_value
    name = newOrder.fields['name'].string_value
    id = newOrder.fields['id'].string_value

    if status == 'shipped' and shippingEmailSent == False:
            message = 'Hi ' + name + ', your order is about to ship. You can track it via USPS using this tracking reference: ' + trackingNum + '. Feel free to contact us with any questions at contact@coffeedao.me'
            SMTP_SERVER = 'mail.gandi.net'
            SMTP_PORT = 587
            SMTP_USERNAME = 'contact@coffeedao.me'
            SMTP_PASSWORD = os.environ.get('mail')
            SENDER_EMAIL = 'contact@coffeedao.me'

            # Message constructor
            msg = MIMEMultipart()
            msg['From'] = SENDER_EMAIL
            msg['To'] =  userEmail
            msg['Subject'] = 'Update On Your Coffee DAO Order'
            msg.attach(MIMEText(message, 'plain'))

            # Send the email
            try:
                with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
                    server.starttls()
                    server.login(SMTP_USERNAME, SMTP_PASSWORD)
                    server.sendmail(SENDER_EMAIL, userEmail, msg.as_string())
                    print(f"Email sent successfully to {userEmail}!")

                    orderRef.document(id).update({"shippingEmailSent": True})
                    exit()
            except Exception as e:
                print(f"Failed to send email to {userEmail}. Error: {e}")
