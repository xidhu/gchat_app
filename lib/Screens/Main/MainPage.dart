import 'dart:async';
import 'package:Gchat/Screens/AddChat/AddChat.dart';
import 'package:Gchat/Screens/ChatPage/ChatPage.dart';
import 'package:Gchat/Screens/Login/LoginPage.dart';
import 'package:Gchat/firebase/Auth.dart';
import 'package:Gchat/firebase/User.dart';
import 'package:Gchat/firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

List chats = ["zsafdasf"];

class MainPage extends StatefulWidget {
  MainPage({Key key, ChatUser user}) {
    this.user = user;
  }

  ChatUser user;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => {reload()});

    db().getChats(uid: widget.user.uid).then((value) {
      if (value.isNotEmpty) {
        setState(() {});
      }
    });
    db()
        .firestore
        .collection("users")
        .doc(widget.user.uid)
        .set({'online': true}, SetOptions(merge: true));
  }

  void reload() {
    setState(() {
      db().getChats(uid: widget.user.uid).then((value) {
        if (value.isNotEmpty) {
          setState(() {
            chats = value;
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303030),
      appBar: buildAppBar(),
      drawer: BuildDrawer(
        user: widget.user,
      ),
      body: Body(
        user: widget.user,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddChat(
              user: widget.user,
            );
          })).then((value) => reload());
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class BuildDrawer extends StatelessWidget {
  BuildDrawer({ChatUser user}) {
    this.user = user;
  }

  ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GChat',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                Row(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: 50,
                      height: 50,
                      child: Image.asset("lib/assets/images/b.png"),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          Text(user.email,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("lib/assets/images/a.png"))),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey)),
            onTap: () {
              db()
                  .firestore
                  .collection("users")
                  .doc(user.uid)
                  .set({'online': false}, SetOptions(merge: true));
              Auth().SignOut();
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({ChatUser user}) {
    this.user = user;
  }

  ChatUser user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();

    db().getChats(uid: widget.user.uid).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          chats = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db()
          .firestore
          .collection("users")
          .where("uid", whereIn: chats)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, pos) {
              DocumentSnapshot ds = snapshot.data.docs[pos];
              return Column(
                children: [
                  ChatItem(
                    last_msg: ds['online'] == true ? "Online" : "Offline",
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
                                        online: ds['online'],
                                        uid: ds['uid'],
                                        photo: ds['photo'],
                                        email: ds['email']),
                                  )));
                    },
                  ),
                ],
              );
            },
            itemCount: snapshot.data.docs.length,
          );
        } else {
          return Text("no connection");
        }
      },
    );
  }
}

AppBar buildAppBar({title = "Chats"}) {
  return AppBar(
    title: Text(
      "$title",
      style: TextStyle(fontSize: 24),
    ),
    shadowColor: Colors.grey,
    elevation: 5,
  );
}
