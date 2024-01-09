# Signing and minting server

Set up you Artifact Registry in Google Cloud and enable the Cloud Run service.
Set up a Google Cloud Secret for your USERID and GOOGLE_KEY using the Secret Manager service.

# Build and deploy the container.

sudo docker build -t addressAutoComplete .
docker tag maestro us-central1-docker.pkg.dev/product-dao-org/addressAutoComplete:latest
docker push us-central1-docker.pkg.dev/product-dao-org/addressAutoComplete

Go to Cloud Run and start a new instance using the Docker in Artifact Registry and the environmental variable for your Google Secret.

Copy the endpoint base url and add it to the config.json ADDR_AUTO_COMPLETE_URL_BASE
