import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/order_detail.dart';

class OrdersController extends ChangeNotifier {
  Map<String, OrderDetail> _ordersMap;

  // have to maintain for ordering the orders such that the latest comes on top
  List<String> _orderIds;
  bool ordersLoading;

  OrdersController() {
    _orderIds = [];
    ordersLoading = true;
  }

  void clear() {
    _ordersMap = null;
    _orderIds = [];
    ordersLoading = true;
    notifyListeners();
  }

  Future<bool> addQuickOrder(
      String type, List<File> files, String address_id) async {
    final res = await Repository.quickOrder(
        type: type, files: files, addreess_id: address_id);
    return res;
  }

  Future<void> update() async {
    _ordersMap = null;
    await this._updateOrders();
  }

  List<OrderDetail> get orders {
    this._updateOrders();
    List<OrderDetail> _orders = [];
    for (String orderId in _orderIds) _orders.add(_ordersMap[orderId]);
    return _orders;
  }

  void addOrder(OrderDetail orderDetail) {
    if (_ordersMap == null) return;
    _orderIds.insert(0, orderDetail.id);
    _ordersMap[orderDetail.id] = orderDetail;
    notifyListeners();
  }

  Future<void> _updateOrders() async {
    if (_ordersMap == null) {
      _ordersMap = {};
      _orderIds = [];
      final res = await Repository.getOrderHistory();
      if (res != null &&
          res?.orderDetails != null &&
          res.orderDetails.isNotEmpty)
        for (OrderDetail order in res.orderDetails) {
          _ordersMap[order.id] = order;
          _orderIds.add(order.id);
        }

      ordersLoading = false;
      notifyListeners();
    }
  }
}
