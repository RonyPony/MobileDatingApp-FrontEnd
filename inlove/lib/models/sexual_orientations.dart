class SexualOrientation {
  int? id;
  int? imageId;
  String? name;
  bool? enabled;

  SexualOrientation({this.id,this.imageId,this.name, this.enabled});

  SexualOrientation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageId = json['imageId'];
    name = json['name'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageId']=this.imageId;
    data['name'] = this.name;
    data['enabled'] = this.enabled;
    return data;
  }
}