import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/models/get_cart.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/cart.dart';
import 'package:tbo_the_best_one/models/product.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class CartController extends ChangeNotifier {
  Map<String, CartProduct> _cartProductsMap;
  Map<String, bool> loaders;
  bool isLoading;
  bool cartIsLoading;

  CartController() {
    _cartProductsMap = {};
    loaders = {};
    isLoading = false;
    cartIsLoading = false;
  }

  void clear() {
    _cartProductsMap = {};
    loaders = {};
    isLoading = false;
    cartIsLoading = false;
    notifyListeners();
  }

  void startLoading(String id) {
    loaders[id] = true;
    notifyListeners();
  }

  void stopLoading(String id) {
    loaders[id] = false;
    notifyListeners();
  }

  bool getLoadingStatus(String id) => loaders[id] ?? false;

  // int total = 0;
  // int productsTotal = 0;
  // double discount = 0.1;
  int _tipAmount = 0;

  double removedWalletAmount = 0;

  bool get isEmpty => itemCount == 0;

  List<CartProduct> get cartProducts => _cartProductsMap.values?.toList() ?? [];

  CartProduct getCartProduct(String id) {
    return _cartProductsMap[id];
  }

  // String get discountAsString {
  //   return "${(discount * 100).toInt()} %";
  // }

  int get itemCount {
    int _sum = 0;
    for (CartProduct product in cartProducts) {
      _sum += product.qty;
    }
    return _sum;
  }

  void setTip(int tip) {
    _tipAmount = tip;
    // calculateTotal();
    notifyListeners();
  }

  void removeWalletAmountFromTotal(double amount) {
    removedWalletAmount = amount;
    notifyListeners();
  }

  // void calculateTotal() {
  //   total = productsTotal;
  //   total = (total * (1 - discount)).floor();
  //   total += tipAmount;
  //   notifyListeners();
  // }

  String get productsTotalAsString =>
      "$kRupeeSymbol ${_productsTotal.toStringAsFixed(1)}";

  String get tipAsString => "$kRupeeSymbol $_tipAmount";

  String get totalAsString => "$kRupeeSymbol ${_total.toStringAsFixed(1)}";

  String get taxAsString => "$kRupeeSymbol ${_inclusiveTax.toStringAsFixed(1)}";

  String get itemCountAsString =>
      "$itemCount item${(itemCount == 1) ? "" : "s"}";

  double get _productsTotal {
    double _amountSum = 0;
    for (CartProduct cartProduct in cartProducts)
      _amountSum += cartProduct.product.productAmount * cartProduct.qty;
    return _amountSum;
  }

  double get total => _total;

  double get _total {
    // discount??
    return _productsTotal + _tipAmount - removedWalletAmount;
  }

  double get totalWithoutRemovedWalletAmount {
    // discount??
    return _productsTotal + _tipAmount;
  }

  double get _inclusiveTax {
    double _sum = 0;
    for (CartProduct cartProduct in cartProducts)
      _sum += cartProduct.product.taxAmount * cartProduct.qty;
    return _sum;
  }

  int getItemCount(String id) => getCartProduct(id)?.qty ?? 0;

  Future<void> update() async {
    this.cartIsLoading = true;
    notifyListeners();
    GetCart getCart = await Repository.getCart();
    if (getCart?.status ?? false) {
      _cartProductsMap = {};
      final res = getCart?.cart?.products ?? [];
      for (CartProduct cartProduct in res)
        _cartProductsMap[cartProduct.product.id] = cartProduct;
    }
    this.cartIsLoading = false;
    notifyListeners();
  }

  // void clear() {
  //   _cartProductsMap = {};
  //   notifyListeners();
  // }

  void incrementProductCount(Product product, {int value = 1}) {
    if (_cartProductsMap.containsKey(product.id))
      _cartProductsMap[product.id].qty += value;
    else
      _cartProductsMap[product.id] = CartProduct(product: product, qty: value);
    notifyListeners();
  }

  void decrementProductCount(String id) {
    if (_cartProductsMap.containsKey(id)) _cartProductsMap[id].qty--;
    if (_cartProductsMap[id].qty == 0) this.removeProduct(id);
    notifyListeners();
  }

  void removeProduct(String id) {
    _cartProductsMap.remove(id);
    notifyListeners();
  }
}
