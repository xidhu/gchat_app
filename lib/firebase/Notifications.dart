import 'package:Gchat/Screens/ChatPage/ChatPage.dart';
import 'package:Gchat/Screens/Main/MainPage.dart';
import 'package:Gchat/firebase/User.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class Notifications {
  BuildContext context;
  ChatUser user;

  Notifications(BuildContext context, ChatUser user) {
    this.context = context;
    this.user = user;
  }

  FlutterLocalNotificationsPlugin notificationsPlugin;

  void intialize() {
    var initSetAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSet = new InitializationSettings(android: initSetAndroid);
    notificationsPlugin = new FlutterLocalNotificationsPlugin();
    notificationsPlugin.initialize(initSet);
  }

  Future showNotificationWithDefaultSound({String name, String message}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.show(
      0,
      name ?? 'Unknown',
      message ?? '',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
