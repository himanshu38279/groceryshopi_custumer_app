import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/models/order_detail.dart';
import 'package:tbo_the_best_one/views/order_details_screen.dart';
import 'package:tbo_the_best_one/views/order_success_screen.dart';

class OrderCard extends StatelessWidget {
  final OrderDetail order;

  const OrderCard(this.order);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Placed on ${order.date}",
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${order.orderProducts.length} items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                order.totalAsString,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text("Order ID : ${order.id}"),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(width: 5),
              Text(
                order.saleStatus,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
          MyButton(
            text: "View Details",
            onTap: () {
              Navigator.pushNamed(
                context,
                OrderDetailsScreen.id,
                arguments: order,
              );
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
