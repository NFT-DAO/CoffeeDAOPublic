import base64
import json
from datetime import datetime, timedelta
from google.cloud import firestore as firestore
import firebase_admin
from firebase_admin import db
import os

def hello_pubsub(event, context):
    try:
        firebase_admin.get_app()
    except ValueError:
        firebase_admin.initialize_app(options={"databaseURL" : os.environ.get('databaseURL')})
    pNFT = db.reference("nfts")
    rNFT = db.reference("regularNfts")
    fsdb = firestore.Client(project=os.environ.get('project'))
    ordersRef = fsdb.collection("orders")
    sixBeforeNow = (datetime.utcnow() - timedelta(hours=6)).timestamp() # controls how long before we null an order due to the transaction not going on chain
    timeNow = datetime.utcnow().timestamp()

    # Query orders for unvalid this is a double check to insure all available nfts are market as such
    orderQuery = ordersRef.where(filter=firestore.FieldFilter("valid", "==", False)).where(filter=firestore.FieldFilter("lastUpdate", "<", sixBeforeNow)) # .where(filter=firestore.FieldFilter("status", "==", 'placed'))
    orders = []
    for doc in orderQuery.stream():   
        formattedData = doc.to_dict()
        orders.append(formattedData)
    if orders == []:
        print(f"No overdue purchases at this time.")
        return
    for order in orders:
        # check if any orders have this nft and are valid.
        orderNFTCheckerQuery = ordersRef.where(filter=firestore.FieldFilter("valid", "==", True)).where(filter=firestore.FieldFilter("nft", "==", order['nft'])) # .where(filter=firestore.FieldFilter("lastUpdate", "<", orderTimestamp))
        orderNFTCheck = []
        for doc in orderNFTCheck.stream():   
            formattedData = doc.to_dict()
            orderNFTCheck.append(formattedData)
        if orderNFTCheck == []:
            if order['nft'][0] == '0' or int(order['nft']) <= 1050:
                pNFT.child(order['nft']).update({
                    'available': True,
                    'transactionId':'',
                    'lastUpdate': timeNow
                })
            else:
                rNFT.child(order['nft']).update({
                    'available': True,
                    'transactionId':'',
                    'lastUpdate': timeNow
                })

    # Query every nft that has 'available' == false, 'transactionId' == ['hold','processing', ''] and lastUpdate > now + 1hr
    # Change 'available' = true, 'transactionId' = '' and lastUpdate = now
    try:
        pnftDic = []
        pnfts = pNFT.order_by_child('transactionId').equal_to('hold').get()
        for x in pnfts.items():
            pnftDic.append(x[1])
        pnfts = pNFT.order_by_child('transactionId').equal_to('').get()
        for x in pnfts.items():
            pnftDic.append(x[1])
        pnfts = pNFT.order_by_child('transactionId').equal_to('processing').get()
        for x in pnfts.items():
            pnftDic.append(x[1])
        for x in pnftDic:
            if x['available'] == False:
                if x['lastUpdate'] < sixBeforeNow:
                    pNFT.child(x['id']).update({
                        'available': True,
                        'transactionId': '',
                        'lastUpdate': timeNow
                    })
    except Exception as e:
        print('get e', e)
    try:
        rnftDic = []
        prnfts = rNFT.order_by_child('transactionId').equal_to('hold').get()
        for x in prnfts.items():
            rnftDic.append(x[1])
        rnfts = rNFT.order_by_child('transactionId').equal_to('').get()
        for x in rnfts.items():
            rnftDic.append(x[1])
        rnfts = rNFT.order_by_child('transactionId').equal_to('processing').get()
        for x in rnfts.items():
            rnftDic.append(x[1])
        for x in rnftDic:
            if x['available'] == False:
                if x['lastUpdate'] < sixBeforeNow:
                    rNFT.child(x['id']).update({
                        'available': True,
                        'transactionId': '',
                        'lastUpdate': timeNow
                    })
    except Exception as e:
        print('get e', e)
    
    