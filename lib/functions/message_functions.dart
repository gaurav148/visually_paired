import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'helper_functions.dart';

Iterable<Contact> multipleNameList = [];
searchContactForMessage(String name) async {
  debugPrint(name);
  Iterable<Contact> contacts = await ContactsService.getContacts(query: name);
  if (contacts.isNotEmpty) {
    if (contacts.length == 1) {
      AlanVoice.playText("Contact found!");
      callProjectApi("messageContactUsingAPI", {"name": name, "flag": "1"});
    } else {
      multipleNameList = contacts;
      AlanVoice.playText("Multiple contacts found. To text");
      int i = 1;
      for (var contact in contacts) {
        AlanVoice.playText(
            contact.displayName.toString() + ", say " + i.toString());
        i++;
      }
      callProjectApi("messageContactUsingAPI", {"name": name, "flag": "2"});
    }
  } else {
    AlanVoice.playText("No such contact found! Can you please spell the first name.");
    callProjectApi("spellNameAPI",{});
  }

}

checkSpelledName(String spelledName) async {
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
    searchContactForMessage(output["bestMatch"]!);
  }else{
    AlanVoice.playText("I didn't get that! Can you spell it again?");
    callProjectApi("spellNameAPI",{});
  }
}

multipleContactCase(String number) {
  Map<String, String> m = {"fo": "4", "to": "2"};
  try{
    int num = int.parse(number);
    int i = 1;
    for (var contact in multipleNameList) {
      if (i == num) {
        AlanVoice.playText("Contact name is " + contact.displayName.toString());
        callProjectApi("messageContactUsingAPI",
            {"name": contact.displayName.toString(), "flag": "1"});
        break;
      }
      i++;
    }
  }catch(e){
    debugPrint(e.toString());
    AlanVoice.playText("Can you please repeat the number?");
    callProjectApi("messageContactUsingAPI", { "flag": "2"});
  }
 
}

messageContact(String inputMessage, String name, Telephony telephony) async {
  Iterable<Contact> contacts = await ContactsService.getContacts(query: name);
  if (contacts.isNotEmpty) {
    for (final contact in contacts) {
      debugPrint(contact.displayName.toString());
      debugPrint(contact.phones?.elementAt(0).value.toString());
    }

    var permission = await Permission.sms.request();
    debugPrint(permission.isGranted.toString());
    if (permission.isGranted) {
      telephony.sendSms(
          to: contacts.first.phones!.first.value.toString(),
          message: inputMessage);
    }
    AlanVoice.playText("Done!");
  }
}
