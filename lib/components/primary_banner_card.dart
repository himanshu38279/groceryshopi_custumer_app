import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/controllers/categories_controller.dart';
import 'package:tbo_the_best_one/models/primary_banner.dart';
import 'package:tbo_the_best_one/views/category_screen.dart';

class PrimaryBannerCard extends StatelessWidget {
  final PrimaryBanner banner;

  const PrimaryBannerCard(this.banner);

  @override
  Widget build(BuildContext context) {
    final categoriesController = Provider.of<CategoriesController>(context);
    return CustomContainer(
      onTap: () {
        final category = categoriesController.getCategory(banner.categoryId);
        if (category != null)
          Navigator.pushNamed(
            context,
            CategoryScreen.id,
            arguments: {'category': category},
          );
      },
      padding: 0,
      child: Column(
        children: [
          MyCachedNetworkImage(
            url: banner.image,
            height: 200,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: HtmlWidget(banner.description),
          ),
        ],
      ),
    );
  }
}
