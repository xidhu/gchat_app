import 'package:Gchat/Screens/Login/LoginPage.dart';
import 'package:Gchat/firebase/Auth.dart';
import 'package:flutter/material.dart';
import 'package:Gchat/widgets/widgets.dart';

class ForgotPage extends StatefulWidget {
  ForgotPage({Key key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final TextEditingController email = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  validateInputs(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (email.text != "") {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email.text)) {
        setState(() {
          isLoading = true;
        });
        Auth().Reset(email: email.text).then((user) {
          setState(() {
            isLoading = false;
          });
          email.clear();
          if (user == false) {
            Message().showMessage(message: "User Not Found.");
          } else {
            Message().showMessage(message: "Password Reset Email is Sent.");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
      } else {
        Message().showMessage(message: "Please Enter A valid Email.");
      }
    } else {
      Message().showMessage(message: "Please Enter Email");
    }
  }

  Widget buildBody(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return !isLoading
        ? Container(
            alignment: Alignment.center,
            child: Column(children: [
              Container(
                  margin: EdgeInsets.only(top: height * 0.15),
                  child: Column(
                    children: [
                      Text(
                        "Forgot Password",
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.15),
                        child: ChatInputField(
                          hintText: "Enter Your Email",
                          icon: Icon(Icons.email),
                          type: TextInputType.emailAddress,
                          controller: email,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.1),
                        child: Container(
                          child: ChatButton(
                            onClick: () => validateInputs(context),
                            width: 150,
                            height: 40,
                            text: Text(
                              "Reset Password",
                              style: TextStyle(fontSize: 20),
                            ),
                            radius: 15,
                          ),
                        ),
                      )
                    ],
                  )),
            ]),
          )
        : Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
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
