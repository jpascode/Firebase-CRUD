import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final bool isCenter;
  final bool underline;
  const SmallText({super.key,
    required this.text,
    this.color = Colors.black,
    this.size = 15,
    this.isCenter = false,
    this.underline = false
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: isCenter?TextAlign.center:TextAlign.left,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w400,
          decoration: underline?TextDecoration.underline:TextDecoration.none
      ),
    );
  }
}
