import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatUser {
  String id;
  String photoUrl;
  String displayName;
  String phoneNumber;
  String aboutMe;

  ChatUser(
      {required this.id,
      required this.photoUrl,
      required this.displayName,
      required this.phoneNumber,
      required this.aboutMe});

  static ChatUser fromDocument(DocumentSnapshot<Object?> documentSnapshot) {
    return ChatUser(id:"2", photoUrl: "photoUrl", displayName: "displayName", phoneNumber: "phoneNumber", aboutMe: "aboutMe");
  }
}
