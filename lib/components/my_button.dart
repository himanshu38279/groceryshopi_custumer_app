import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;
  final double width;
  final EdgeInsets margin;

  MyButton({
    @required this.text,
    @required this.onTap,
    this.width,
    this.backgroundColor = kAccentColor,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.all(10.0),
    this.margin = EdgeInsets.zero,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: this.onTap,
      height: 40,
      width: this.width,
      margin: this.margin,
      backgroundColor: this.backgroundColor,
      child: Text(
        this.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: this.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
