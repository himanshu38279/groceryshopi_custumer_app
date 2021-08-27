import 'package:tbo_the_best_one/models/secondary_banner.dart';

class GetSecondaryBanners {
  bool status;
  String msg;
  List<SecondaryBanner> secondaryBanners;

  GetSecondaryBanners({this.status, this.msg, this.secondaryBanners});

  GetSecondaryBanners.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      secondaryBanners = <SecondaryBanner>[];
      json['data'].forEach((v) {
        secondaryBanners.add(new SecondaryBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.secondaryBanners != null) {
      data['data'] = this.secondaryBanners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
