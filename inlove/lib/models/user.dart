import 'dart:ffi';

class User {
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? bio;
  int? countryId;
  String? password;
  String? lastLogin;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.bio,
      this.countryId,
      this.password,
      this.lastLogin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
    email = json['email'];
    bio = json['bio'];
    countryId = json['countryId'];
    password = json['password'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['bio']=this.bio;
    data['countryId']=this.countryId;
    data['password'] = this.password;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}
