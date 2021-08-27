import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String unit;
  final int width;
  final EdgeInsets margin;
  final bool selected;
  final VoidCallback onTap;

  TextContainer(
    this.unit, {
    this.onTap,
    this.width = 100,
    this.margin = EdgeInsets.zero,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        height: 30,
        width: this.width.toDouble(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: this.margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).accentColor : Colors.white,
          border: Border.all(
            color: Theme.of(context).accentColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: FittedBox(
          child: Text(
            this.unit,
            style: TextStyle(color: selected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
