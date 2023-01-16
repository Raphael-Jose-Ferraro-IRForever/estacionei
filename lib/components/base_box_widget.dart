import 'package:flutter/material.dart';

class BaseBoxWidget extends StatelessWidget {
  final Color color;
  final double? width;
  final double? height;
  final Widget child;

  const BaseBoxWidget(
      {required this.color,
      this.width,
      required this.child,
      this.height,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color
      ),
      width: width,
      height: height,
      alignment: Alignment.center,
      child: child
    );
  }
}
