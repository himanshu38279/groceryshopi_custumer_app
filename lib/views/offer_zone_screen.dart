import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/components/primary_banner_card.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/banners_controller.dart';

class OfferZoneScreen extends StatelessWidget {
  static const id = 'offer_zone_screen';

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BannersController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: id,
          title: Text("Offer Zone"),
        ),
        body: controller.primaryBannersLoading
            ? ShimmerList()
            : controller.primaryBanners.isEmpty
                ? NothingFoundHere()
                : ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      return PrimaryBannerCard(
                          controller.primaryBanners[index]);
                    },
                    itemCount: controller.primaryBanners.length,
                  ),
      ),
    );
  }
}
