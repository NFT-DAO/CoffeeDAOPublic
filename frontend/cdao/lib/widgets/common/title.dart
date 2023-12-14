import 'package:flutter/material.dart';
import 'package:responsive_framework/max_width_box.dart';

class TitleWidget extends StatefulWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return MaxWidthBox(  
              maxWidth: 200,
              child: Image.asset('lib/assets/images/logo.png'));
  }
}
