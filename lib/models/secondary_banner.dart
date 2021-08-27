class SecondaryBanner {
  String secondaryBannerId;
  String image;
  String title;
  String description;
  String brandId;
  String createdAt;
  String updatedAt;

  SecondaryBanner({
    this.secondaryBannerId,
    this.image,
    this.title,
    this.description,
    this.brandId,
    this.createdAt,
    this.updatedAt,
  });

  SecondaryBanner.fromJson(Map<String, dynamic> json) {
    secondaryBannerId = json['secondary_banner_id'];
    image = json['image'];
    title = json['title'];
    description = json['descri'];
    brandId = json['brand_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['secondary_banner_id'] = this.secondaryBannerId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['descri'] = this.description;
    data['brand_id'] = this.brandId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
