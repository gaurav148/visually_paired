import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:contacts_service/contacts_service.dart';  
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'functions/calculator_functions.dart';
import 'functions/call_functions.dart';
import 'functions/helper_functions.dart';
import 'functions/message_functions.dart';
import 'pages/MyHomePage.dart';




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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Visually Paired'),
      debugShowCheckedModeBanner: false,
    );
  }
}

