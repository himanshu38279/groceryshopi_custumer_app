import 'package:tbo_the_best_one/api/api_routes.dart';
import 'package:tbo_the_best_one/utilities/helpers.dart';

class Brand {
  String id;
  String code;
  String name;
  String image;
  String slug;
  String description;

  Brand({
    this.id,
    this.code,
    this.name,
    this.image,
    this.slug,
    this.description,
  });

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = Helpers.capitalize(json['name']);
    image = ApiRoutes.getImageUrl(json['image']);
    slug = json['slug'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['image'] = this.image;
    data['slug'] = this.slug;
    data['description'] = this.description;
    return data;
  }
}
