import 'package:flutter/material.dart';
import 'package:Gchat/Screens/device_info.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WidgetTest extends StatelessWidget {
  const WidgetTest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var items = List<String>.generate(100, (index) => "$index");
    TextEditingController a = TextEditingController();
    return Scaffold();
  }
}

/**********************************Show Message*********************************/
class Message {
  void showMessage({String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
/**********************************Chat Message*********************************/

class ChatMessage extends StatefulWidget {
  String message, sender, time;
  Color leftColor, rightColor;
  bool directionRight;
  ChatMessage(
      {Key key,
      this.message,
      this.leftColor,
      this.rightColor,
      this.directionRight,
      this.sender,
      this.time})
      : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    var height = DeviceSize(context).height;
    var width = DeviceSize(context).width;
    return Row(
      mainAxisAlignment: (widget.directionRight ?? true)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(widget.sender ?? "sender"),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: (widget.directionRight ?? true)
                        ? (widget.rightColor ?? Colors.white)
                        : (widget.leftColor ?? Colors.yellow),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.message ?? "Hello",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      flex: -1,
                      child: Text(
                        widget.time ?? "00:00",
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

/**********************************Chat Item***********************************/
class ChatItem extends StatefulWidget {
  String img, name, last_msg, time;
  Color name_color, last_msg_color, time_color, color, div_color;
  Function onClick;
  ChatItem(
      {Key key,
      this.time,
      this.onClick,
      this.img,
      this.last_msg,
      this.name,
      this.last_msg_color,
      this.name_color,
      this.time_color,
      this.color,
      this.div_color})
      : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var height = DeviceSize(context).height;
    var width = DeviceSize(context).width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: widget.color ?? Color(0xff303030),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onClick(),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5, right: 10),
                            width: 60,
                            height: 60,
                            child: Image.asset("lib/assets/images/b.png"),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 5),
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      widget.name ?? "Name",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: widget.name_color ??
                                              Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                        widget.last_msg ?? "Last Massage",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: widget.last_msg_color ??
                                                Colors.white),
                                        textAlign: TextAlign.left),
                                  ),
                                ],
                              )),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 22, right: 10),
                              child: Text(
                                widget.time ?? "9:00 PM",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: widget.time_color ?? Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          height: 0.6,
          color: Colors.black.withOpacity(0.8),
        )
      ],
    );
  }
}

/**********************************Chat Button***********************************/
class ChatButton extends StatelessWidget {
  Function onClick;
  Color color;
  double width, height;
  Text text;
  double radius;

  ChatButton(
      {Key key,
      this.onClick,
      this.color,
      this.width,
      this.height,
      this.text,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 10)),
      onPressed: onClick ?? () {},
      color: color ?? Colors.white,
      elevation: 6,
      child: Container(
        alignment: Alignment.center,
        width: width ?? 60,
        height: height ?? 20,
        child: text ?? Text("Click Here"),
      ),
    );
  }
}

/**********************************Chat Input Field***********************************/
class ChatInputField extends StatefulWidget {
  Key key;
  TextEditingController controller;
  bool isHideText;
  Icon icon;
  String hintText;
  TextInputType type;
  double radius;

  ChatInputField(
      {this.key,
      this.controller,
      this.hintText,
      this.icon,
      this.isHideText,
      this.type,
      this.radius})
      : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      child: Material(
        color: Colors.transparent,
        elevation: 20,
        shadowColor: Colors.black.withOpacity(0.5),
        child: TextField(
          controller: widget.controller ?? TextEditingController(),
          obscureText: widget.isHideText ?? false,
          keyboardType: widget.type ?? TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: widget.icon ?? Icon(Icons.text_fields),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText ?? "Enter Here",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 20),
            ),
          ),
        ),
      ),
    );
  }
}
