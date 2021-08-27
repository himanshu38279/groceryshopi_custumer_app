import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/views/product_details_page.dart';

import 'cart_add_button.dart';
import 'discount_card.dart';

class ProductCardHorizontal extends StatelessWidget {
  final Product product;

  const ProductCardHorizontal(this.product);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    return CardLoadingOverlay(
      isLoading: cart.getLoadingStatus(product.id),
      child: CustomContainer(
        margin: EdgeInsets.only(bottom: 5),
        onTap: () {
          this.product.productVariants ??= [];
          Navigator.pushNamed(
            context,
            ProductDetailsPage.id,
            arguments: this.product,
          );
        },
        child: Row(
          children: [
            MyCachedNetworkImage(
              url: this.product.image,
              borderRadius: 10,
              width: 125,
              height: 125,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          this.product.name,
                          softWrap: true,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      cart.getItemCount(product.id) >= 1
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.clear),
                              onPressed: () async {
                                cart.startLoading(product.id);
                                final res = await Repository.removeFromCart(
                                  productId: this.product.id,
                                  quantity: 0,
                                );
                                cart.stopLoading(product.id);
                                if (res ?? false) {
                                  cart.removeProduct(this.product.id);
                                  Fluttertoast.showToast(
                                      msg: "Product removed from cart");
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "An error occurred while removing product from cart",
                                  );
                                }
                              },
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        this.product.priceAsString,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      if (this.product.isOnDiscount) ...[
                        Text(
                          this.product.originalPriceAsString,
                          style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10),
                        DiscountCard(this.product.discount, small: true),
                      ]
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        this.product.productUnit,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Spacer(),
                      CardAddButton(
                        height: 30,
                        width: 100,
                        product: this.product,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
