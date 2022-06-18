class User {
  int? id;
  int? countryId;
  bool? modoFantasma;
  bool? instagramUserEnabled;
  String? instagramUser;
  bool? whatsappNumberEnabled;
  String? whatsappNumber;
  int? minimunAgeToMatch;
  int? maximunAgeToMatch;
  bool? deletedAccount;
  int? loginStatus;
  String? name;
  String? lastName;
  String? bio;
  String? email;
  String? password;
  int? sexualOrientationId;
  int? sexualPreferenceId;
  String? registerDate;
  String? lastLogin;

  User(
      {this.id,
      this.countryId,
      this.modoFantasma,
      this.instagramUserEnabled,
      this.instagramUser,
      this.whatsappNumberEnabled,
      this.whatsappNumber,
      this.minimunAgeToMatch,
      this.maximunAgeToMatch,
      this.deletedAccount,
      this.loginStatus,
      this.name,
      this.lastName,
      this.bio,
      this.email,
      this.password,
      this.sexualOrientationId,
      this.sexualPreferenceId,
      this.registerDate,
      this.lastLogin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['countryId'];
    modoFantasma = json['modoFantasma'];
    instagramUserEnabled = json['instagramUserEnabled'];
    instagramUser = json['instagramUser'];
    whatsappNumberEnabled = json['whatsappNumberEnabled'];
    whatsappNumber = json['whatsappNumber'];
    minimunAgeToMatch = json['minimunAgeToMatch'];
    maximunAgeToMatch = json['maximunAgeToMatch'];
    deletedAccount = json['deletedAccount'];
    loginStatus = json['loginStatus'];
    name = json['name'];
    lastName = json['lastName'];
    bio = json['bio'];
    email = json['email'];
    password = json['password'];
    sexualOrientationId = json['sexualOrientationId'];
    sexualPreferenceId = json['sexualPreferenceId'];
    registerDate = json['registerDate'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryId'] = this.countryId;
    data['modoFantasma'] = this.modoFantasma;
    data['instagramUserEnabled'] = this.instagramUserEnabled;
    data['instagramUser'] = this.instagramUser;
    data['whatsappNumberEnabled'] = this.whatsappNumberEnabled;
    data['whatsappNumber'] = this.whatsappNumber;
    data['minimunAgeToMatch'] = this.minimunAgeToMatch;
    data['maximunAgeToMatch'] = this.maximunAgeToMatch;
    data['deletedAccount'] = this.deletedAccount;
    data['loginStatus'] = this.loginStatus;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['bio'] = this.bio;
    data['email'] = this.email;
    data['password'] = this.password;
    data['sexualOrientationId'] = this.sexualOrientationId;
    data['sexualPreferenceId'] = this.sexualPreferenceId;
    data['registerDate'] = this.registerDate;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}
