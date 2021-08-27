import 'package:tbo_the_best_one/models/order_detail.dart';

class CheckoutDetails {
  bool status;
  String msg;
  OrderDetail orderDetails;

  CheckoutDetails({this.status, this.msg, this.orderDetails});

  CheckoutDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    orderDetails =
    json['data'] != null ? new OrderDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.orderDetails != null) {
      data['data'] = this.orderDetails.toJson();
    }
    return data;
  }
}




