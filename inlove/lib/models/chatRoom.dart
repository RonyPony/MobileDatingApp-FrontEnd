import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/chat_spike.dart';

class ChatMessagesRoom {
  // String messages;
  String user1_uid;
  String user1_id;
  String user2_uid;
  String user2_id;
  String createdOn;
  String displayName;
  String lastMessengerId;
  bool isSeen;
  bool isUser1Typing;
  bool isUser2Typing;
  bool isDeleted;
  
  ChatMessagesRoom({
      // required this.messages,
      required this.user1_uid,
      required this.user1_id,      
      required this.user2_uid,
      required this.user2_id,
      required this.createdOn,
      required this.lastMessengerId,
      required this.isSeen,
      required this.isUser1Typing,
      required this.isUser2Typing,
      required this.displayName, 
      required this.isDeleted
  });

  Map<String, dynamic> toJson() {
    return {
      // FirestoreConstants.messages: messages,
      FirestoreConstants.user1_uid: user1_uid,
      FirestoreConstants.user2_uid: user2_uid,
      FirestoreConstants.user1_id:user1_id,
      FirestoreConstants.user2_id:user2_id,
      FirestoreConstants.createdOn: createdOn,
      FirestoreConstants.lastMessengerId:lastMessengerId,
      FirestoreConstants.isSeen:isSeen,
      FirestoreConstants.isUser1Typing:isUser1Typing,
      FirestoreConstants.isUser2Typing: isUser2Typing,
      FirestoreConstants.displayName:displayName,
      FirestoreConstants.isRoomDeleted:isDeleted
    };
  }
}
