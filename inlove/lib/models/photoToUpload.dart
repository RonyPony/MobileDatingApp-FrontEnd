
class PhotoToUpload {
  String? image;
  int? userId;
  PhotoToUpload({this.image, this.userId});

  PhotoToUpload.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['userId'] = this.userId;
    return data;
  }
}
