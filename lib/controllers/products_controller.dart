import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/models/post_products.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/product.dart';

class ProductsController extends ChangeNotifier {
  Map<String, PostProducts> _staticOfferProductsMap;
  Map<String, bool> _staticOfferProductsLoaders;
  Map<String, PostProducts> _offerProductsMap;
  Map<String, bool> _offerProductsLoaders;
  Map<String, PostProducts> _brandProductsMap;
  Map<String, bool> _brandProductsLoaders;
  PostProducts _buyAgainProducts;
  bool _buyAgainProductsLoading;

  // map of category id containing map of subcategory id with PostProducts
  Map<String, Map<String, PostProducts>> _categoryProductsMap;
  Map<String, Map<String, bool>> _categoryProductsLoaders;

  ProductsController() {
    _staticOfferProductsMap = {};
    _staticOfferProductsLoaders = {};
    _offerProductsMap = {};
    _offerProductsLoaders = {};
    _brandProductsMap = {};
    _brandProductsLoaders = {};
    _categoryProductsMap = {};
    _categoryProductsLoaders = {};

    _buyAgainProductsLoading = true;
  }

  void clear() {
    _buyAgainProducts = null;
    notifyListeners();
  }

  Future<void> update() async {
    // called when new user logs in

    // buy again products will be different for every user
    _buyAgainProducts = null;
    await this._updateBuyAgainProducts();
  }

  ////////////////////////////////////////////////////////////
  // CATEGORY PRODUCTS
  ////////////////////////////////////////////////////////////

  List<Product> getCategoryProducts({String categoryId, String subCategoryId}) {
    // call update when getting products and call api if it is null
    this._updateCategoryProducts(categoryId, subCategoryId);
    return _categoryProductsMap[categoryId][subCategoryId]?.products ?? [];
  }

  bool getCategoryProductsLoading({
    String categoryId,
    String subCategoryId,
  }) {
    _categoryProductsLoaders[categoryId] ??= {};
    // return true if null as never called before
    return _categoryProductsLoaders[categoryId][subCategoryId] ?? true;
  }

  Future<void> _updateCategoryProducts(
    String categoryId,
    String subCategoryId,
  ) async {
    _categoryProductsMap[categoryId] ??= {};
    if (_categoryProductsMap[categoryId][subCategoryId] == null) {
      _categoryProductsMap[categoryId][subCategoryId] =
          await Repository.getProducts(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
      );
      _categoryProductsLoaders[categoryId][subCategoryId] = false;
      notifyListeners();
    }
  }

  ////////////////////////////////////////////////////////////
  // BUY AGAIN PRODUCTS
  ////////////////////////////////////////////////////////////

  List<Product> getBuyAgainProducts() {
    // call update when getting products and call api if it is null
    this._updateBuyAgainProducts();
    return _buyAgainProducts?.products ?? [];
  }

  bool getBuyAgainProductsLoading() =>
      // return true if null as never called before
      _buyAgainProductsLoading ?? true;

  Future<void> _updateBuyAgainProducts() async {
    if (_buyAgainProducts == null) {
      _buyAgainProducts = await Repository.getBuyAgainProducts();
      _buyAgainProductsLoading = false;
      notifyListeners();
    }
  }

  ////////////////////////////////////////////////////////////
  // BRAND PRODUCTS
  ////////////////////////////////////////////////////////////

  List<Product> getBrandProducts(String id) {
    // call update when getting products and call api if it is null
    this._updateBrandProducts(id);
    return _brandProductsMap[id]?.products ?? [];
  }

  bool getBrandProductsLoading(String id) =>
      // return true if null as never called before
      _brandProductsLoaders[id] ?? true;

  Future<void> _updateBrandProducts(String id) async {
    if (_brandProductsMap[id] == null) {
      _brandProductsMap[id] =
          await Repository.getProductsByBrandId(brandId: id);
      _brandProductsLoaders[id] = false;
      notifyListeners();
    }
  }

  ////////////////////////////////////////////////////////////
  // OFFER PRODUCTS
  ////////////////////////////////////////////////////////////

  List<Product> getOfferProducts(String id) {
    // call update when getting products and call api if it is null
    this._updateOfferProducts(id);
    return _offerProductsMap[id]?.products ?? [];
  }

  bool getOfferProductsLoading(String id) =>
      // return true if null as never called before
      _offerProductsLoaders[id] ?? true;

  Future<void> _updateOfferProducts(String id) async {
    if (_offerProductsMap[id] == null) {
      _offerProductsMap[id] =
          await Repository.getProductsByOfferId(offerId: id);
      _offerProductsLoaders[id] = false;
      notifyListeners();
    }
  }

  ////////////////////////////////////////////////////////////
  // STATIC OFFER PRODUCTS
  ////////////////////////////////////////////////////////////

  List<Product> getStaticOfferProducts(String id) {
    // call update when getting products and call api if it is null
    this._updateStaticOfferProducts(id);
    return _staticOfferProductsMap[id]?.products ?? [];
  }

  bool getStaticOfferProductsLoading(String id) =>
      // return true if null as never called before
      _staticOfferProductsLoaders[id] ?? true;

  Future<void> _updateStaticOfferProducts(String id) async {
    if (_staticOfferProductsMap[id] == null) {
      _staticOfferProductsMap[id] =
          await Repository.getProductsByStaticOfferId(staticOfferId: id);
      _staticOfferProductsLoaders[id] = false;
      notifyListeners();
    }
  }
}
