class Login {
  String? userEmail;
  String? password;
  bool? rememberMe;

  Login({this.userEmail, this.password, this.rememberMe});

  Login.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    password = json['password'];
    rememberMe = json['rememberMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmail'] = this.userEmail;
    data['password'] = this.password;
    data['rememberMe'] = this.rememberMe;
    return data;
  }
}
