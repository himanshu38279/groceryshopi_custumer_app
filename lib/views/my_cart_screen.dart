import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/add_a_tip_container.dart';
import 'package:tbo_the_best_one/components/bottom_checkout_container.dart';
import 'package:tbo_the_best_one/components/cart_summary_container.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/components/product_card_horizontal.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/models/cart.dart';
import 'package:tbo_the_best_one/models/user.dart';
import 'package:tbo_the_best_one/views/login_screen.dart';
import 'package:tbo_the_best_one/views/my_profile_screen.dart';
import 'package:tbo_the_best_one/views/place_order_screen.dart';

class MyCart extends StatelessWidget {
  static const id = 'my_cart';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final cart = Provider.of<CartController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: MyCart.id,
          title: RichText(
            text: TextSpan(
              style: TextStyle(fontFamily: 'ProductSans'),
              children: <TextSpan>[
                TextSpan(
                  text: "My Cart\n",
                  style: TextStyle(fontSize: 17),
                ),
                TextSpan(
                  text: cart.itemCountAsString,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomCheckoutContainer(
          screenId: id,
          onTap: () {
            if (user.isLoggedIn) {
              if (user.firstName == null || user.lastName == null) {
                Fluttertoast.showToast(
                    msg: "Please complete your profile before placing order");
                Navigator.pushNamed(context, MyProfileScreen.id);
              } else {
                Navigator.pushNamed(context, PlaceOrderScreen.id);
              }
            }
          },
        ),
        body: cart.cartIsLoading
            ? ShimmerList()
            : RefreshIndicator(
                onRefresh: () async {
                  if (user.isLoggedIn)
                    await cart.update();
                  else
                    Fluttertoast.showToast(msg: "Please login");
                },
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [
                    CartSummaryContainer(),
                    if (user.isLoggedIn)
                      _buildCartProductsListView(cart.cartProducts)
                    else
                      MyButton(
                        text: "Login to access cart",
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    AddATipContainer(),
                    // _buildCartProductsListView(cart),
                    // ProductListView(title: "Fresh Fruits and Veggies"),
                    // ProductListView(title: "Top Selling Items"),
                    // if (!cart.isEmpty)
                    //   ProductListView(
                    //     title: "Frequently Bought Together",
                    //     categoryId: cart.cartProducts.first.product.categoryId,
                    //   ),
                  ],
                ),
              ),
      ),
    );
  }

  ListView _buildCartProductsListView(List<CartProduct> products) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ProductCardHorizontal(products[index].product);
      },
      itemCount: products.length,
    );
  }
}
