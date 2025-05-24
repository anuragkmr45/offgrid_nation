import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;

  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    // Currently using the same styling for both platforms.
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? const Color(0xFF5E5E5E),
        fontWeight: fontWeight,
      ),
    );
  }
}
