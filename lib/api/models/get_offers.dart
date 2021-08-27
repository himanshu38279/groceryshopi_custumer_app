import 'package:tbo_the_best_one/models/offer.dart';

class GetOffers {
  bool status;
  String msg;
  List<Offer> offers;

  GetOffers({this.status, this.msg, this.offers});

  GetOffers.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      offers = <Offer>[];
      json['data'].forEach((v) {
        offers.add(new Offer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.offers != null) {
      data['data'] = this.offers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
