class SexualOrientation {
  int? id;
  String? name;
  bool? enabled;

  SexualOrientation({this.id, this.name, this.enabled});

  SexualOrientation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['enabled'] = this.enabled;
    return data;
  }
}