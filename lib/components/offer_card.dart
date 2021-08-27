import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/my_button.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/models/offer.dart';
import 'package:tbo_the_best_one/views/products_by_offer_screen.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  OfferCard(this.offer);

  final Color _kCardBackgroundColor = Color(0xFFFEF4F2);
  final Color _kBorderColor = Color(0xFFC7BFB9);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: CustomContainer(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductsByOfferScreen.id,
            arguments: offer,
          );
        },
        height: 170,
        width: 300,
        borderColor: _kBorderColor,
        padding: 15,
        borderRadius: 10,
        shadowColor: Colors.grey,
        margin: EdgeInsets.only(left: 10),
        backgroundColor: _kCardBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.offerTitle.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  HtmlWidget(offer.offerDesc),
                  Text(
                    offer.amountAsString,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  MyButton(
                    text: "Shop Now",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProductsByOfferScreen.id,
                        arguments: offer,
                      );
                    },
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 3 / 4,
              child: MyCachedNetworkImage(
                url: offer.offerImage,
                borderRadius: 10,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
