import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/components/order_card.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/orders_controller.dart';

class MyOrdersScreen extends StatelessWidget {
  static const id = 'my_order_screen';

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<OrdersController>(context);
    final _orders = _controller.orders;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: id,
          title: Text("My Orders"),
        ),
        body: _controller.ordersLoading
            ? ShimmerList()
            : _orders.isEmpty
                ? NothingFoundHere()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return OrderCard(_orders[index]);
                    },
                    itemCount: _orders.length,
                  ),
      ),
    );
  }
}
