import 'package:flutter/material.dart';

class NameTextForm extends StatefulWidget {
  TextEditingController name;
  String nameError;
  bool isSubmitting;
  NameTextForm({required this.name,required this.nameError,required this.isSubmitting, super.key});

  @override
  State<NameTextForm> createState() => _NameTextFormState();
}

class _NameTextFormState extends State<NameTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('name'),
      controller: widget.name,
      autocorrect: false,
      textCapitalization:
          TextCapitalization.words,
      enableSuggestions: true,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          widget.nameError =
              '''Please enter your name.''';
          widget.isSubmitting = false;
          setState(() {});
          return widget.nameError;
        } else {
          widget.nameError = '';
          setState(() {});
          return null;
        }
      },
      decoration: const InputDecoration(
        labelText: 'Your Name',
      ),
    );
  }
}