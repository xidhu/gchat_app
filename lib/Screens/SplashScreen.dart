import 'dart:async';

import 'package:Gchat/Screens/Main/MainPage.dart';
import 'package:Gchat/firebase/Auth.dart';
import 'package:Gchat/firebase/User.dart';
import 'package:Gchat/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'Login/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Auth().AuthState().then((val) {
      if (val == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else if (val.verified) {
        db().createUser(val);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage(
                      key: Key("0"),
                      user: val,
                    )));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Container(),
    );
  }
}
