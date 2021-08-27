import 'package:tbo_the_best_one/utilities/constants.dart';

class Wallet {
  double wallet;
  String email;
  String firstName;
  String lastName;
  String phone;
  String gender;

  Wallet({
    this.wallet,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.gender,
  });

  Wallet.fromJson(Map<String, dynamic> json) {
    wallet = double.tryParse(json['wallet'] ?? json['plus_wallet']);
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['wallet'] = this.wallet;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    return data;
  }
}

class WalletStatement {
  String transId;
  String status;
  double amount;
  String statement;

  WalletStatement({this.transId, this.status, this.amount, this.statement});

  String get amountAsString =>
      "${status == "DEBITED" ? "- " : ""}$kRupeeSymbol ${amount.toStringAsFixed(1)}";

  WalletStatement.fromJson(Map<String, dynamic> json) {
    transId = json['trans_id'];
    status = json['status'];
    amount = double.tryParse(json['amount']);
    statement = json['statement'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['trans_id'] = this.transId;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['statement'] = this.statement;
    return data;
  }
}
