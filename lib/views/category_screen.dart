import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';
import 'package:tbo_the_best_one/components/nothing_found_here.dart';
import 'package:tbo_the_best_one/components/product_card_horizontal.dart';
import 'package:tbo_the_best_one/components/shimmers.dart';
import 'package:tbo_the_best_one/controllers/categories_controller.dart';
import 'package:tbo_the_best_one/controllers/products_controller.dart';
import 'package:tbo_the_best_one/models/category.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatelessWidget {
  static const id = 'category_screen';
  final Category category;
  final initialIndex;

  CategoryScreen({
    @required this.category,
    this.initialIndex = 0,
  });

  List<Category> _subCategories;
  ProductsController _productsController;

  @override
  Widget build(BuildContext context) {
    final categoriesController = Provider.of<CategoriesController>(context);
    _subCategories = categoriesController.getSubCategories(category.id);
    _productsController = Provider.of<ProductsController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(this.category.name),
          screenId: CategoryScreen.id,
        ),
        body: categoriesController.subCategoriesLoading
            ? ShimmerList()
            : _subCategories.isEmpty
                ? _productsList()
                : _buildCategoriesTabView(context),
      ),
    );
  }

  Widget _buildCategoriesTabView(BuildContext context) {
    final _categories = [this.category] + _subCategories ?? [];
    return DefaultTabController(
      initialIndex: _categories == null ? null : this.initialIndex ?? 0,
      length: _categories.length,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 10),
              ],
            ),
            child: TabBar(
              isScrollable: true,
              physics: const BouncingScrollPhysics(),
              indicatorColor: Theme.of(context).accentColor,
              labelPadding: EdgeInsets.all(10),
              tabs: _categories
                  .map(
                    (e) => Text(
                      e.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: _categories
                  .map((e) => _productsList(subCategoryId: e.id))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productsList({String subCategoryId}) {
    if (category.id == subCategoryId) subCategoryId = null;
    final _products = _productsController.getCategoryProducts(
      categoryId: category.id,
      subCategoryId: subCategoryId,
    );
    if (_productsController.getCategoryProductsLoading(
      categoryId: category.id,
      subCategoryId: subCategoryId,
    ))
      return ShimmerList();
    else if (_products.isEmpty)
      return NothingFoundHere();
    else
      return ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return ProductCardHorizontal(_products[index]);
        },
        itemCount: _products.length,
      );
  }
}
