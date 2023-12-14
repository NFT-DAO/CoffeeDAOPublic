import 'package:flutter/material.dart';

class Street2TextForm extends StatefulWidget {
  TextEditingController street2;
  Street2TextForm({required this.street2, super.key});

  @override
  State<Street2TextForm> createState() => _Street2TextFormState();
}

class _Street2TextFormState extends State<Street2TextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('street2'),
      controller: widget.street2,
      autocorrect: false,
      textCapitalization:
          TextCapitalization.words,
      enableSuggestions: false,
      keyboardType: TextInputType.streetAddress,
      decoration: const InputDecoration(
        labelText: 'Street Address Second Line(as needed)',
      ),
    );
  }
}