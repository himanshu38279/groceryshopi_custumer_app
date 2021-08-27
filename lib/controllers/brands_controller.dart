import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/brand.dart';

class BrandsController extends ChangeNotifier {
  Map<String, Brand> _brandsMap;
  bool brandsLoading;

  BrandsController() {
    _brandsMap = {};
    brandsLoading = true;
    this.update();
  }

  List<Brand> get brands => _brandsMap.values?.toList() ?? [];

  Future<void> update() async {
    await this._updateBrands();
  }

  Brand getBrand(String id) => _brandsMap[id];

  Future<void> _updateBrands() async {
    brandsLoading = true;
    notifyListeners();
    final res = await Repository.getBrands();
    if (res != null && res?.brands != null && res.brands.isNotEmpty)
      for (Brand brand in res.brands) _brandsMap[brand.id] = brand;
    brandsLoading = false;
    notifyListeners();
  }
}
