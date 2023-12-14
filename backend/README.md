
# NFT Minting Endpoint (Backend)

# Backend

The server runs on Google Cloud Products Cloud in a Cloud Run Container. It is built with a denoland/deno:latest Dockerfile stored in a private GCP docker repository(Artifact Registry). Cloud Run is only up when there is a request and you are only charged for uptime.

The end point expects a tx and a witness. It then generates the contracts DAO singing key from env variable mnemonic phrase. Then partial sign, assemble, and submit. It returns the tx hash to the front end.

The app uses GCP Firebase Cloud Storage for file storage/cdn, Firestore(noSql) for storing orders, and Realtime Database(sql) for NFT details(id,displayUrl, IPFSUrl, availability).

-Refinements needed:
- [ ] Better env security
- [ ] Stricter access
- [ ] Calls to the Database to ensure nft availability
- [ ] Better error handling and logging
- [ ] Better security rules for Firebase services


## Run the server

```bash
deno run --allow-net --allow-env --allow-read index.ts
```

## Endpoint Details

**URL**: http://localhost:8000/mint

**Method**: POST

**Content-Type**: application/json

**Request Body**:

- `name` (string, required): The name of the NFT.
- `imagePath` (string, required): The local or remote path to the image file to be used as the NFT's artwork.

**Example Request:**

```json
{
  "name": "My NFT",
  "imagePath": "/path/to/image.png"
}
```

## CURL example

```bash
curl -X POST -H "Content-Type: application/json" -d '{"name": "My NFT", "imagePath": "/path/to/image.png"}' http://localhost:8000/mint
```

