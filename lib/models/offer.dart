import 'package:tbo_the_best_one/utilities/constants.dart';

class Offer {
  String offerId;
  String offerTitle;
  String offerDesc;
  int offerAmount;
  String offerType;
  String offerImage;
  String createdAt;

  Offer({
    this.offerId,
    this.offerTitle,
    this.offerDesc,
    this.offerAmount,
    this.offerType,
    this.offerImage,
    this.createdAt,
  });

  String get amountAsString {
    if (offerType == "PERCENT")
      return "$offerAmount% OFF";
    else
      return "$kRupeeSymbol $offerAmount OFF";
  }

  Offer.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    offerTitle = json['offer_title'];
    offerDesc = json['offer_desc'];
    offerAmount = double.tryParse(json['offer_amount']).toInt();
    offerType = json['offer_type'];
    offerImage = json['offer_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['offer_id'] = this.offerId;
    data['offer_title'] = this.offerTitle;
    data['offer_desc'] = this.offerDesc;
    data['offer_amount'] = this.offerAmount;
    data['offer_type'] = this.offerType;
    data['offer_image'] = this.offerImage;
    data['created_at'] = this.createdAt;
    return data;
  }
}
