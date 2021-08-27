import 'package:tbo_the_best_one/api/api_routes.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';

class SearchResult {
  List<SearchItem> categories;
  List<SearchItem> brands;
  List<SearchItem> products;

  bool get isEmpty {
    return (products?.isEmpty ?? true) &&
        (brands?.isEmpty ?? true) &&
        (categories?.isEmpty ?? true);
  }

  SearchResult({this.categories, this.brands, this.products});

  SearchResult.fromJson(Map<String, dynamic> json) {
    categories = new List<SearchItem>();
    if (json['cat'] != null) {
      json['cat'].forEach((v) {
        categories.add(new SearchItem.fromJson(v));
      });
    }

    brands = new List<SearchItem>();
    if (json['bnd'] != null) {
      json['bnd'].forEach((v) {
        brands.add(new SearchItem.fromJson(v));
      });
    }

    products = new List<SearchItem>();
    if (json['prod'] != null) {
      json['prod'].forEach((v) {
        products.add(new SearchItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['cat'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['bnd'] = this.brands.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['prod'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchItem {
  String id;
  String name;
  String image;
  double _price;

  String get priceAsString =>
      (_price == null) ? "" : kRupeeSymbol + _price.toStringAsFixed(1) + "   ";

  SearchItem({
    this.id,
    this.name,
    this.image,
  });

  SearchItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = ApiRoutes.getImageUrl(json['image']);
    _price = double.tryParse(json['price'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
