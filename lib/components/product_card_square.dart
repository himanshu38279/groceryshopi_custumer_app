import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/cart_add_button.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/views/product_details_page.dart';

import 'discount_card.dart';

class ProductCardSquare extends StatelessWidget {
  final Product product;

  const ProductCardSquare(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        ProductDetailsPage.id,
        arguments: product,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: MyCachedNetworkImage(
                      url: product.image,
                      borderRadius: 10,
                      height: double.infinity,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        product.priceAsString,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.isOnDiscount) ...[
                        Text(
                          product.originalPriceAsString,
                          style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        DiscountCard(product.discount),
                      ]
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.productUnit,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            CardAddButton(product: this.product),
          ],
        ),
      ),
    );
  }
}
