import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

//import 'package:flutter_icons/flutter_icons.dart';
class chatBot extends StatefulWidget {
  const chatBot({Key? key}) : super(key: key);

  @override
  _chatBotState createState() => _chatBotState();
}

class _chatBotState extends State<chatBot> {
  @override
  var messageController = TextEditingController();
  // ignore: deprecated_member_use
  var robotMsg;
  List<Map> messsages = [];
  Future response(String msg) async {
    http.Response response = await http.get(Uri.parse(
        "http://api.brainshop.ai/get?bid=163268&key=T1X76NSKzFrbZDEj&uid=[uid]&msg=" +
            msg));
    var result = jsonDecode(response.body);
    setState(() {
      robotMsg = result["cnt"];
      messsages.insert(0, {"data": 0, "message": robotMsg.toString()});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 77, 74, 74),
      appBar: AppBar(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        title: AnimatedTextKit(
          animatedTexts: [
           TypewriterAnimatedText("ChatBot",
           speed: Duration(milliseconds: 300)),

          ],
          //isRepeatingAnimation: true,
          )
      ),
      body: Container(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: messsages.length,
                  itemBuilder: (context, index) => chat(
                      messsages[index]["message"].toString(),
                      messsages[index]["data"]))),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 5,
            color: Colors.greenAccent,
          ),
          Center(
            child: Container(
              child: ListTile(
                leading: FaIcon(FontAwesomeIcons.cameraRetro,color: Colors.green,),
                title: Container(
                  height: 35.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 15.0),
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter the message",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.greenAccent,
                  ),
                  onPressed: () {
                    if (messageController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Enter the message",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                        
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      
                    } else {
                      setState(() {
                        messsages.insert(
                            0, {"data": 1, "message": messageController.text});
                      });
                      response(messageController.text);
                      messageController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    child: FaIcon(FontAwesomeIcons.robot),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
              nip: BubbleNip.leftTop,
                radius: Radius.circular(15.0),
                color: data == 0
                    ? Color.fromRGBO(23, 157, 139, 1)
                    : Colors.orangeAccent,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    child: FaIcon(FontAwesomeIcons.user),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
