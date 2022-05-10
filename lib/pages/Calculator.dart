// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import '../functions/helper_functions.dart';



class Calculate extends StatefulWidget {
  const Calculate({ Key? key, required this.displayValuestream, required this.displayTextstream}) : super(key: key);
  final Stream<String>  displayValuestream;
  final Stream<String>  displayTextstream;

  @override
  _CalculateState createState() => _CalculateState();
}


class _CalculateState extends State<Calculate> {
  String finalText = "What do you want to calculate?";
  String finalValue = "";
  late StreamSubscription<String> displayValuestreamSubscription;
  late StreamSubscription<String> displayTextstreamSubscription;
  bool selected = false;
  _CalculateState(){
    AlanVoice.activate();
  }

  void initState() {
    super.initState();
    displayTextstreamSubscription = widget.displayTextstream.listen((message) {
      setDisplayMessage(message);
    });

    displayValuestreamSubscription = widget.displayValuestream.listen((value) {
      setDisplayValue(value);
    });
    
    
    AlanVoice.activate();
    callProjectApi("onTapCalculate", {});
    debugPrint("Message initState called");
  }

  void setDisplayMessage(String message){
    setState(() {
      finalText = message;
    });
  }

  void setDisplayValue(String value){
    setState(() {
      finalValue = value;
    });
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        debugPrint("Popping from Calculate.dart");
        callProjectApi("resolve", {});
        AlanVoice.deactivate();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.purpleAccent,
        body: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  finalText,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  finalValue,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
  
}




