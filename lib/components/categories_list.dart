import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/sub_category_card.dart';
import 'package:tbo_the_best_one/controllers/categories_controller.dart';
import 'package:tbo_the_best_one/models/category.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

import 'custom_loader.dart';
import 'my_cached_network_image.dart';
import 'nothing_found_here.dart';

// ignore: must_be_immutable
class CategoriesList extends StatelessWidget {
  final bool scrollable;
  final bool shrinkWrap;

  CategoriesList({
    this.scrollable = false,
    this.shrinkWrap = true,
  });

  CategoriesController controller;

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<CategoriesController>(context);
    if (controller.categoriesLoading)
      return CustomLoader();
    else if (controller.categories.isEmpty)
      return SizedBox.shrink();
    else
      return ListView.separated(
        shrinkWrap: this.shrinkWrap,
        physics: this.scrollable ? null : NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => Container(
          height: 10,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, categoryIndex) {
          final category = controller.categories[categoryIndex];
          return _buildSubCategoryExpansionTile(category);
        },
        itemCount: controller.categories.length,
      );
  }

  ExpansionTile _buildSubCategoryExpansionTile(Category category) {
    final _subCategories = controller.getSubCategories(category.id);
    return ExpansionTile(
      tilePadding: EdgeInsets.all(10),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.title.toUpperCase(),
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3),
          Text(category.name),
          SizedBox(height: 3),
        ],
      ),
      leading: MyCachedNetworkImage(
        url: category.image2,
        width: 100,
        height: double.infinity,
        borderRadius: 5,
      ),
      subtitle: Text(
        category.subCategories,
        style: TextStyle(color: Colors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      childrenPadding: EdgeInsets.all(5),
      backgroundColor: kLightYellow,
      // collapsedBackgroundColor: Colors.white,
      children: [
        if (controller.subCategoriesLoading)
          CustomLoader()
        else if (_subCategories.isEmpty)
          NothingFoundHere()
        else
          Card(
            color: Colors.white,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                return SubCategoryCard(
                  category: category,
                  subCategory: _subCategories[index],
                  // +1 as first is main category itself
                  subCategoryIndex: index + 1,
                );
              },
              itemCount: _subCategories.length,
            ),
          ),
      ],
    );
  }
}
