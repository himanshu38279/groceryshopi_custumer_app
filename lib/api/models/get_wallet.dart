import 'package:tbo_the_best_one/models/wallet.dart';

class GetWallet {
  bool status;
  String msg;
  Wallet wallet;

  GetWallet({this.status, this.msg, this.wallet});

  GetWallet.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    wallet = json['data'] != null ? Wallet.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.wallet != null) {
      data['data'] = this.wallet.toJson();
    }
    return data;
  }
}
