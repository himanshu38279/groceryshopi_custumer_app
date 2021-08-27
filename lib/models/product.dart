import 'package:tbo_the_best_one/api/api_routes.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/utilities/helpers.dart';

class Product {
  String id;
  String code;
  String name;
  String productUnit;
  double cost;
  double price;
  String alertQuantity;
  String image;
  double taxRate;
  String trackQuantity;
  String details;
  String barcodeSymbology;
  String productDetails;
  String type;
  String slug;
  String categoryId;
  String subcategoryId;
  String featured;
  String weight;
  String views;
  String secondName;
  String hide;
  String hidePos;
  List<Product> productVariants;
  bool isOnDiscount;
  int discount;
  int maxQuantity;
  double taxAmount;

  double get productAmount => isOnDiscount ? this.price : this.cost;

  String get priceAsString =>
      "$kRupeeSymbol ${this.productAmount.toStringAsFixed(1)}";

  String get originalPriceAsString =>
      "$kRupeeSymbol ${this.cost.toStringAsFixed(1)}";

  Product({
    this.id,
    this.code,
    this.name,
    this.productUnit,
    this.cost,
    this.price,
    this.maxQuantity,
    this.alertQuantity,
    this.image,
    this.taxRate,
    this.trackQuantity,
    this.details,
    this.barcodeSymbology,
    this.productDetails,
    this.type,
    this.slug,
    this.categoryId,
    this.subcategoryId,
    this.featured,
    this.weight,
    this.views,
    this.secondName,
    this.hide,
    this.hidePos,
    this.productVariants,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['product_id'];
    code = json['code'];
    name = Helpers.capitalize(json['name']);
    productUnit = json['product_unit'];
    cost = double.tryParse(json['cost']);
    price = double.tryParse(json['price']);
    alertQuantity = json['alert_quantity'];
    maxQuantity = double.tryParse(json['quantity'] ?? "")?.toInt() ?? 0;
    if (maxQuantity <= 0) maxQuantity = 0;
    image = ApiRoutes.getImageUrl(json['image']);
    taxRate =
        json['tax_rate'] == null ? 0.0 : double.tryParse(json['tax_rate']);
    trackQuantity = json['track_quantity'];
    details = json['details'];
    barcodeSymbology = json['barcode_symbology'];
    productDetails = json['product_details'];
    type = json['type'];
    slug = json['slug'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    featured = json['featured'];
    weight = json['weight'];
    views = json['views'];
    secondName = json['second_name'];
    hide = json['hide'];
    hidePos = json['hide_pos'];

    if (cost == price)
      discount = 0;
    else
      discount = (((cost - price) / cost) * 100).round();
    isOnDiscount = discount != 0;

    if (json['product_variants'] != null) {
      productVariants = <Product>[];
      json['product_variants'].forEach((v) {
        productVariants.add(new Product.fromJson(v));
      });
    }

    taxAmount = productAmount * taxRate / 100;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['product_unit'] = this.productUnit;
    data['cost'] = this.cost;
    data['price'] = this.price;
    data['alert_quantity'] = this.alertQuantity;
    data['image'] = this.image;
    data['tax_rate'] = this.taxRate;
    data['track_quantity'] = this.trackQuantity;
    data['details'] = this.details;
    data['barcode_symbology'] = this.barcodeSymbology;
    data['product_details'] = this.productDetails;
    data['type'] = this.type;
    data['slug'] = this.slug;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['featured'] = this.featured;
    data['weight'] = this.weight;
    data['views'] = this.views;
    data['second_name'] = this.secondName;
    data['hide'] = this.hide;
    data['hide_pos'] = this.hidePos;
    if (this.productVariants != null) {
      data['product_variants'] =
          this.productVariants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
