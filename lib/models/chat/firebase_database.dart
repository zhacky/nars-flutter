import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabase {
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessage(String chatRoom, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoom)
        .collection("chats")
        .add(messageMap)
        .catchError((e) => {print(e.toString())});
  }

  getConversationMessages(String chatRoom){
    return FirebaseFirestore.instance.collection("ChatRooms")
      .doc(chatRoom)
      .collection("chats")
      .orderBy("dateTime")
      .snapshots();
  }
  

  createNotification(String name, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("Notifications")
        .doc(name)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addNotification(String name, notificationMap){
    FirebaseFirestore.instance
        .collection("Notifications")
        .doc(name)
        .collection("notifications")
        .add(notificationMap)
        .catchError((e) => {print(e.toString())});
  }
}
