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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['enabled'] = enabled;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    return data;
  }
}
