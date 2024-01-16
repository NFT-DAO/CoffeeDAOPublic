import base64
import os
import json
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def hello_firestore(event, context):
    print('event', type(event), event)
    eventJ = event['value']['fields']
    userEmail = eventJ['to']['stringValue']
    subject = eventJ['message']['mapValue']['fields']['subject']['stringValue']
    message = eventJ['message']['mapValue']['fields']['text']['stringValue']
    print('userEmail', type(userEmail), userEmail)
    print('subject', type(subject), subject)
    print('message', type(message), message)
    
    # Email server configuration
    SMTP_SERVER = 'mail.gandi.net'
    SMTP_PORT = 587
    SMTP_USERNAME = 'contact@productdao.me'
    SMTP_PASSWORD = os.environ.get('mail')
    SENDER_EMAIL = 'contact@productdao.me'

    # Message constructor
    msg = MIMEMultipart()
    msg['From'] = SENDER_EMAIL
    msg['To'] =  userEmail
    msg['Subject'] = subject
    msg.attach(MIMEText(message, 'plain'))

    # Send the email
    try:
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USERNAME, SMTP_PASSWORD)
            server.sendmail(SENDER_EMAIL, userEmail, msg.as_string())
            print(f"Email sent successfully to {userEmail}!")
    except Exception as e:
        print(f"Failed to send email to {userEmail}. Error: {e}")
