class Country {
  int? id;
  String? name;
  String? code;
  bool? enabled;
  String? createdOn;
  String? updatedOn;

  Country(
      {this.id,
      this.name,
      this.code,
      this.enabled,
      this.createdOn,
      this.updatedOn});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    enabled = json['enabled'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['enabled'] = this.enabled;
    data['createdOn'] = this.createdOn;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}
