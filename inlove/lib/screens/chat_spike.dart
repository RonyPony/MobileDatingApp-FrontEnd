import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inlove/models/chat_message.dart';
import 'package:inlove/providers/chat_provider.dart';
import 'package:inlove/providers/firebase_data.dart';
import 'package:inlove/screens/login.page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/chatUser.dart';

class ChatTest extends StatefulWidget {
  static String routeName = "routeChatSpike";

  const ChatTest({Key? key}) : super(key: key);

  @override
  State<ChatTest> createState() => StateChat();
}

class StateChat extends State<ChatTest> {
  TextEditingController searchmessageBox = TextEditingController();

  var listMessages;

  TextEditingController messageBox = TextEditingController();

  String currentUserId = "1";

  ScrollController scrollController = ScrollController();

  String groupChatId = "5";

  String imageUrl = "";

  bool isLoading = false;

  String _textSearch = "";

  File? avatarImageFile;

  String photoUrl = "";

  var displayName;

  var phoneNumber;

  var aboutMe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Smart Talk'),
            actions: [
              IconButton(
                  onPressed: () => googleSignOut(),
                  icon: const Icon(Icons.logout)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: const Icon(Icons.person)),
            ]),
        body: buildListMessage()
        // SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       // buildSearchBar()
        //       buildListMessage(),
        //       buildMessageInput()
        //     ],
        //   ),
        // ),
        );
  }

  void googleSignOut() {
    print("Sign out");
  }

  // checking if sent message
  bool isMessageSent(int index) {
    int currentUserId = 1;
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      messageBox.clear();
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.sendChatMessage(
          content, type, groupChatId, currentUserId, "1"); //widget.peerId);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // Future getImage() async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? pickedFile;
  //   pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     imageFile = File(pickedFile.path);
  //     if (imageFile != null) {
  //       setState(() {
  //         isLoading = true;
  //       });
  //       uploadImageFile();
  //     }
  //   }
  // }

  void uploadImageFile(File? imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, fileName);
    MessageType type = MessageType();
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, type.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Widget buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 50),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: getImage,
              icon: const Icon(
                Icons.camera_alt,
                size: 28,
              ),
              color: Colors.white,
            ),
          ),
          Flexible(
              child: TextField(
            // focusNode: focusNode,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: messageBox,
            decoration: InputDecoration(hintText: "Write Here..."),
            // kTextInputDecoration.copyWith(hintText: 'write here...'),
            onSubmitted: (value) {
              MessageType type = MessageType();
              onSendMessage(messageBox.text, type.text);
            },
          )),
          Container(
            margin: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                MessageType type = MessageType();
                onSendMessage(messageBox.text, type.text);
              },
              icon: const Icon(Icons.send_rounded),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemX(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        MessageType type = MessageType();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == type.text
                    ? messageBubble(
                        chatContent: chatMessages.content,
                        color: Colors.pink,
                        textColor: Colors.white,
                        margin: const EdgeInsets.only(right: 10),
                      )
                    : chatMessages.type == type.image
                        ? Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // child:
                        // Image.network(
                        //   widget.userAvatar,
                        //   width: 40,
                        //   height: 40,
                        //   fit: BoxFit.cover,
                        //   loadingBuilder: (BuildContext ctx, Widget child,
                        //       ImageChunkEvent? loadingProgress) {
                        //     if (loadingProgress == null) return child;
                        //     return Center(
                        //       child: CircularProgressIndicator(
                        //         color: Colors.brown,
                        //         value: loadingProgress.expectedTotalBytes !=
                        //                     null &&
                        //                 loadingProgress.expectedTotalBytes !=
                        //                     null
                        //             ? loadingProgress.cumulativeBytesLoaded /
                        //                 loadingProgress.expectedTotalBytes!
                        //             : null,
                        //       ),
                        //     );
                        //   },
                        //   errorBuilder: (context, object, stackTrace) {
                        //     return const Icon(
                        //       Icons.account_circle,
                        //       size: 35,
                        //       color: Colors.grey,
                        //     );
                        //   },
                        // ),
                      )
                    : Container(
                        width: 35,
                      ),
              ],
            ),
            isMessageSent(index)
                ? Container(
                    margin: EdgeInsets.only(right: 50, top: 6, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      } else {
        MessageType type = MessageType();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)
                    // left side (received message)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // child: Image.network(
                        //   widget.userAvatar,
                        //   width: 40,
                        //   height: 40,
                        //   fit: BoxFit.cover,
                        //   loadingBuilder: (BuildContext ctx, Widget child,
                        //       ImageChunkEvent? loadingProgress) {
                        //     if (loadingProgress == null) return child;
                        //     return Center(
                        //       child: CircularProgressIndicator(
                        //         color: Colors.red,
                        //         value: loadingProgress.expectedTotalBytes !=
                        //                     null &&
                        //                 loadingProgress.expectedTotalBytes !=
                        //                     null
                        //             ? loadingProgress.cumulativeBytesLoaded /
                        //                 loadingProgress.expectedTotalBytes!
                        //             : null,
                        //       ),
                        //     );
                        //   },
                        //   errorBuilder: (context, object, stackTrace) {
                        //     return const Icon(
                        //       Icons.account_circle,
                        //       size: 35,
                        //       color: Colors.grey,
                        //     );
                        //   },
                        // ),
                      )
                    : Container(
                        width: 35,
                      ),
                chatMessages.type == type.text
                    ? messageBubble(
                        color: Colors.red,
                        textColor: Colors.white,
                        chatContent: chatMessages.content,
                        margin: const EdgeInsets.only(left: 10),
                      )
                    : chatMessages.type == type.image
                        ? Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(left: 50, top: 6, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildSearchBar() {
    var buttonClearController;
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.person_search,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchmessageBox,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  buttonClearController.add(true);
                  setState(() {
                    _textSearch = value;
                  });
                } else {
                  buttonClearController.add(false);
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search here...',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          StreamBuilder(
              stream: buttonClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchmessageBox.clear();
                          buttonClearController.add(false);
                          setState(() {
                            _textSearch = '';
                          });
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              })
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.lightGreen,
      ),
    );
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    // PickedFile is not supported
    // Now use XFile?
    XFile? pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    final profileProvider =
        Provider.of<FirebaseDataProvider>(context, listen: false);
    String fileName = "20";
    UploadTask uploadTask =
        profileProvider.uploadImageFile(avatarImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      var id = "90";
      ChatUser updateInfo = ChatUser(
          id: id,
          photoUrl: photoUrl,
          displayName: displayName,
          phoneNumber: phoneNumber,
          aboutMe: aboutMe);
      // profileProvider
      //     .updateFirestoreData(
      //         FirestoreConstants.pathUserCollection, id, updateInfo.toJson())
      //     .then((value) async {
      //   await profileProvider.setPrefs(FirestoreConstants.photoUrl, photoUrl);
      //   setState(() {
      //     isLoading = false;
      //   });
      // });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    final firebaseAuth = FirebaseAuth.instance;
    if (documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
      if (userChat.id == currentUserId) {
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {
            // if (KeyboardUtils.isKeyboardShowing()) {
            //   KeyboardUtils.closeKeyboard(context);
            // }
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ChatPage(
            //               peerId: userChat.id,
            //               peerAvatar: userChat.photoUrl,
            //               peerNickname: userChat.displayName,
            //               userAvatar: firebaseAuth.currentUser!.photoURL!,
            //             )));
          },
          child: ListTile(
            leading: userChat.photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      userChat.photoUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
            title: Text(
              userChat.displayName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    int _limit = 9;
    return Container(
      height: 100,
      width: 200,
      child: Flexible(
        child: groupChatId.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: chatProvider.getChatMessage(groupChatId, _limit),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    listMessages = snapshot.data!.docs;
                    if (listMessages.isNotEmpty) {
                      return Container(
                        color: Colors.red,
                        height: 200,
                        width: 200,
                        // child: ListView.builder(
                        //     padding: const EdgeInsets.all(10),
                        //     itemCount: snapshot.data?.docs.length,
                        //     reverse: true,
                        //     controller: scrollController,
                        //     itemBuilder: (context, index)=> snapshot.data!.docs
                        //             .map((DocumentSnapshot document) {
                        //           Map<String, dynamic> data =
                        //               document.data()! as Map<String, dynamic>;
                        //           return ListTile(
                        //             title: Text(data['msg']),
                        //             subtitle: Text(data['createdOn']),
                        //           );
                        //         }).toList()),
                        child: ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return ListTile(
                              title: Text(data['msg']),
                              subtitle: Text(data['createdOn']),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No messages...',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  } else {
                    return CircularProgressIndicator(
                      color: Colors.yellow,
                    );
                  }
                })
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              ),
      ),
    );
  }

  messageBubble(
      {required String chatContent,
      required color,
      required textColor,
      required EdgeInsets margin}) {
    return Text(chatContent);
  }

  chatImage({required String imageSrc, required Null Function() onTap}) {
    return Image.asset(imageSrc);
  }
}

class FirestoreConstants {
  static const pathUserCollection = "users";
  static const pathStudentCollection = "student";
  static const pathCurrentRDCollection = "currentRecord";
  static const name = "name";
  static const uid = "uid";
  static const id = "userId";
  static const phone = "phone";
  static const email = "email";
  static const studentName = "studentName";
  static const fatherName = " fatherName";
  static const surname = "surname";
  static const studentClass = "studentClass";
  static const classDivision = "classDivision";
  static const itsNumber = "itsNumber";
  static const mobileNumber = "mobileNumber";
  static const createdOn = "createdOn";
  static const createdBy = "createdBy";
  static const createdById = "createdById";
  static const studentId = "studentId";
  static const currentJuz = "currentJuz";
  static const currentAyat = "currentAyat";
  static const currentSurah = "currentSurah";

  static const displayName = "displayName";

  static const idFrom = "idFrom";

  static const photoUrl = "photoUrl";

  static const chattingWith = "chattingWith";

  static const idTo = "idTo";

  static const timestamp = "timestamp";

  static const content = "content";

  static const type = "type";

  static const pathMessageCollection = "messages";

  static const pathMessagesDoc = "messagesDoc";

  static const chatCollectionName = "chats";

  static const chatDocName = "chatsDoc";

  static const messagesCollectionName = "messages";

  static const messagesDocName = "messagesDoc";

  static const messages = "messages";

  static const user1_uid = "user1_uid";

  static const user2_uid="user2_uid";

  static const user1_id = "user1_id";

  static const user2_id= "user2_id";
}

// class FirestoreConstants {
//   static var idFrom;

//   static String pathUserCollection="";

//   static String photoUrl="";

//   static String idTo="";

//   static String timestamp="";

//   static String content="";

//   static int type=1;

//   static String displayName="";

//   static String pathMessageCollection="";

//   static String id="";

//   static var chattingWith="";
// }

class MessageType {
  int image = 0;
  int text = 1;
}
