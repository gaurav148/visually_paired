// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import '../functions/helper_functions.dart';
import '../functions/message_functions.dart';
import 'package:animated_text_kit/animated_text_kit.dart';





class Message extends StatefulWidget {
  const Message({ Key? key, required this.displayNamestream, required this.displayMessageStream }) : super(key: key);
  final Stream<String>  displayNamestream;
  final Stream<String>  displayMessageStream;

  @override
  _MessageState createState() => _MessageState();
}


class _MessageState extends State<Message> {
  
  bool selected = false;
  String finalName = "Whom do you want to text?";
  String finalMessage = "";
  late StreamSubscription<String> displayNameStreamSubscription;
  late StreamSubscription<String> displayMessageStreamSubscription;
  @override
  void initState() {
    super.initState();
    displayNameStreamSubscription = widget.displayNamestream.listen((name) {
      setDisplayName(name);
    });

    displayMessageStreamSubscription = widget.displayMessageStream.listen((message) {
      setDisplayMessage(message);
    });
    
    AlanVoice.activate();
    callProjectApi("onTapMessage", {});
    debugPrint("Message initState called");
  }


  void setDisplayName(String name){
    setState(() {
      finalName = name;
    });
  }

    void setDisplayMessage(String message){
    setState(() {
      finalMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        displayNameStreamSubscription.cancel();
        debugPrint("Popping from message.dart");
        callProjectApi("resolve", {});
        AlanVoice.deactivate();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(finalName),
                FadeAnimatedText(finalMessage),
              ],
              // isRepeatingAnimation : false
            ),
          ),
          
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       finalName,
          //       style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          //     ),
          //     Text(
          //       finalMessage,
          //       style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          //     ),
          //   ],
          // )
        )
      ),
    );
  }
  
}




