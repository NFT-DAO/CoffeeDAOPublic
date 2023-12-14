# coffee-nft
# Cofee-NFT project

# Use the app
1. Have a preprod wallet with at least 50 ada.
2. Go to https://coffee-dao.web.app/
3. Click the "BUY NOW"
4. Enter real or fake info *ZIP CODE needs to be an int
5. Click the "Submit" button (frontend/cdao/lib/screens/orderFormScreen.dart)
- This is where the app calls the lucidFunc service worker frontend/cdao/web/lucidFunc.js to build the transaction via the _submitOrderForm() in orderFormScreen.dart. 
- The service worker expects the NFT id as a parameter. 
- The service worker initiates the wallet and asks the user for access to the wallet. 
- It then constructs the transaction with metadata and asks the user to partially sign it. 
- It then passes the tx and witness back to the Dart/Flutter Future _submitOrderForm() that called it. 
- The Future _submitOrderForm() then calls the backend to finish the transaction.
6. After a few seconds you will be taken to the receipt page where you will see the tx hash, the image of your nft with watermark, and a link to cardanoscan showing your transaction.

# Contract
The minting policy is written with Aiken and checks that the mint happens before the deadline, is paid for, has permission from the app, and is minting a single NFT.

# Frontend
The frontend is written in Dart/Flutter using a dart/js interop service worker to use the Lucid js package and Maestro as the provider. The app utilizes Maestro api to receive order updates ensuring that all transactions are verified and NFT databases are up to date. Through many database CRUD operations throughout the purchasing process the availability of the NFT is maintained.

# Backend
The app uses Google Cloud Products for the backend. Databases, hosting, user management, and security is through the GCP product Firebase. TheFirebase products the app uses are: Cloud Storage for file storage/cdn, Firestore(noSql) for storing orders, and Realtime Database(sql ’like’) for NFT details(id,displayUrl, Arweav Url, availability, ect).
The firebase package works seemingly with the Flutter/Dart framework, it also provides robust customizable security and competitive pricing. 

Cloud functions and Cloud Run instances are used to handle orders and sign contracts. These services only bill for when they are used keeping cost low. GCP has many highly secure tools to handle secrets and keys used for auth and singing. 

We use two CDAO wallets to interact with the contract. One for singing and one for funds. This keeps the funds wallet attack vectors very low as all that is stored in GCP is the public address.

The contract servers run in a Cloud Run instance and are built with a Denoland Dockerfile stored in a private GCP docker repository(Artifact Registry).

The contract server end point expects a tx and a witness. It then generates the contracts DAO singing key from env variable mnemonic phrase. Then partial sign, assemble, and submits the transaction via Maestro. It returns the tx hash or error to the front end. The front end will adjust the NFT availability and hash if needed and ask the user to try again if there is an error or take them to the receipt page. 

A Cloud Function is performed once a day to double check order and NFT statuses. This function adjusts any discrepancies in maestro queries, orders and nft databases. 



# Build
--dart-define-from-file=/home/rese/rese/DAPP/coffee-nft/admin/config.json

/Users/rese/Documents/apps/DAOCoffee/admin/config.json
/home/rese/rese/DAPP/coffee-nft/admin/config.json

flutter run --dart-define-from-file=/Users/rese/Documents/apps/DAOCoffee/admin/config.json -d chrome --web-renderer html

flutter build web --dart-define-from-file=/Users/rese/Documents/apps/DAOCoffee/admin/config.json --web-renderer html


// TODO
- [ ] deactivate none live pages
- [ ] About page
- [ ] change wallets signing addr in lucidfunc
- [ ] clean up orders db reset nft