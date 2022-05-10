import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:telephony/telephony.dart';
import 'package:visually_paired/pages/Call.dart';
import 'package:visually_paired/pages/Currency.dart';
import 'package:visually_paired/pages/Message.dart';
import 'package:visually_paired/pages/MyOptions.dart';
import 'package:visually_paired/pages/twitter.dart';
import '../functions/calculator_functions.dart';
import '../functions/call_functions.dart';
import '../functions/message_functions.dart';
import '../functions/helper_functions.dart';
import 'Message.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int temp = 0;
  bool isAlanActive = false;
  late CameraDescription firstCamera;
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
      body: Center(
        child: GestureDetector(
              onTap: () {
                AlanVoice.activate();
                Navigator.push(context,MaterialPageRoute(builder: (context) => const MyOptions()));
              },
              child: Container(
                color: Colors.yellow.shade600,
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // Change button text when light changes state.
                child: const Center(
                    child: Text(
                      "Tap Here...",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                ),
              ),
            ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


    _handleCommand(Map<String, dynamic> response)  async {
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
      if(response["value"] == "message"){
        Navigator.push(context,MaterialPageRoute(builder: (context) => Message(displayNamestream: displayNameController.stream, 
                                                                               displayMessageStream: displayMessageController.stream)));
      }else{
        debugPrint("Call page called");
        Navigator.push(context,MaterialPageRoute(builder: (context) => Call(displayNamestream: displayNameController.stream)));
      }
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
      
      case "multipleContactCaseForMessage":
        debugPrint("Multiple contact case for message executed");
        multipleContactCaseForMessage(response["number"]);
        break;

      case "multipleContactCaseForCall":
        debugPrint("Multiple contact case for call executed");
        multipleContactCaseForCall(response["number"]);
        break;

      case "messageContact":
        debugPrint("Message contact func executed");
        messageContact(response["inputMessage"], response["name"], telephony);
        break;

      case "checkSpelledNameForText":
        debugPrint("Spelling check func executed");
        checkSpelledNameForText(response["spelledName"]);
        break;

      case "checkSpelledNameForCall":
        debugPrint("Spelling check func executed");
        checkSpelledNameForCall(response["spelledName"]);
        break;
      
      case "exit":
        debugPrint("Exit command called");
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const MyOptions()));
        break;
      
      case "detectCurrency":
        debugPrint("Currency detection command called");
        getCamera();
        Navigator.push(context,MaterialPageRoute(builder: (context) => Currency(firstCamera: firstCamera)));
        break;

      case "tweet":
        debugPrint("Tweet detected");
        List<String> tweets = await twitterAPI();
        Navigator.push(context,MaterialPageRoute(builder: (context) => TwitterAPI(tweets: tweets)));
        break;
      

      default:
        debugPrint("no match found");
        break;
    }
  }


    getCamera() async{
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    debugPrint("The list of camers are: "+cameras.toString());
    firstCamera = cameras.first;
    debugPrint("first camera is :  "+firstCamera.toString());
  }


}