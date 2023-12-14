import base64
import json
import os
from google.cloud import pubsub_v1

def hello_world(request):
    topic = "projects/coffee-dao-org/topics/emailer"
    projectId = 'coffee-dao-org'
    publisher = pubsub_v1.PublisherClient()
    topic_name = publisher.topic_path(projectId, 'emailer')
    recipient_email = 'tc@9rese.com'
    subject = 'Testing Coffeedao'
    message_body = 'Hi'

    message_json = json.dumps(
        {
            "data": {"recipient_email": recipient_email, "subject":subject, "message_body":message_body},
        }
    )
    message_bytes = message_json.encode("utf-8")
    future = publisher.publish(topic_name, message_bytes)
    future.result()