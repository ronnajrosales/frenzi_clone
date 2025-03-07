import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnderlinedTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double fontSize;
  final Color color;
  final double underlineThickness;

  const UnderlinedTextButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.fontSize = 16,
    this.color = Colors.white,
    this.underlineThickness = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: color,
          decorationThickness: underlineThickness,
        ),
      ),
    );
  }
} 