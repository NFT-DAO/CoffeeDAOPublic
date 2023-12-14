import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/firebaseRTDBProvider.dart';

class EmailInputField extends StatefulWidget {
  const EmailInputField({super.key});

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  String? email1;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
        backgroundColor: const Color.fromRGBO(36, 32, 32, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      child: Consumer<DB>(builder: (context, db, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: width/2,
            height:  width/6,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          hintStyle:const TextStyle(color: Colors.white,),
                          errorText: errorMessage,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              email1 = null;
                              errorMessage = 'Please enter some text';
                            });
                            return 'Please enter some text';
                          } else {
                            if (!EmailValidator.validate(value)) {
                              setState(() {
                                email1 = null;
                                errorMessage = 'Please enter a valid email';
                              });
                              return 'Please enter a valid email';
                            } else {
                              setState(() {
                                email1 = value;
                              });
                              return null;
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      db.notifyEntry(email1 as String);
                      Navigator.pop(context, 'result');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Notify Me!',style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
