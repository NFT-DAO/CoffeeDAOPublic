import 'package:flutter/material.dart';

class FormError extends StatefulWidget {
  String error;
  FormError({required this.error, super.key});

  @override
  State<FormError> createState() => _FormErrorState();
}

class _FormErrorState extends State<FormError> {
  @override
  Widget build(BuildContext context) {
    return widget.error == ''
      ? const SizedBox(
          height: 0,
        )
      : Text(
          widget.error,
          style: const TextStyle(
              color: Colors.red),
        );
  }
}