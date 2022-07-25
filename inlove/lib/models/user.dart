class User {
  int? id;
  int? countryId;
  int? preferedCountryId;
  bool? modoFantasma;
  bool? instagramUserEnabled;
  String? instagramUser;
  bool? whatsappNumberEnabled;
  String? whatsappNumber;
  bool? isEnabled;
  String? bornDate;
  bool? showMySexuality;
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
  bool? hasError=false;
  String? error="";

  User(
      {this.id,
      this.countryId,
      this.preferedCountryId,
      this.modoFantasma,
      this.instagramUserEnabled,
      this.instagramUser,
      this.whatsappNumberEnabled,
      this.whatsappNumber,
      this.minimunAgeToMatch,
      this.maximunAgeToMatch,
      this.deletedAccount,
      this.isEnabled,
      this.loginStatus,
      this.bornDate,
      this.showMySexuality,
      this.name,
      this.lastName,
      this.bio,
      this.email,
      this.password,
      this.sexualOrientationId,
      this.sexualPreferenceId,
      this.registerDate,
      this.lastLogin,
      this.hasError,
      this.error});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['countryId'];
    preferedCountryId = json['preferedCountryId'];
    modoFantasma = json['modoFantasma'];
    instagramUserEnabled = json['instagramUserEnabled'];
    instagramUser = json['instagramUser'];
    whatsappNumberEnabled = json['whatsappNumberEnabled'];
    whatsappNumber = json['whatsappNumber'];
    bornDate = json['bornDate'];
    minimunAgeToMatch = json['minimunAgeToMatch'];
    maximunAgeToMatch = json['maximunAgeToMatch'];
    deletedAccount = json['deletedAccount'];
    showMySexuality = json['showMySexuality'];
    loginStatus = json['loginStatus'];
    name = json['name'];
    isEnabled=json['isEnabled'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['countryId'] = countryId;
    data['preferedCountryId'] = preferedCountryId;
    data['modoFantasma'] = modoFantasma;
    data['instagramUserEnabled'] = instagramUserEnabled;
    data['instagramUser'] = instagramUser;
    data['whatsappNumberEnabled'] = whatsappNumberEnabled;
    data['whatsappNumber'] = whatsappNumber;
    data['minimunAgeToMatch'] = minimunAgeToMatch;
    data['bornDate'] =bornDate;
    data['isEnabled'] = isEnabled;
    data['maximunAgeToMatch'] = maximunAgeToMatch;
    data['showMySexuality']=showMySexuality;
    data['deletedAccount'] = deletedAccount;
    data['loginStatus'] = loginStatus;
    data['name'] = name;
    data['lastName'] = lastName;
    data['bio'] = bio;
    data['email'] = email;
    data['password'] = password;
    data['sexualOrientationId'] = sexualOrientationId;
    data['sexualPreferenceId'] = sexualPreferenceId;
    data['registerDate'] = registerDate;
    data['lastLogin'] = lastLogin;
    return data;
  }
}
