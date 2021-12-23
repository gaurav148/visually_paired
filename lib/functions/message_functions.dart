import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:contacts_service/contacts_service.dart';  
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'helper_functions.dart';


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


  messageContact(String inputMessage, String name, Telephony telephony) async {
    
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