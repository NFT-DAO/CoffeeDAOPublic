import base64
import json
from google.cloud import firestore as firestore
from google.cloud import pubsub_v1
import firebase_admin
from firebase_admin import db
from datetime import datetime
import os

def hello_world(request):
    try:
        firebase_admin.get_app()
    except ValueError:
        firebase_admin.initialize_app(options={"databaseURL" : os.environ.get('databaseURL')})
    pNFT = db.reference("nfts")
    rNFT = db.reference("regularNfts")
    fsdb = firestore.Client(project=os.environ.get('project'))
    ordersRef = fsdb.collection("orders")

    projectId = 'product-dao-org'
    publisher = pubsub_v1.PublisherClient()
    topic_name = publisher.topic_path(projectId, 'emailer')

    resp = request.get_json(silent=True)
     # resp = {"block": 1389, "timestamp": "2023-09-15T14:20:48.36653298Z", "transaction_hash": "95a65b00f0e6c5320d879b3fc192f1299ed7bb7a209c", "state": "Onchain"}
    ts = resp["timestamp"]
    t = ts[0:-3]+'Z'
    timestamp = datetime.strptime(t, "%Y-%m-%dT%H:%M:%S.%fZ").timestamp()

    transaction_hash = resp["transaction_hash"]
    state = resp["state"] # Pending Rejected Onchain Rolledback

    orderQuery = ordersRef.where(filter=firestore.FieldFilter("hash", "==", transaction_hash)).limit(1)
    docs = []
    for doc in orderQuery.stream():   
        formattedData = doc.to_dict()
        docs.append(formattedData)
    if docs == []:
        return "200"
    order = docs[0]
    orderId = order['id']
    name = order['name']
    email = order['email']
    nftId = order['nft']
    if nftId[0] == '0':
        nftRef = pNFT
    elif int(nftId) > 1050:
        nftRef = rNFT
    else:
        nftRef = pNFT

    if state == "Pending" or state == "Rolledback":
        ordersRef.document(orderId).update({
            "status": state,
            "lastUpdate": timestamp
        })
        nftRef.child(nftId).update({
            "transactionId": transaction_hash,
            "available": False,
            "lastUpdate": timestamp
        })
    elif state == "Rejected":
        nftRef.child(nftId).update({
            "transactionId": "",
            "available": True,
            "lastUpdate": timestamp
        })
        ordersRef.document(orderId).update({
            "status": state,
            "lastUpdate": timestamp,
            "valid": False
        })

        # Send email
        subject = 'Order Update'
        message_body = 'There was a problem with your transaction, it did not go through and has been canceled. Please try again. Thank you.'
        message_json = json.dumps(
            {
                "data": {"recipient_email": email, "subject":subject, "message_body":message_body},
            }
        )
        message_bytes = message_json.encode("utf-8")
        future = publisher.publish(topic_name, message_bytes)
        future.result()

    elif state == "Onchain":
        nftRef.child(nftId).update({
            "transactionId": transaction_hash,
            "available": False,
            "lastUpdate": timestamp
        })
        ordersRef.document(orderId).update({
            "status": state,
            "lastUpdate": timestamp,
            "valid": True
        })
        #TODO send email
        subject = 'Order Update'
        message_body = '''Your order is complete and you can now view your NFT in your wallet and check the transaction on CardanoScan. https://cardanoscan.io/transaction/''' + transaction_hash + ' We will email you with updates on when your order will ship.'#TODO Set the correct cardanoscan base url
        message_json = json.dumps(
            {
                "data": {"recipient_email": email, "subject":subject, "message_body":message_body},
            }
        )
        message_bytes = message_json.encode("utf-8")
        future = publisher.publish(topic_name, message_bytes)
        future.result()
    return "200"