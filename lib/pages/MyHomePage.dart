import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:telephony/telephony.dart';
import '../functions/calculator_functions.dart';
import '../functions/call_functions.dart';
import '../functions/message_functions.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int temp = 0;
  final Telephony telephony = Telephony.instance;
  _MyHomePageState() {
    //init Alan with sample project id
    AlanVoice.addButton(
        "010b1fa1b332e8eec42ae9d6f3c23da22e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    // Listening to the Alan button state changes
    AlanVoice.callbacks.add((command) {
      temp++;
      if(temp==1){
        _handleCommand(command.data);
      }else{
        temp = 0;
      }
    });

    

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
          bool? res = await FlutterPhoneDirectCaller.callNumber("+918082010702");
          debugPrint(res.toString());
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


    _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "add":
        var ans = int.parse(response["num1"]) + int.parse(response["num2"]);
        AlanVoice.playText("Your answer is" + ans.toString());
        break;

      case "calculation":
        debugPrint("calculation case executed");
        calculateInput(response["value"]);
        break;

      case "accessContacts":
        debugPrint("Access Contacts function executed");
        accessContacts();
        break;

      case "callContact":
        debugPrint("Calling contact function executed");
        searchContact(response["name"]);
        break;

      case "searchContactForMessage":
        debugPrint("Search contact for message function exectued");
        searchContactForMessage(response["name"]);
        break;
      
      case "multipleContactCase":
        debugPrint("Multiple contact case executed");
        multipleContactCase(response["number"]);
        break;

      case "messageContact":
        debugPrint("Message contact func executed");
        messageContact(response["inputMessage"], response["name"], telephony);
        break;

      default:
        debugPrint("no match found");
        break;
    }
  }



}