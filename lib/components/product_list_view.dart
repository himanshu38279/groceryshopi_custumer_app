import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/product_card_vertical.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/categories_controller.dart';
import 'package:tbo_the_best_one/controllers/products_controller.dart';
import 'package:tbo_the_best_one/views/category_screen.dart';

import 'my_button.dart';

class ProductListView extends StatelessWidget {
  final String title;
  final String categoryId;
  final String subCategoryId;

  const ProductListView({
    @required this.title,
    @required this.categoryId,
    this.subCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final _categoriesController = Provider.of<CategoriesController>(context);
    final _productsController = Provider.of<ProductsController>(context);
    final _products = _productsController.getCategoryProducts(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    );

    if (_productsController.getCategoryProductsLoading(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    ))
      return ContainerShimmer(height: 375);
    else if (_products.isEmpty)
      return SizedBox.shrink();
    else
      return Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    this.title,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                MyButton(
                  text: "See all",
                  textColor: Theme.of(context).accentColor,
                  backgroundColor: Colors.white,
                  onTap: () {
                    final category =
                        _categoriesController.getCategory(categoryId);
                    if (category != null)
                      Navigator.pushNamed(
                        context,
                        CategoryScreen.id,
                        arguments: {'category': category},
                      );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 375,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ProductCardVertical(_products[index]);
              },
              itemCount: Math.min<int>(_products.length, 20),
            ),
          ),
        ],
      );
  }
}
