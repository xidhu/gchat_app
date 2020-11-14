import 'package:Gchat/Screens/ForgotPassword/ForgotPage.dart';
import 'package:Gchat/Screens/Main/MainPage.dart';
import 'package:Gchat/firebase/Auth.dart';
import 'package:Gchat/firebase/firestore.dart';
import 'package:Gchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Gchat/Screens/SignUp/SignUpPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  void validate() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.email.text != "" && widget.pass.text != "") {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(widget.email.text)) {
        if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(widget.pass.text)) {
          setState(() {
            isLoading = true;
          });
          Auth()
              .Login(email: widget.email.text, password: widget.pass.text)
              .then((user) {
            setState(() {
              isLoading = false;
            });
            if (user == "0") {
              Message().showMessage(message: "Please Verify Your Email.");
            } else if (user == false) {
              Message()
                  .showMessage(message: "Username or Password is incorrect.");
            } else {
              widget.email.clear();
              widget.pass.clear();
              db().hasUser(uid: user.uid).then((value) {
                if (value) {
                  Message().showMessage(message: "Logged In");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage(
                                user: user,
                                key: Key("1"),
                              )));
                }
                if (!value && user.verified) {
                  db().createUser(user).then((g) {
                    if (g == true) {
                      Message().showMessage(message: "Logged In");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPage(
                                    user: user,
                                    key: Key("1"),
                                  )));
                    }
                  });
                } else if (!user.verified) {
                  Message().showMessage(message: "Please Verify Your Email.");
                }
              });
            }
          });
        } else {
          Message().showMessage(message: "Please Enter A valid Password.");
        }
      } else {
        Message().showMessage(message: "Please Enter A valid Email.");
      }
    } else {
      Message().showMessage(message: "Please Enter Credentials.");
    }
  }

  Widget buildBody() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return !isLoading
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.center,
            child: Column(children: [
              Container(
                  margin: EdgeInsets.only(top: height * 0.3),
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.1, vertical: height * 0.03),
                        child: ChatInputField(
                          hintText: "Email",
                          icon: Icon(Icons.email),
                          type: TextInputType.emailAddress,
                          controller: widget.email,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: width * 0.1, vertical: height * 0.01),
                        child: ChatInputField(
                          hintText: "Password",
                          isHideText: true,
                          controller: widget.pass,
                          icon: Icon(Icons.lock),
                          type: TextInputType.visiblePassword,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.04),
                        child: ChatButton(
                          onClick: () => validate(),
                          width: 150,
                          height: 40,
                          text: Text(
                            "Log In",
                            style: TextStyle(fontSize: 20),
                          ),
                          radius: 15,
                        ),
                      ),
                      Container(
                        child: InkWell(
                          child: Text("forgot password"),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPage()))
                          },
                        ),
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have An Account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Text(" Sign Up Now"))
                  ],
                ),
              )
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
      body: buildBody(),
    );
  }
}
