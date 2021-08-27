import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/banners_controller.dart';
import 'package:tbo_the_best_one/controllers/brands_controller.dart';
import 'package:tbo_the_best_one/views/products_by_brand_screen.dart';

class SecondaryBannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bannersController = Provider.of<BannersController>(context);
    final _brandsController = Provider.of<BrandsController>(context);
    if (_bannersController.secondaryBannersLoading)
      return ContainerShimmer();
    else if (_bannersController.secondaryBanners.isEmpty)
      return SizedBox.shrink();
    else
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(color: Colors.grey, width: 0.5),
          ),
          color: Color(0xFFF0F0F0),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: CarouselSlider.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                final brand = _brandsController.getBrand(
                  _bannersController.secondaryBanners[index].brandId,
                );
                if (brand != null)
                  Navigator.pushNamed(
                    context,
                    ProductsByBrandScreen.id,
                    arguments: brand,
                  );
              },
              child: MyCachedNetworkImage(
                url: _bannersController.secondaryBanners[index].image,
                width: double.infinity,
                height: double.infinity,
                borderRadius: 5,
                zoomToFit: false,
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
            );
          },
          itemCount: _bannersController.secondaryBanners.length,
          options: CarouselOptions(
            // enlargeCenterPage: true,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll:
                _bannersController.secondaryBanners.length != 1,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 200),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
          ),
        ),
      );
  }
}
