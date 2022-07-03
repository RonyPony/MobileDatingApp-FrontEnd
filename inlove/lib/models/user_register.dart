class Register {
  String? userName;
  String? lastName;
  String? email;
  String? password;

  Register({this.userName, this.lastName, this.email,this.password});

  Register.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['lastName'] = lastName;
    data['email'] = email;

    data['password'] = password;
    return data;
  }
}
