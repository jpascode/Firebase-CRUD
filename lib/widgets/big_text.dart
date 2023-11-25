import 'package:flutter/material.dart';
class BigText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final bool isCenter;
  final bool underline;
  const BigText({super.key,
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
        fontWeight: FontWeight.bold,
        decoration: underline?TextDecoration.underline:TextDecoration.none
      ),
    );
  }
}
