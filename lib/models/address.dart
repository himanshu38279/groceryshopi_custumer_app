class Address {
  String addressId;
  String userId;
  String addressLine1;
  String addressLine2;
  String addressType;
  String mapAddress;
  String lat;
  String lng;
  String locality;
  String createdAt;
  String updatedAt;

  Address(
      {this.addressId,
      this.userId,
      this.addressType,
      this.addressLine1,
      this.addressLine2,
      this.mapAddress,
      this.lat,
      this.lng,
      this.locality,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    userId = json['user_id'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    addressType = json['address_type'];
    mapAddress = json['map_address'];
    lat = json['lat'];
    lng = json['lng'];
    locality = json['locality'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address_id'] = this.addressId;
    data['user_id'] = this.userId;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['map_address'] = this.mapAddress;
    data['address_type'] = this.addressType;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['locality'] = this.locality;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
