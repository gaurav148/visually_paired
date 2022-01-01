import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:visually_paired/pages/Calculator.dart';
import 'package:visually_paired/pages/Call.dart';
import '../functions/helper_functions.dart';
import 'Message.dart';

class MyOptions extends StatefulWidget {
  const MyOptions({ Key? key }) : super(key: key);

  @override
  _MyOptionsState createState() => _MyOptionsState();
}

class _MyOptionsState extends State<MyOptions> {

  var colors = [Colors.red, Colors.yellow, Colors.purple, Colors.green];
  var options = ["Call", "Message", "Calculate","Detect Currency"];
  var pages = [const Call(), 
               Message(displayNamestream: displayNameController.stream, displayMessageStream: displayMessageController.stream,), 
               const Calculate(), 
               Message(displayNamestream: displayNameController.stream, displayMessageStream: displayMessageController.stream,)];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
  builder: (context, constraint) {
    return GridView.builder(
    itemCount: 4,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: constraint.maxWidth / constraint.maxHeight,
    ),
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => pages[index]));
        },
        child: Container(
          color: colors[index],
          margin: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              options[index],
              style: const TextStyle(color: Colors.black, fontSize: 30, decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
    );
  },
);
  }
}