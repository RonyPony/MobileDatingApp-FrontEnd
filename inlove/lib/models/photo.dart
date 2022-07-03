class Photo {
  int? id;
  String? name;
  String? image;
  int? userId;
  String? createdAt;

  Photo({this.id, this.name, this.image, this.userId, this.createdAt});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    userId = json['userId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
