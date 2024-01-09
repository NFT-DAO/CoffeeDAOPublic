import 'package:cdao/providers/firestoreProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late String _name;
  late String _email;
  late String _message;
  late String _emailErr = '';
  late String _result = '';
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  bool validateEmail(String value) {
    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(emailPattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    var firestore = Provider.of<FirestoreService>(context, listen: false);

    Future<void> submitContactForm() async {
      await firestore
          .sendContactForm(
              userEmail: 'contact@productdao.me',
              subject: 'Contact From',
              emailBody: "$_name email: $_email $_message",
              name: 'DAO')
          .then((value) {
        if (value == 'Contact Sent') {
          firestore.sendContactForm(
              userEmail: _email,
              subject: 'Thanks for reaching out to DAO.',
              emailBody:
                  "Hi $_name, Please give us a few days to review your message and respond. Thanks the Product Dao Team",
              name: _name);
          _result = 'Your comment has been sent.';
          _isSubmitting = false;
          setState(() {});
        } else {
          _isSubmitting = false;
          _emailErr = 'Something did not go as planed. Please try again.';
          setState(() {});
        }
      });
    }

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_emailErr != '')
              Text(
                _emailErr,
                style: const TextStyle(color: Colors.red),
              ),
            if (_result != '')
              Text(
                _result,
                style: const TextStyle(color: Colors.orange),
              ),
            //name
            TextFormField(
              key: const ValueKey('name'),
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              enableSuggestions: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name.';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              onSaved: (value) {
                _name = value!;
              },
            ),
            //email
            TextFormField(
              key: const ValueKey('email'),
              style: const TextStyle(color: Colors.white),
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty || validateEmail(value) != true) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              onSaved: (value) {
                _email = value!;
              },
            ),
            //Message
            SingleChildScrollView(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white),
                maxLines: null, //grow automatically
                key: const ValueKey('message'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Can\'t be empty.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Tell us your thoughts.',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                onSaved: (value) {
                  _message = value as String;
                },
              ),
            ),
            const SizedBox(height: 12),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState!.save();
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        _isSubmitting = true;
                        _emailErr = '';
                        setState(() {});
                        await submitContactForm();
                      } else {
                        _isSubmitting = false;
                        setState(() {});
                      }
                    },
                    child: const Text('Submit'),
                  ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    ));
  }
}
