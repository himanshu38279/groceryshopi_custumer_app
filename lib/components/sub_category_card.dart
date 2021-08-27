import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/my_cached_network_image.dart';
import 'package:tbo_the_best_one/models/category.dart';
import 'package:tbo_the_best_one/views/category_screen.dart';

class SubCategoryCard extends StatelessWidget {
  final Category category;
  final Category subCategory;
  final int subCategoryIndex;
  final EdgeInsets padding;

  SubCategoryCard({
    this.category,
    this.subCategory,
    this.subCategoryIndex,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          CategoryScreen.id,
          arguments: {
            'category': category,
            'initialIndex': subCategoryIndex,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: MyCachedNetworkImage(
                url: subCategory.image,
                borderRadius: 7,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subCategory.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
