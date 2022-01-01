// ignore_for_file: unnecessary_const

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import '../functions/helper_functions.dart';



class Call extends StatefulWidget {
  const Call({ Key? key }) : super(key: key);

  @override
  _CallState createState() => _CallState();
}


class _CallState extends State<Call> {
  
  bool selected = false;
  _CallState(){
    AlanVoice.activate();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        debugPrint("Popping from call.dart");
        callProjectApi("resolve", {});
        return true;
      },
      child: const Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
          child: Text(
            "Call",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )
        )
      ),
    );
  }
  
}




