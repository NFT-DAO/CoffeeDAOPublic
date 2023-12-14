import 'package:flutter/material.dart';

Future<T?> showPathDialog<T>(BuildContext context,
        {required String path}) =>
    showDialog<T>(
      context: context,
      builder: (context) => TextDialogWidget(path: path),
    );

class TextDialogWidget extends StatefulWidget {
  final String path;

  const TextDialogWidget({Key? key, required this.path}) : super(key: key);

  @override
  TextDialogWidgetState createState() => TextDialogWidgetState();
}

class TextDialogWidgetState extends State<TextDialogWidget> {
  @override
  Widget build(BuildContext context) => Dialog(
    child: SelectableText(widget.path),
      );
}
