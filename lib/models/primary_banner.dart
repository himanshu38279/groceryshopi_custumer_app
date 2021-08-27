class PrimaryBanner {
  String primaryBannerId;
  String image;
  String title;
  String description;
  String categoryId;
  String createdAt;
  String updatedAt;

  PrimaryBanner({
    this.primaryBannerId,
    this.image,
    this.title,
    this.description,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  PrimaryBanner.fromJson(Map<String, dynamic> json) {
    primaryBannerId = json['primary_banner_id'];
    image = json['image'];
    title = json['title'];
    description = json['descri'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['primary_banner_id'] = this.primaryBannerId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['descri'] = this.description;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
