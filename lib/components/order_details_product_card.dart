import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/cart_controller.dart';
import 'package:tbo_the_best_one/models/order_detail.dart';

import 'custom_loader.dart';

class OrderDetailsProductCard extends StatelessWidget {
  final OrderProduct product;

  const OrderDetailsProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    return CardLoadingOverlay(
      isLoading: cart.getLoadingStatus(product.id),
      child: InkWell(
        // is cart product if variants null
        // onTap: () => this.product.productVariants == null
        //     ? null
        //     : Navigator.pushNamed(
        //   context,
        //   ProductDetailsPage.id,
        //   arguments: this.product,
        // ),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
          ),
          child: Row(
            children: [
              if (this.product.image == null)
                FutureBuilder<String>(
                  future: Repository.getProductMainImage(
                    productId: this.product.productId,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return MyCachedNetworkImage(
                        url: snapshot.data,
                        borderRadius: 10,
                        width: 100,
                        height: 100,
                      );
                    else
                      return ContainerShimmer(
                        height: 100,
                        width: 100,
                        borderRadius: 10,
                      );
                  },
                )
              else
                MyCachedNetworkImage(
                  url: this.product.image,
                  borderRadius: 10,
                  width: 100,
                  height: 100,
                ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      this.product.productName,
                      softWrap: true,
                      style: TextStyle(fontSize: 19),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          this.product.unitPriceAsString,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "x${product.quantity}",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // if (this.product.isOnDiscount) ...[
                        //   Text(
                        //     this.product.originalPriceAsString,
                        //     style: TextStyle(
                        //       fontSize: 15,
                        //       decoration: TextDecoration.lineThrough,
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        //   SizedBox(width: 10),
                        //   DiscountCard(int.tryParse(this.product.itemDiscount), small: true),
                        // ]
                      ],
                    ),
                    // SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Text(
                    //       this.product.unitQuantity,
                    //       style: TextStyle(color: Colors.grey),
                    //     ),
                    //     Spacer(),
                    //     // CardAddButton(
                    //     //   height: 30,
                    //     //   width: 100,
                    //     //   product: this.product,
                    //     // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
