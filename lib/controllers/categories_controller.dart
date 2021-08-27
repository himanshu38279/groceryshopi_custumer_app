import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/models/get_categories.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/category.dart';

class CategoriesController extends ChangeNotifier {
  List<Category> categories;
  Map<String, Category> _categoriesMap;
  Map<String, List<Category>> _subCategoriesMap;

  bool categoriesLoading;
  bool subCategoriesLoading;

  Category getCategory(String categoryId) => _categoriesMap[categoryId];

  List<Category> getSubCategories(String categoryId) =>
      _subCategoriesMap[categoryId] ?? [];

  CategoriesController() {
    categories = [];
    _categoriesMap = {};
    _subCategoriesMap = {};
    categoriesLoading = true;
    subCategoriesLoading = true;
    this.update();
  }

  Future<void> update() async {
    await this._updateCategories();
    await this._updateSubCategories();
  }

  Future<void> _updateCategories() async {
    categoriesLoading = true;
    notifyListeners();
    final temp = await Repository.getCategories();
    categories = temp?.categories ?? [];
    for (Category category in categories)
      _categoriesMap[category.id] = category;
    categoriesLoading = false;
    notifyListeners();
  }

  Future<void> _updateSubCategories() async {
    subCategoriesLoading = true;
    notifyListeners();
    if (categories != null) {
      List<Future<GetCategories>> _futures = [];
      List<String> _ids = [];
      for (Category category in categories) {
        _ids.add(category.id);
        _futures.add(Repository.getSubCategories(id: category.id));
      }
      int index = 0;
      final res = await Future.wait(_futures);
      for (GetCategories getCategory in res)
        _subCategoriesMap[_ids[index++]] = getCategory.categories;
    }
    subCategoriesLoading = false;
    notifyListeners();
  }
}
