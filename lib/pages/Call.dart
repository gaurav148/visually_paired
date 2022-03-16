// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import '../functions/helper_functions.dart';



class Call extends StatefulWidget {
  const Call({ Key? key, required this.displayNamestream }) : super(key: key);
  final Stream<String>  displayNamestream;

  @override
  _CallState createState() => _CallState();
}


class _CallState extends State<Call> {
  
  bool selected = false;
  String finalName = "";
  late StreamSubscription<String> displayNameStreamSubscription;

  void initState() {
    super.initState();
    displayNameStreamSubscription = widget.displayNamestream.listen((name) {
      setDisplayName(name);
    });
    
    AlanVoice.activate();
    callProjectApi("onTapCall", {});
    debugPrint("Call initState called");
  }

  void setDisplayName(String name){
    setState(() {
      finalName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        debugPrint("Popping from call.dart");
        callProjectApi("resolve", {});
        AlanVoice.deactivate();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                finalName,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ],
          )
        )
      ),
    );
  }
  
}




