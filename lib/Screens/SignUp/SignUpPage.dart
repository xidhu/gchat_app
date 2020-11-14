import 'package:Gchat/Screens/Login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:Gchat/widgets/widgets.dart';
import 'package:Gchat/firebase/Auth.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key key}) {}

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();

  validateInputs(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (name.text != "" &&
        email.text != "" &&
        password.text != "" &&
        passwordCon.text != "") {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email.text)) {
        if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(password.text)) {
          if (password.text == passwordCon.text) {
            Auth()
                .SignUp(
                    email: email.text, password: password.text, name: name.text)
                .then((user) {
              if (!(user == false)) {
                name.clear();
                password.clear();
                passwordCon.clear();
                email.clear();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            });
          } else {
            Message().showMessage(message: "Passwords do not match.");
          }
        } else {
          Message().showMessage(
              message:
                  "The Password must contain at least 8 characters with an Uppercase Letter,LowerCase letter, a Number and a Special Character.");
        }
      } else {
        Message().showMessage(message: "Please Enter A valid Email.");
      }
    } else {
      Message().showMessage(message: "Enter Details.");
    }
  }

  Widget buildBody(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.center,
      child: Column(children: [
        Container(
            margin: EdgeInsets.only(top: height * 0.07, bottom: height * 0.03),
            child: Column(
              children: [
                Text(
                  "SignUp",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: height * 0.03, bottom: height * 0.01),
                  child: ChatInputField(
                    hintText: "Enter Your Name",
                    icon: Icon(Icons.person),
                    type: TextInputType.emailAddress,
                    controller: name,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height * 0.03),
                  child: ChatInputField(
                    hintText: "Enter Your Email",
                    icon: Icon(Icons.email),
                    type: TextInputType.emailAddress,
                    controller: email,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height * 0.01),
                  child: ChatInputField(
                    hintText: "Password",
                    isHideText: true,
                    icon: Icon(Icons.lock),
                    type: TextInputType.visiblePassword,
                    controller: password,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height * 0.03),
                  child: ChatInputField(
                    hintText: "Confirm Password",
                    isHideText: true,
                    controller: passwordCon,
                    icon: Icon(Icons.lock),
                    type: TextInputType.visiblePassword,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.04),
                  child: Container(
                    child: ChatButton(
                      onClick: () => validateInputs(context),
                      width: 150,
                      height: 40,
                      text: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 20),
                      ),
                      radius: 15,
                    ),
                  ),
                )
              ],
            )),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).accentColor,
      body: buildBody(context),
    );
  }
}
