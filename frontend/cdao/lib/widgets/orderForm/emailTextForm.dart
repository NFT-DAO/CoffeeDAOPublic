import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'formError.dart';

class EmailTextForm extends StatefulWidget {
  TextEditingController email1;
  TextEditingController email2;
  String emailError;
  bool isSubmitting;
  EmailTextForm(
      {required this.email1,
      required this.email2,
      required this.emailError,
      required this.isSubmitting,
      super.key});

  @override
  State<EmailTextForm> createState() => _EmailTextFormState();
}

class _EmailTextFormState extends State<EmailTextForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            key: const ValueKey('email1'),
            autocorrect: false,
            controller: widget.email1,
            textCapitalization: TextCapitalization.none,
            enableSuggestions: true,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty || !EmailValidator.validate(value)) {
                widget.emailError = '''Please enter a valid email.''';
                widget.isSubmitting = false;
                setState(() {});
                return widget.emailError;
              } else {
                widget.emailError = '';
                setState(() {});
                return null;
              }
            },
            decoration: const InputDecoration(
              labelText: 'Email',
            )),
        FormError(error: widget.emailError),
        const SizedBox(
          height: 12,
        ),
        //email
        TextFormField(
          key: const ValueKey('email2'),
          autocorrect: false,
          controller: widget.email2,
          textCapitalization: TextCapitalization.none,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty || value != widget.email1.text) {
              widget.emailError = '''Emails Don't Match''';
              widget.isSubmitting = false;
              setState(() {});
              return widget.emailError;
            } else {
              widget.emailError = '';
              setState(() {});
              return null;
            }
          },
          decoration: const InputDecoration(
            labelText: 'Re-Enter Your Email',
          ),
        )
      ],
    );
  }
}
