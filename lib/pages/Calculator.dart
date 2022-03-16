// ignore_for_file: unnecessary_const

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import '../functions/helper_functions.dart';



class Calculate extends StatefulWidget {
  const Calculate({ Key? key }) : super(key: key);

  @override
  _CalculateState createState() => _CalculateState();
}


class _CalculateState extends State<Calculate> {
  
  bool selected = false;
  _CalculateState(){
    AlanVoice.activate();
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
      child: const Scaffold(
        backgroundColor: Colors.purpleAccent,
        body: Center(
          child: Text(
            "Calculate",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )
        )
      ),
    );
  }
  
}




