# Signing and minting server

Copy your plutus script that was generated by Aiken into this folder.
Set up you Artifact Registry in Google Cloud and enable the Cloud Run service.
Set up a Google Cloud Secret for your Maestro API Key and signing wallet mnemonic using the Secret Manager service.

# Build and deploy the container.

sudo docker build -t maestro .
docker tag maestro us-central1-docker.pkg.dev/product-dao-org/maestro:latest
docker push us-central1-docker.pkg.dev/product-dao-org/maestro

Go to Cloud Run and start a new instance using the Docker in Artifact Registry and the environmental variable for your Google Secret.

Copy the endpoint url and add it to the config.json SIGN_MINT_SERVER_URL
