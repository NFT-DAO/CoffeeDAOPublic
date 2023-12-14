import 'package:flutter/material.dart';

class PhoneTextForm extends StatefulWidget {
  String? phone;
  PhoneTextForm({required this.phone, super.key});

  @override
  State<PhoneTextForm> createState() => _PhoneTextFormState();
}

class _PhoneTextFormState extends State<PhoneTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('phone'),
      autocorrect: false,
      textCapitalization:
          TextCapitalization.none,
      enableSuggestions: true,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone Number(Optional)',
      ),
      onChanged: (value) {
        widget.phone = value;
      },
      onSaved: (value) {
        widget.phone = value;
      },
    );
  }
}