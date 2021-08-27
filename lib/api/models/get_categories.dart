import 'package:tbo_the_best_one/models/category.dart';

class GetCategories {
  bool status;
  String msg;
  List<Category> categories;

  GetCategories({this.status, this.msg, this.categories});

  GetCategories.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      categories = <Category>[];
      json['data'].forEach((v) {
        categories.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.categories != null) {
      data['data'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


