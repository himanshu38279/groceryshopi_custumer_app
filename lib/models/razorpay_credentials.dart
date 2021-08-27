class RazorpayCredential {
  String razorpayKeyId;
  String razorpayKeySecret;

  RazorpayCredential({this.razorpayKeyId, this.razorpayKeySecret});

  RazorpayCredential.fromJson(Map<String, dynamic> json) {
    razorpayKeyId = json['razorpay_key_id'];
    razorpayKeySecret = json['razorpay_key_secrate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['razorpay_key_id'] = this.razorpayKeyId;
    data['razorpay_key_secrate'] = this.razorpayKeySecret;
    return data;
  }
}
