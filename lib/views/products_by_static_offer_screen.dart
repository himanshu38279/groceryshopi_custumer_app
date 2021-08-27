import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/components/product_card_horizontal.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/products_controller.dart';
import 'package:tbo_the_best_one/models/offer.dart';

class ProductsByStaticOfferScreen extends StatelessWidget {
  static const id = 'products_by_static_offer_screen';
  final Offer offer;

  const ProductsByStaticOfferScreen({@required this.offer});

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<ProductsController>(context);
    final _products = _controller.getStaticOfferProducts(offer.offerId);
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(offer.amountAsString),
          screenId: id,
        ),
        body: _controller.getStaticOfferProductsLoading(offer.offerId)
            ? ShimmerList()
            : _products.isEmpty
                ? NothingFoundHere()
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      return ProductCardHorizontal(_products[index]);
                    },
                    itemCount: _products.length,
                  ),
      ),
    );
  }
}
