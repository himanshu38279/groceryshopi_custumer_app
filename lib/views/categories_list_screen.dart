import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/categories_list.dart';
import 'package:tbo_the_best_one/components/my_app_bar.dart';

class CategoriesListScreen extends StatelessWidget {
  static const id = 'categories_list_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          screenId: id,
          title: Text("All Categories"),
        ),
        body: CategoriesList(shrinkWrap: false, scrollable: true),
      ),
    );
  }
}
