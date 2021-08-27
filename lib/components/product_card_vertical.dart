import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/cart_add_button.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/custom_loader.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/views/product_details_page.dart';

import 'discount_card.dart';

class ProductCardVertical extends StatelessWidget {
  final Product product;

  const ProductCardVertical(this.product);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    return CustomContainer(
      onTap: () {
        this.product.productVariants ??= [];
        Navigator.pushNamed(
          context,
          ProductDetailsPage.id,
          arguments: product,
        );
      },
      width: 185,
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      padding: 0,
      child: CardLoadingOverlay(
        isLoading: cart.getLoadingStatus(product.id),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (product.isOnDiscount) DiscountCard(product.discount),
              SizedBox(height: 10),
              Expanded(
                child: MyCachedNetworkImage(
                  url: product.image,
                  borderRadius: 10,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.priceAsString,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  if (product.isOnDiscount) ...[
                    Text(
                      product.originalPriceAsString,
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ]
                ],
              ),
              SizedBox(height: 10),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(product.productUnit, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 15),
              CardAddButton(product: this.product, width: double.infinity),
            ],
          ),
        ),
      ),
    );
  }
}
