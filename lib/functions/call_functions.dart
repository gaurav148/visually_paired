import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';  
import 'package:permission_handler/permission_handler.dart';

import 'helper_functions.dart';

String finalName = "";
String finalMessage = "";

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

Iterable<Contact> multipleNameList = [];
searchContact(String name) async {
    debugPrint(name);
    Iterable<Contact> contacts = await ContactsService.getContacts(query : name);
    if(contacts.isNotEmpty){
      if (contacts.length == 1) {
        debugPrint("Single Contact found");
      AlanVoice.playText("Contact found!");
      bool? res = await FlutterPhoneDirectCaller.callNumber(contacts.first.phones!.first.value.toString());
    } else {
      debugPrint("Multiple Contact found");
      multipleNameList = contacts;
      AlanVoice.playText("Multiple contacts found. To call");
      int i = 1;
      for (var contact in contacts) {
        debugPrint("Multiple contact said out loud");
        AlanVoice.playText(
            contact.displayName.toString() + ", say " + i.toString());
        i++;
      }
      callProjectApi("callContactUsingAPI", {});
    }
    
    bool? res = await FlutterPhoneDirectCaller.callNumber(contacts.first.phones!.first.value.toString());
    // debugPrint(res.toString());

    }else{
        AlanVoice.playText("No such contact found! Can you please spell the first name.");
        callProjectApi("spellNameAPI",{"flag":"call"});
    }
    

  }

checkSpelledNameForCall(String spelledName) async {
  spelledName = concatenateString(spelledName);
  Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
  List<String> firstNameList = [];
  for(final contact in contacts){
    firstNameList.add(contact.givenName.toString());
    debugPrint(contact.givenName.toString());
  }
  
  var output = checkStringSimilarity(spelledName, firstNameList);
  if(double.parse(output["rating"]!) >=0.5){
    debugPrint(output["rating"]);
    AlanVoice.playText("Your contact name is "+ output["bestMatch"]!);
    searchContact(output["bestMatch"]!);
  }else{
    AlanVoice.playText("I didn't get that! Can you spell it again?");
    callProjectApi("spellNameAPI",{"flag": "call"});
  }
}


multipleContactCaseForCall(String number) async {
  Map<String, String> m = {"fo": "4", "to": "2"};
  try{
    int num = int.parse(number);
    int i = 1;
    for (var contact in multipleNameList) {
      if (i == num) {
        AlanVoice.playText("Contact name is " + contact.displayName.toString());
        finalName = contact.displayName.toString();
        // displayNameController.add(finalName);
        bool? res = await FlutterPhoneDirectCaller.callNumber(contact.phones!.first.value.toString());
        debugPrint(res.toString());
        break;
      }
      i++;
    }
  }catch(e){
    debugPrint(e.toString());
    AlanVoice.playText("Can you please repeat the number?");
    callProjectApi("callContactUsingAPI", {});
  }
 
}

