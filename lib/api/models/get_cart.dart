import 'package:tbo_the_best_one/models/cart.dart';

class GetCart {
  bool status;
  String msg;
  Cart cart;

  GetCart({this.status, this.msg, this.cart});

  GetCart.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    cart = json['data'] != null ? new Cart.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.cart != null) {
      data['data'] = this.cart.toJson();
    }
    return data;
  }
}


