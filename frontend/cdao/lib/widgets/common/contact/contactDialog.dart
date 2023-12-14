import 'package:flutter/material.dart';
import 'contactDialogForm.dart';

class ContactDialog extends StatefulWidget {
  const ContactDialog({Key? key}) : super(key: key);

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const ContactForm());
  }
}