import 'package:tbo_the_best_one/models/product.dart';

class PostProducts {
  bool status;
  String msg;
  List<Product> products;

  PostProducts({this.status, this.msg, this.products});

  PostProducts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      products = <Product>[];
      json['data'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.products != null) {
      data['data'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}