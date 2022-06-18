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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userEmail'] = userEmail;
    data['password'] = password;
    data['rememberMe'] = rememberMe;
    return data;
  }
}
