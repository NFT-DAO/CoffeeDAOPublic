This cloud function is used to respond to Maestro's webhook events. It updates the databases and sends the customer an email with the update.
When setting up this cloud function set it up as a http call
This script requires a environmental variable "databaseURL" for the projects Firebase Realtime Database and a variable "project" for the project id.
Copy the endpoint url for the function and add it to your Maestro account as the webhook endpoint.