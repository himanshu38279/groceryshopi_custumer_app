import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/banners_controller.dart';
import 'package:tbo_the_best_one/controllers/categories_controller.dart';
import 'package:tbo_the_best_one/views/category_screen.dart';

class PrimaryBannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BannersController>(context);
    final categoriesController = Provider.of<CategoriesController>(context);
    if (controller.primaryBannersLoading)
      return ContainerShimmer();
    else if (controller.primaryBanners.isEmpty)
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
                final category = categoriesController
                    .getCategory(controller.primaryBanners[index].categoryId);
                if (category != null)
                  Navigator.pushNamed(
                    context,
                    CategoryScreen.id,
                    arguments: {'category': category},
                  );
              },
              child: MyCachedNetworkImage(
                url: controller.primaryBanners[index].image,
                width: double.infinity,
                height: double.infinity,
                borderRadius: 5,
                zoomToFit: false,
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
            );
          },
          itemCount: controller.primaryBanners.length,
          options: CarouselOptions(
            // enlargeCenterPage: true,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: controller.primaryBanners.length != 1,
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
