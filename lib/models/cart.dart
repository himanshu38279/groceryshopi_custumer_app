import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/models/product.dart';

class Cart {
  String cartId;
  String userId;
  String createdAt;
  int items;
  List<CartProduct> products;

  Cart({this.cartId, this.userId, this.createdAt, this.items, this.products});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    items = json['items'];
    if (json['products'] != null) {
      products = <CartProduct>[];
      json['products'].forEach((v) {
        products.add(new CartProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cart_id'] = this.cartId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['items'] = this.items;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartProduct {
  Product product;
  int qty;

  CartProduct({
    @required this.product,
    @required this.qty,
  });

  CartProduct.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json);
    qty = int.tryParse(json['qty']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data = this.product.toJson();
    data['qty'] = this.qty;
    return data;
  }
}
