import base64
import json
from datetime import datetime, timedelta
from google.cloud import firestore as firestore
import firebase_admin
from firebase_admin import db

def hello_pubsub(event, context):
    try:
        firebase_admin.get_app()
    except ValueError:
        firebase_admin.initialize_app(options={"databaseURL" : "https://coffee-dao-org-default-rtdb.firebaseio.com/"})
    pNFT = db.reference("nfts")
    rNFT = db.reference("regularNfts")
    fsdb = firestore.Client(project="coffee-dao-org")
    ordersRef = fsdb.collection("orders")
    orderTimestamp = (datetime.utcnow() - timedelta(hours=6)).timestamp() # controls how long before we null an order due to the transaction not going on chain
    nftTimestamp = (datetime.utcnow() - timedelta(hours=1)).timestamp() # controls how long a user has to make a purchase
    timeNow = datetime.utcnow().timestamp()

    # Query orders for unvalid this isa double check to insure all available nfts are market as such
    orderQuery = ordersRef.where(filter=firestore.FieldFilter("valid", "==", False)).where(filter=firestore.FieldFilter("status", "==", 'placed')).where(filter=firestore.FieldFilter("lastUpdate", "<", orderTimestamp))
    orders = []
    for doc in orderQuery.stream():   
        formattedData = doc.to_dict()
        orders.append(formattedData)
    if orders == []:
        print(f"No overdue purchases at this time.")
    for order in orders:
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
                if x['lastUpdate'] < nftTimestamp:
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
                if x['lastUpdate'] < nftTimestamp:
                    rNFT.child(x['id']).update({
                        'available': True,
                        'transactionId': '',
                        'lastUpdate': timeNow
                    })
    except Exception as e:
        print('get e', e)
    
    