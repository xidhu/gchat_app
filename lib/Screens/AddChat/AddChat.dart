import 'package:Gchat/Screens/ChatPage/ChatPage.dart';
import 'package:Gchat/firebase/User.dart';
import 'package:Gchat/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class AddChat extends StatefulWidget {
  AddChat({ChatUser user}) {
    this.user = user;
  }

  ChatUser user;

  @override
  _AddChatState createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  String last = "";
  final search_cnt = TextEditingController();
  String start = "";

  @override
  Widget build(BuildContext context) {
    search_cnt.addListener(() {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: Color(0xff303030),
      appBar: AppBar(
        shadowColor: Colors.black,
        title: TextField(
          controller: search_cnt,
          onChanged: (value) {
            int strlenght = value.length;
            String front = value.substring(0, strlenght - 1);
            String end = value.substring(strlenght - 1, strlenght);
            end = front + String.fromCharCode(end.codeUnitAt(0) + 1);
            if (search_cnt.text == "") {
              setState(() {
                start = null;
                last = null;
              });
            } else {
              setState(() {
                start = value;
                last = end;
              });
            }
          },
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: "Search Here",
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.clear_sharp),
              onPressed: () {
                search_cnt.clear();
              })
        ],
      ),
      body: StreamBuilder(
        stream: db()
            .firestore
            .collection("users")
            .where("name", isGreaterThanOrEqualTo: start)
            .where("name", isLessThan: last)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return search_cnt.text != ""
                ? ListView.builder(
                    itemBuilder: (context, pos) {
                      DocumentSnapshot ds = snapshot.data.docs[pos];
                      return Column(
                        children: [
                          ds['name'] != widget.user.name
                              ? ChatItem(
                                  last_msg: 'offline',
                                  time: '',
                                  name: ds['name'],
                                  onClick: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  user: widget.user,
                                                  reciever: ChatUser(
                                                      name: ds['name'],
                                                      uid: ds['uid'],
                                                      photo: ds['photo'],
                                                      email: ds['email']),
                                                )));
                                  },
                                )
                              : Container(),
                        ],
                      );
                    },
                    itemCount: snapshot.data.docs.length,
                  )
                : Container();
          } else {
            return Text("no connection");
          }
        },
      ),
    );
  }
}
