import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tbo_the_best_one/models/order_detail.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

import 'order_details_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  static const id = 'order_successfully_placed_screen';
  final OrderDetail details;
  OrderSuccessScreen({this.details});

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/order-placed.json', height: 300),
            Text(
              "You order has been placed",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              "Order Id: ${widget.details.id}",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              "Payment Status: ${widget.details.paymentMethod}",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            TextButton(onPressed: (){
              Navigator.pushNamed(
                context,
                OrderDetailsScreen.id,
                arguments: widget.details,
              );
            }, child: Text("See Details"))
          ],
        ),
      ),
    );
  }
}
