import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/chat_spike.dart';

class ChatMessages {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  bool isSeen;
  int type;

  ChatMessages(
      {required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.isSeen,
      required this.content,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.isThisMessageSeen:isSeen,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.type: type,
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
    String idFrom = documentSnapshot.get(FirestoreConstants.idFrom);
    String idTo = documentSnapshot.get(FirestoreConstants.idTo);
    bool isSeen = documentSnapshot.get(FirestoreConstants.isThisMessageSeen);
    String timestamp = documentSnapshot.get(FirestoreConstants.timestamp);
    String content = documentSnapshot.get(FirestoreConstants.content);
    int type = documentSnapshot.get(FirestoreConstants.type);

    return ChatMessages(
        idFrom: idFrom,
        isSeen: isSeen,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type);
  }
}
