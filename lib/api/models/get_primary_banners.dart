import 'package:tbo_the_best_one/models/primary_banner.dart';

class GetPrimaryBanners {
  bool status;
  String msg;
  List<PrimaryBanner> primaryBanners;

  GetPrimaryBanners({this.status, this.msg, this.primaryBanners});

  GetPrimaryBanners.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      primaryBanners = <PrimaryBanner>[];
      json['data'].forEach((v) {
        primaryBanners.add(new PrimaryBanner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.primaryBanners != null) {
      data['data'] = this.primaryBanners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
