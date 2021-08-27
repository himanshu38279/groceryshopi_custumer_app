import 'package:html_unescape/html_unescape.dart';
import 'package:tbo_the_best_one/api/api_routes.dart';
import 'package:tbo_the_best_one/utilities/helpers.dart';

class Category {
  String id;
  String code;
  String name;
  String image;
  String parentId;
  String slug;
  String description;
  String image2;
  String title;
  List<String> subcategoryNames;

  static final _htmlUnescape = HtmlUnescape();

  String get subCategories =>
      subcategoryNames.map((e) => Helpers.capitalize(e)).join(', ');

  Category({
    this.id,
    this.code,
    this.name,
    this.image,
    this.parentId,
    this.slug,
    this.description,
    this.image2,
    this.title,
    this.subcategoryNames,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = Helpers.capitalize(_htmlUnescape.convert(json['name']));
    image = ApiRoutes.getImageUrl(json['image']);
    parentId = json['parent_id'];
    slug = json['slug'];
    description = json['description'];
    image2 = ApiRoutes.getImageUrl(json['image_2']);
    title = json['title'];
    subcategoryNames = json['subcategory_name']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['image'] = this.image;
    data['parent_id'] = this.parentId;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['image_2'] = this.image2;
    data['title'] = this.title;
    data['subcategory_name'] = this.subcategoryNames;
    return data;
  }
}
