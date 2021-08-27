import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/views/my_cart_screen.dart';
import 'package:tbo_the_best_one/views/place_order_screen.dart';

class BottomCheckoutContainer extends StatelessWidget {
  final String screenId;
  final VoidCallback onTap;

  BottomCheckoutContainer({@required this.screenId, @required this.onTap});

  String get title {
    switch (screenId) {
      case MyCart.id:
        return "Checkout";
      case PlaceOrderScreen.id:
        return "Place Order";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CartController cart = Provider.of<CartController>(context);
    if (cart.isEmpty) return SizedBox.shrink();
    return InkWell(
      onTap: this.onTap,
      child: Container(
        color: Theme.of(context).appBarTheme.color,
        height: 50,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              this.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            Spacer(),
            Text(
              cart.totalAsString,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
