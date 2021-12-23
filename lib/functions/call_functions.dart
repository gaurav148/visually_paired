import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';  
import 'package:permission_handler/permission_handler.dart';



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