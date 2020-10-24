import 'dart:async';

import 'package:Gchat/firebase/User.dart';
import 'package:Gchat/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Gchat/firebase/Notifications.dart';
import '../../widgets/widgets.dart';

String lastTime = "";
String lastmsg = "";

class ChatPage extends StatefulWidget {
  ChatPage({ChatUser user, ChatUser reciever}) {
    this.user = user;
    this.reciever = reciever;
    this.chatId = this.user.uid.compareTo(this.reciever.uid) > 0
        ? this.user.uid + "_" + this.reciever.uid
        : this.reciever.uid + "_" + this.user.uid;
  }

  String chatId;
  ChatUser user, reciever;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chattext = TextEditingController();

  @override
  void initState() {
    super.initState();

    db()
        .firestore
        .collection("chats")
        .doc(widget.chatId)
        .set({'chatId': widget.chatId}, SetOptions(merge: true));
    db().firestore.collection("chats").doc(widget.chatId).get().then((value) {
      String x = "";
      value.data().forEach((key, value) {
        if (key == widget.user.uid) {
          x = value;
        }
      });
      setState(() {
        lastTime = x;
      });
    });
  }

  void sentMessage() {
    DateTime now = DateTime.now();
    if (chattext.text != "") {
      db()
          .firestore
          .collection("chats")
          .doc(widget.chatId)
          .collection("chats")
          .add({
        'message': chattext.text,
        'name': widget.user.name,
        'time': DateFormat('M/d/y, h:mm:ss a').format(now),
      }).then((value) {
        chattext.clear();
      });
    }
  }

  buildChatInput(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              offset: Offset(-1, -1),
              blurRadius: 5,
              spreadRadius: -2,
            )
          ]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chattext,
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          hoverColor: Colors.grey,
                          filled: true,
                          hintText: "Enter Here",
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent))),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.transparent,
                    child: Container(
                      color: Colors.transparent,
                      child: IconButton(
                        padding: EdgeInsets.all(1),
                        icon: Icon(
                          Icons.send,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          sentMessage();
                        },
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ChatBuilder(
              user: widget.user,
              reciever: widget.reciever,
              chatId: widget.chatId,
            ),
          ),
          buildChatInput(context)
        ],
      ),
    );
  }

  clearChatDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Clear"),
      onPressed: () {
        db().firestore.collection("chats").doc(widget.chatId).set({
          "${widget.user.uid}": lastTime,
        }, SetOptions(merge: true));
        setState(() {
          lastTime = lastTime;
        });
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Clear Chats"),
      content: Text("Do you want to clear all Chats?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      title: Container(
        child: Row(children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 36,
            height: 36,
            child: Image.asset("lib/assets/images/b.png"),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  widget.reciever.name ?? "Name",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Positioned(
                top: 25,
                child: Text(
                  widget.reciever.online == true ? "Online" : "Offline",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ]),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.clear_all_rounded),
          onPressed: () {
            clearChatDialog(context);
          },
          tooltip: "Clear Chat",
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }
}

class ChatBuilder extends StatefulWidget {
  ChatBuilder({ChatUser user, ChatUser reciever, String chatId}) {
    this.user = user;
    this.reciever = reciever;
    this.chatId = chatId;
  }

  String chatId;
  ChatUser user, reciever;

  @override
  _ChatBuilderState createState() => _ChatBuilderState();
}

class _ChatBuilderState extends State<ChatBuilder> {
  Notifications not;
  final scroll_controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    not = new Notifications(context, widget.user);
    not.intialize();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db()
            .firestore
            .collection('chats')
            .doc(widget.chatId)
            .collection("chats")
            .orderBy("time")
            .where('time', isGreaterThan: lastTime)
            .limit(100)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.size > 0) {
              DocumentSnapshot das = snapshot.data.docs[snapshot.data.size - 1];
              if (das['name'] != widget.user.name &&
                  lastmsg != das['message']) {
                lastmsg = das['message'];
                not.showNotificationWithDefaultSound(
                    name: widget.reciever.name, message: lastmsg);
              }
            }
            Timer(Duration(milliseconds: 500), () {
              scroll_controller.animateTo(
                scroll_controller.position.maxScrollExtent,
                duration: Duration(milliseconds: 800),
                curve: Curves.fastOutSlowIn,
              );
            });
            return ListView.builder(
              controller: scroll_controller,
              itemBuilder: (context, pos) {
                DocumentSnapshot ds = snapshot.data.docs[pos];
                lastTime = ds['time'];

                return ChatMessage(
                  directionRight: ds['name'] == widget.user.name ? true : false,
                  sender: ds['name'] == widget.user.name ? "You" : ds['name'],
                  message: ds['message'],
                  time: ds['time'].toString().split(",")[1],
                );
              },
              itemCount: snapshot.data.docs.length,
            );
          } else {
            return Text("No Connection");
          }
        });
  }
}
