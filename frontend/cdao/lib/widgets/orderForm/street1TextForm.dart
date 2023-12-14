import 'package:flutter/material.dart';

class Street1TextForm extends StatefulWidget {
  TextEditingController street1;
  String streetError;
  bool isSubmitting;
  Street1TextForm({required this.street1,required this.streetError,required this.isSubmitting, super.key});

  @override
  State<Street1TextForm> createState() => _Street1TextFormState();
}

class _Street1TextFormState extends State<Street1TextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('street1'),
      // initialValue: street1,
      controller: widget.street1,
      autocorrect: false,
      textCapitalization:
          TextCapitalization.words,
      enableSuggestions: true,
      keyboardType: TextInputType.streetAddress,
      validator: (value) {
        if (value!.isEmpty) {
          widget.streetError =
              '''Please enter your street address.''';
          widget.isSubmitting = false;
          setState(() {});
          return widget.streetError;
        } else {
          widget.streetError = '';
          setState(() {});
          return null;
        }
      },
      decoration: const InputDecoration(
        labelText: 'Street Address/P.O. Box',
      ),
    );
  }
}