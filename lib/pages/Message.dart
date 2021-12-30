// ignore_for_file: unnecessary_const

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import '../functions/helper_functions.dart';
import '../functions/message_functions.dart';



class Message extends StatefulWidget {
  const Message({ Key? key }) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

String printName = "";

class _MessageState extends State<Message> {
  
  bool selected = false;
  _MessageState(){
    AlanVoice.activate();
    callProjectApi("onTapMessage", {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        debugPrint("Popping from message.dart");
        callProjectApi("resolve", {});
        return true;
      },
      child: const Scaffold(
        backgroundColor: Colors.yellow,
        body: Center(
          child: Text(
            "Message",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )
        )
      ),
    );
  }
  
}




