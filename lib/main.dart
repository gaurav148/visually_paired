import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:contacts_service/contacts_service.dart';  
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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

      case "messageContact":
        debugPrint("Message contact func executed");
        messageContact(response["inputMessage"], response["name"]);
        break;

      default:
        debugPrint("no match found");
        break;
    }
  }

  calculateInput(String input) {
    //50 + 30
    int length = input.length;
    int temp = 0;
    var numbers = [];
    var signs = [];
    int i = 0;
    while (i < length) {
      if (input[i] == '+' ||
          input[i] == '-' ||
          input[i] == '*' ||
          input[i] == '/') {
        debugPrint(input[i]);
        signs.add(input[i]);
      }

      while (i < length &&
          input.codeUnitAt(i) >= 48 &&
          input.codeUnitAt(i) <= 57) {
        temp = temp * 10 + (input.codeUnitAt(i) - 48);
        i++;
        if (!(i < length &&
            input.codeUnitAt(i) >= 48 &&
            input.codeUnitAt(i) <= 57)) {
          numbers.add(temp);
        }
      }

      //debugPrint(numbers);
      temp = 0;

      i++;
    }
    double ans = numbers[0] / 1.00;

   // debugPrint(numbers);
    //debugPrint(signs);

    for (int j = 0; j < signs.length; j++) {
      if (signs[j] == '+') {
        ans = ans + numbers[j + 1];
      }

      if (signs[j] == '-') {
        ans = ans - numbers[j + 1];
      }

      if (signs[j] == '*') {
        ans = ans * numbers[j + 1];
      }

      if (signs[j] == '/') {
        ans = ans / numbers[j + 1];
      }
    }

    String finalAnswer = ans.toStringAsFixed(2);

    if (ans % 1 == 0) {
      finalAnswer = ans.toStringAsFixed(0);
    }

    AlanVoice.playText("Your answer is " + finalAnswer);
  }

Iterable<Contact> contacts = [];
  accessContacts() async {
    if (await Permission.contacts.request().isGranted) {
            Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
            for(final contact in contacts){
              debugPrint(contact.displayName);
              for(final phone in contact.phones!){     //Not checking if the number of phones are none or not
                debugPrint(phone.value);
              }
            }
          }     
  }

  searchContact(String name) async {
    debugPrint(name);
    Iterable<Contact> contacts = await ContactsService.getContacts(query : name);
    if(contacts.isNotEmpty){
      for(final contact in contacts){
      debugPrint(contact.displayName.toString());
      debugPrint(contact.phones?.elementAt(0).value.toString());
    }
    bool? res = await FlutterPhoneDirectCaller.callNumber(contacts.first.phones!.first.value.toString());
    debugPrint(res.toString());

    }else{
        AlanVoice.playText("No such contact!");   
    }
    

  }

  callContact(String name) async {
    
  }

  searchContactForMessage(String name) async {
    debugPrint(name);
    Iterable<Contact> contacts = await ContactsService.getContacts(query : name);
    if(contacts.isNotEmpty){
      if(contacts.length == 1){
        AlanVoice.playText("Contact found!");
        callProjectApi("messageContactUsingAPI", {"name" : name, "flag": "1"});
      }else{
        AlanVoice.playText("Do you want to text ");
        for(var contact in contacts){
          if(contact != contacts.last){
            AlanVoice.playText(contact.displayName.toString() + " or ");
          }else{
            AlanVoice.playText(contact.displayName.toString());
          }    
        }
      callProjectApi("messageContactUsingAPI", {"name" : name, "flag": "2"});
      }
      
  }else{
    AlanVoice.playText("No such contact found!");
  }


  } 


  messageContact(String inputMessage, String name) async {
    
    Iterable<Contact> contacts = await ContactsService.getContacts(query : name);
    if(contacts.isNotEmpty){
      for(final contact in contacts){
        debugPrint(contact.displayName.toString());
        debugPrint(contact.phones?.elementAt(0).value.toString());
      }

        var permission = await Permission.sms.request();
        debugPrint(permission.isGranted.toString());
      if(permission.isGranted){
        telephony.sendSms(
        to: contacts.first.phones!.first.value.toString(),
        message: inputMessage
        );
    }
    AlanVoice.playText("Done!");
  }
  }

  callProjectApi(String funcName, Map<String, Object> data) {
    /// Providing any params with json
    var params = jsonEncode(data);
    AlanVoice.callProjectApi(funcName, params);
  }

}
