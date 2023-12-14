# coffee-nft
Cofee-NFT project


# Use the app
Have a preprod wallet with at least 50 ada.
Go to https://coffee-dao.web.app/
Click the "BUY NOW"
Enter real or fake info *ZIP CODE needs to be an int
Click the "Submit" button (frontend/cdao/lib/screens/orderFormScreen.dart)
This is where the app calls the lucidFunc service worker(frontend/cdao/web/lucidFunc.js) to build the transaction. The service worker expects the NFT id as a parameter. The service worker initiates the wallet and asks the user for access to the wallet. It then constructs the transaction with metadata and asks the user to sign it. It then passes the tx and witness back to the Dart/Flutter Future(_submitOrderForm()) that called it. 
The app then calls the backend to finish the transaction.
After a few seconds you will be taken to the receipt page where you will see the tx hash, the image of your nft with watermark, and a link to cardanoscan showing your transaction.


Refinements needed:
Better error handling and error communication
Ability to choose a different NFT
Ability to purchase more than one
NFT gallery and showing the real NFT on the receipt page.
Scaled to handle many types of coffee and NFTs.
Obfuscate the lucidFunc


# Contract
TODO Add bag limit check to purchases

# Frontend
The frontend is written in Dart/Flutter using a dart/js interop service worker to use the Lucid js package. The lucid service worker can be found at frontend/cdao/web/lucidFunc.js


The main ui pages are found at frontend/cdao/lib/screens and widgets.


# Backend
The server runs on Google Cloud Products Cloud in a Cloud Run Container. It is built with a denoland/deno:latest Dockerfile stored in a private GCP docker repository(Artifact Registry). Cloud Run is only up when there is a request and you are only charged for uptime. The endpoint is https://cdao-mint-tm7praakga-uc.a.run.app/mint


The end point expects a tx and a witness. It then generates the contracts DAO singing key from env variable mnemonic phrase. Then partial sign, assemble, and submit. It returns the tx hash to the front end.


The app uses GCP Firebase Cloud Storage for file storage/cdn, Firestore(noSql) for storing orders, and Realtime Database(sql) for NFT details(id,displayUrl, IPFSUrl, availability).


Refinements needed:
Better env variable security
Stricter access
Calls to the Database to ensure nft availability and update the database when the tx is complete. Currently the front end is handling this.
Better error handling and logging
Better security rules for Firebase services

flutter build web --web-renderer html