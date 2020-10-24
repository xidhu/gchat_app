import 'package:Gchat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'User.dart';

class Auth {
  final _firebase = FirebaseAuth.instance;
  final msg = Message();

  dynamic AuthState() async {
    try {
      User u = await _firebase.currentUser;
      if (u == null) {
        return null;
      } else {
        return ChatUser(
            uid: u.uid,
            name: u.displayName,
            email: u.email,
            photo: u.photoURL,
            verified: u.emailVerified);
      }
    } on FirebaseAuthException catch (e) {}
  }

  dynamic SignUp({String email, String password, String name}) async {
    try {
      UserCredential result = await _firebase.createUserWithEmailAndPassword(
          email: email, password: password);

      result.user.sendEmailVerification();
      msg.showMessage(message: "Verification is sent to your Email.");
      result.user.updateProfile(displayName: name);
      return ChatUser(
          email: result.user.email,
          name: name,
          uid: result.user.uid,
          verified: result.user.emailVerified);
    } on FirebaseAuthException catch (e) {
      msg.showMessage(message: e.code);
      return false;
    } catch (e) {}
  }

  dynamic Login({String email, String password}) async {
    try {
      UserCredential result = await _firebase.signInWithEmailAndPassword(
          email: email, password: password);

      if (!result.user.emailVerified) {
        result.user.sendEmailVerification();
        return "0";
      } else {
        return ChatUser(
            email: result.user.email,
            name: result.user.displayName,
            uid: result.user.uid,
            verified: result.user.emailVerified);
      }
    } on FirebaseAuthException catch (e) {
      msg.showMessage(message: e.code);
      return false;
    } catch (e) {}
  }

  dynamic SignOut() async {
    try {
      return await _firebase
          .signOut()
          .then((value) => msg.showMessage(message: "Signed Out."));
    } catch (e) {}
  }

  dynamic Reset({String email}) async {
    try {
      return await _firebase.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return false;
    } catch (e) {
      msg.showMessage(message: " Please Enter Registered Email.");
    }
  }
}
