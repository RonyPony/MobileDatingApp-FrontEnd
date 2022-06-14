class User {
  int? id;
  String? name;
  String? lastName;
  String? email;
  String? password;
  String? lastLogin;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.password,
      this.lastLogin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}
