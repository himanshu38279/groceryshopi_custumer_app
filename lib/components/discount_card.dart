import 'package:flutter/material.dart';

class DiscountCard extends StatelessWidget {
  final int discount;
  final bool small;

  DiscountCard(this.discount, {this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: small ? 60 : 70,
      height: small ? 20 : 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        "$discount% OFF",
        style: TextStyle(
          color: Colors.white,
          fontWeight: small ? FontWeight.normal : FontWeight.w600,
          fontSize: small ? 12 : 15,
        ),
      ),
    );
  }
}
