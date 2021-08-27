class Testimonial {
  String id;

  // String userId;
  // String orderId;
  String stars;
  String comment;

  // String createdAt;
  String name;

  // String _fName;
  // String _lname;

  Testimonial({
    this.id,
    // this.userId,
    // this.orderId,
    this.stars,
    this.comment,
    // this.createdAt,
    this.name,
  });

  String get nameInitials =>
      name.split(' ').map((e) => e[0].toUpperCase()).join('');

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // userId = json['user_id'];
    // orderId = json['order_id'];
    name = json['name'];
    stars = json['stars'];
    comment = json['comment'];
    // createdAt = json['created_at'];
    // _fName = json['first_name'];
    // _lname = json['last_name'];
    // name = "$_fName $_lname";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    // data['user_id'] = this.userId;
    // data['order_id'] = this.orderId;
    data['stars'] = this.stars;
    data['comment'] = this.comment;
    // data['created_at'] = this.createdAt;
    return data;
  }
}
