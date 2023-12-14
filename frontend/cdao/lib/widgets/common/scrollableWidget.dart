import 'package:flutter/material.dart';

class ScrollableWidget extends StatelessWidget {
  final Widget child;

  ScrollableWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

 final _scrollController1 = ScrollController();
 final _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) => Scrollbar(
        controller: _scrollController1,
        child: SingleChildScrollView(
            controller: _scrollController1,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Scrollbar(
        controller: _scrollController2,
        child: SingleChildScrollView(
            controller: _scrollController2,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: child,
            ),
          ),
        ),
  );
}