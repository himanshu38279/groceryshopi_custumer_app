import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/views/my_cart_screen.dart';

class CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartController cart = Provider.of<CartController>(context);
    return cart.cartIsLoading
        ? CustomLoader()
        : Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, MyCart.id),
                  icon: Icon(Icons.shopping_cart),
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                ),
                Positioned(
                  top: 3,
                  right: 3,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Theme.of(context).accentColor,
                    child: Text(
                      cart.itemCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
