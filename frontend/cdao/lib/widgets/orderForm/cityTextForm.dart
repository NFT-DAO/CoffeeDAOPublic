import 'package:flutter/material.dart';

class CityTextForm extends StatefulWidget {
  TextEditingController city;
  String cityError;
  bool isSubmitting;
  CityTextForm({required this.city,required this.cityError,required this.isSubmitting, super.key});

  @override
  State<CityTextForm> createState() => _CityTextFormState();
}

class _CityTextFormState extends State<CityTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('city'),
      // initialValue: city,
      controller: widget.city,
      autocorrect: false,
      textCapitalization:
          TextCapitalization.words,
      enableSuggestions: true,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          widget.cityError =
              '''Please enter your city or town's name.''';
          widget.isSubmitting = false;
          setState(() {});
          return widget.cityError;
        } else {
          widget.cityError = '';
          setState(() {});
          return null;
        }
      },
      decoration: const InputDecoration(
        labelText: 'City/Town',
      ),
    );
  }
}