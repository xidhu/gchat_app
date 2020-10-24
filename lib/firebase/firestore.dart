import 'package:Gchat/firebase/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class db {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> hasUser({String uid}) async {
    bool exists = false;
    try {
      await firestore.collection("users").doc(uid).get().then((doc) {
        if (doc.exists) {
          exists = true;
        }
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  Future<List> getChats({String uid}) async {
    try {
      dynamic chat;
      await firestore.collection("chats").get().then((value) {
        chat = value.docs.map((e) => e.data()['chatId']);
      });

      List chats = [];

      chat.forEach((e) {
        List id = e.split("_");

        if (id[0] == uid) {
          chats.add(id[1]);
        } else if (id[1] == uid) {
          chats.add(id[0]);
        }
      });

      return chats;
    } catch (e) {
      return null;
    }
  }

  Future<bool> createUser(ChatUser user) async {
    try {
      await firestore.collection("users").doc(user.uid).set({
        'uid': user.uid,
        'name': user.name,
        'email': user.email,
        'photo': user.photo,
        'online': true,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
