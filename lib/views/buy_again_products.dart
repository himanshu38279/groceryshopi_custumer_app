import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/components/product_card_horizontal.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/products_controller.dart';

class BuyAgainProductsScreen extends StatelessWidget {
  static const id = 'buy_again_products_screen';

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<ProductsController>(context);
    final _products = _controller.getBuyAgainProducts();
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: id,
          title: Text("Buy Again"),
        ),
        body: _controller.getBuyAgainProductsLoading()
            ? ShimmerList()
            : _products.isEmpty
                ? NothingFoundHere()
                : ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      return ProductCardHorizontal(_products[index]);
                    },
                    itemCount: _products.length,
                  ),
      ),
    );
  }
}
