import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import '../functions/helper_functions.dart';
class Message extends StatefulWidget {
  const Message({ Key? key }) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {

  _MessageState(){
    debugPrint("Hua dekh.");
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
        body: Center(
          child: Text("Message")
        ),
      ),
    );
  }
}