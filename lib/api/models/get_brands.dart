import 'package:tbo_the_best_one/models/brand.dart';

class GetBrands {
  bool status;
  String msg;
  List<Brand> brands;

  GetBrands({this.status, this.msg, this.brands});

  GetBrands.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      brands = <Brand>[];
      json['data'].forEach((v) {
        brands.add(new Brand.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.brands != null) {
      data['data'] = this.brands.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
