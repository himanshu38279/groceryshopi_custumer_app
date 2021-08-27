import 'package:tbo_the_best_one/models/address.dart';

class GetAddress {
  bool status;
  String msg;
  List<Address> addresses;

  GetAddress({this.status, this.msg, this.addresses});

  GetAddress.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      addresses = <Address>[];
      json['data'].forEach((v) {
        addresses.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.addresses != null) {
      data['data'] = this.addresses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


