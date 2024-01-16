This cloud function is used to send users and admin on updates to the contact form. 
When setting up this cloud function set a trigger for Firestore write events on the Document Path contact/{ordrnum}
This script requires a mail server and environmental variable "mail" for the mail server password.