import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:inlove/models/chatRoom.dart';
import 'package:inlove/models/chat_message.dart';

import '../models/user.dart';
import '../screens/chat_spike.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;
  ChatProvider(this.firebaseStorage, this.firebaseFirestore);
  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        .doc(groupChatId)
        .collection(FirestoreConstants.messagesCollectionName)
        // .doc(FirestoreConstants.messagesDocName)
        // .collection(groupChatId)

        // .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
    return snapshots;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserTyping(
      String groupChatId, String current_uid) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        .doc(groupChatId)
        .snapshots();

    return snapshots;
  }

  Stream<QuerySnapshot> getChatRooms(String uid, int limit) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        // .doc(FirestoreConstants.messagesDocName)
        // .collection(groupChatId)

        // .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
    return snapshots;
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUIDfromEmail(
      String userEmail) {
    userEmail = userEmail.toLowerCase();
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where("email", isEqualTo: userEmail)
        .snapshots();
    return snapshots;
  }

  String createRoom(String user1_uid, String user1_id, String user2_uid,
      String user2_id, String displayName) {
    bool haveChat = false; //existRoom(user1,user2);
    String chatRoomId = "ChatRoom(" + generateRandomString(10) + ")";
    if (!haveChat) {
      DocumentReference chatRoomDocumentReference = firebaseFirestore
          .collection(FirestoreConstants.chatCollectionName)
          .doc(chatRoomId);
      ChatMessagesRoom chatRoomMessages = ChatMessagesRoom(
          createdOn: DateTime.now().millisecondsSinceEpoch.toString(),
          user1_uid: user1_uid,
          user1_id: user1_id,
          user2_uid: user2_uid,
          user2_id: user2_id,
          displayName: displayName,
          isUser1Typing: false,
          isUser2Typing: false,
          lastMessengerId: user1_uid,
          isSeen: false);
      Map<String, dynamic> jsoned = chatRoomMessages.toJson();
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(chatRoomDocumentReference, jsoned);
      });
    }
    return chatRoomId;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getEmailFromFirebase(String uid) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where("userId", isEqualTo: uid)
        .snapshots();
    return snapshots;
  }

  void sendChatMessage(String content, int type, String chatRoomId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        .doc(chatRoomId)
        .collection(FirestoreConstants.messagesCollectionName)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isSeen: false,
        type: type);
    Map<String, dynamic> jsoned = chatMessages.toJson();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, jsoned);
    });

    DocumentReference chatReference = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        .doc(chatRoomId);
    chatReference.update({
      FirestoreConstants.lastMessengerId: currentUserId,
      FirestoreConstants.isSeen: false
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  void markRoomAndMessageAsSeen(String chatRoomId, String currentUser) {
    final msgRef = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        .doc(chatRoomId)
        .collection(FirestoreConstants.messagesCollectionName)
        .get()
        .then((QuerySnapshot value) {
      if (value.docs.length >= 1) {
        firebaseFirestore
            .collection(FirestoreConstants.chatCollectionName)
            .doc(chatRoomId)
            .collection(FirestoreConstants.messagesCollectionName)
            .doc(value.docs.last.id)
            .update({FirestoreConstants.isThisMessageSeen: true});
      }
    });

    final docRef = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        .doc(chatRoomId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        String _userIdToModify = "";
        if (data[FirestoreConstants.lastMessengerId] == currentUser) {
          print("Last message was not send by this user, skiping seen flag");
        } else {
          DocumentReference chatReference = firebaseFirestore
              .collection(FirestoreConstants.chatCollectionName)
              .doc(chatRoomId);
          chatReference.update({FirestoreConstants.isSeen: true}).then(
              (value) => print("Setting room $chatRoomId as seen completed"),
              onError: (e) => print("Error updating chatRoom as seen $e"));
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  void markUserIsTyping(String roomId, String uid, bool isTyping) {
    final docRef = firebaseFirestore
        .collection(FirestoreConstants.chatCollectionName)
        .doc(roomId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        String _userIdToModify = "";
        if (data[FirestoreConstants.user1_uid] == uid) {
          print("USER 1 IS TYPING");
          DocumentReference chatReference = firebaseFirestore
              .collection(FirestoreConstants.chatCollectionName)
              .doc(roomId);
          chatReference
              .update({FirestoreConstants.isUser1Typing: isTyping}).then(
                  (value) =>
                      print("Setting room $roomId as user typing completed"),
                  onError: (e) =>
                      print("Error updating chatRoom as user typing $e"));
        }

        if (data[FirestoreConstants.user2_uid] == uid) {
          print("USER 2 IS TYPING");
          DocumentReference chatReference = firebaseFirestore
              .collection(FirestoreConstants.chatCollectionName)
              .doc(roomId);
          chatReference
              .update({FirestoreConstants.isUser2Typing: isTyping}).then(
                  (value) =>
                      print("Setting room $roomId as user typing completed"),
                  onError: (e) =>
                      print("Error updating chatRoom as user typing $e"));
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}
