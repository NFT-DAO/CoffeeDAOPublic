import 'package:flutter/material.dart';

class ZipTextForm extends StatefulWidget {
  TextEditingController zip;
  String zipError;
  bool isSubmitting;
  ZipTextForm({required this.zip,required this.zipError,required this.isSubmitting, super.key});

  @override
  State<ZipTextForm> createState() => _ZipTextFormState();
}

class _ZipTextFormState extends State<ZipTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('zip'),
      controller: widget.zip,
      autocorrect: false,
      textCapitalization:
          TextCapitalization.none,
      enableSuggestions: true,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty ||
            !RegExp(r"^[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$",
                    caseSensitive: false)
                .hasMatch(value)) {
          setState(() {
            widget.zipError =
                'Please enter a valid zip code.';
            widget.isSubmitting = false;
          });
          return widget.zipError;
        } else {
          widget.zipError = '';
          setState(() {});
          return null;
        }
      },
      decoration: const InputDecoration(
        labelText: 'Zip Code',
      ),
    );
  }
}