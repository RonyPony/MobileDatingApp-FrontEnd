class UserMatch {
  int? id;
  int? originUserId;
  int? finalUserId;
  bool? isAcepted;

  UserMatch({this.id, this.originUserId, this.finalUserId, this.isAcepted});

  UserMatch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    originUserId = json['originUserId'];
    finalUserId = json['finalUserId'];
    isAcepted = json['isAcepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['originUserId'] = this.originUserId;
    data['finalUserId'] = this.finalUserId;
    data['isAcepted'] = this.isAcepted;
    return data;
  }
}