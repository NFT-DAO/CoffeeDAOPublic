This cloud function is used to send users a tracking number once their order has shipped.. 
When setting up this cloud function set a Event Trigger for Firestore document updated.
This script requires a mail server and environmental variable "mail" for the mail server password and one for the project name.