import 'package:tbo_the_best_one/models/order_detail.dart';

class GetOrderHistory {
  bool status;
  String msg;
  List<OrderDetail> orderDetails;

  GetOrderHistory({this.status, this.msg, this.orderDetails});

  GetOrderHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      orderDetails = <OrderDetail>[];
      json['data'].forEach((v) {
        orderDetails.add(new OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.orderDetails != null) {
      data['data'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
