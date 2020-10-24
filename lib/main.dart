import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GChat",
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        fontFamily: 'ReemKufi',
        accentColor: Colors.blueAccent,
      ),
      home: SplashScreen(),
    );
  }
}
