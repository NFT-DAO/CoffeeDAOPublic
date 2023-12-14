import base64
import os
import json
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def hello_pubsub(event, context):
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    print('pubsub_message ', type(pubsub_message), pubsub_message)
    mess = json.loads(pubsub_message)
    print('mess ', type(mess), mess)
    # data = event['data']
    recipient_email = mess['data']['recipient_email']
    subject = mess['data']['subject']
    message_body = mess['data']['message_body']

    # Email server configuration
    SMTP_SERVER = 'mail.gandi.net'
    SMTP_PORT = 587
    SMTP_USERNAME = 'contact@coffeedao.me'
    SMTP_PASSWORD = os.environ.get('mail')
    SENDER_EMAIL = 'contact@coffeedao.me'

    # Message constructor
    msg = MIMEMultipart()
    msg['From'] = SENDER_EMAIL
    msg['To'] =  recipient_email
    msg['Subject'] = subject
    msg.attach(MIMEText(message_body, 'plain'))

    # Send the email
    try:
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USERNAME, SMTP_PASSWORD)
            server.sendmail(SENDER_EMAIL, recipient_email, msg.as_string())
            print(f"Email sent successfully to {recipient_email}!")
    except Exception as e:
        print(f"Failed to send email to {recipient_email}. Error: {e}")
