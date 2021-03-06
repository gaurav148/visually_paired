import 'dart:convert';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import  'package:string_similarity/string_similarity.dart';
import 'dart:async';

StreamController<String> displayNameController = StreamController<String>.broadcast();
StreamController<String> displayMessageController = StreamController<String>.broadcast();

callProjectApi(String funcName, Map<String, Object> data) {
    /// Providing any params with json
    var params = jsonEncode(data);
    AlanVoice.callProjectApi(funcName, params);
  }


Map<String,String> checkStringSimilarity(String stringName, List<String> stringList){
  BestMatch matches = stringName.bestMatch(stringList); 
  debugPrint(matches.bestMatch.target);

  return {"bestMatch": matches.bestMatch.target!, "rating":matches.bestMatch.rating.toString()};
}

String concatenateString(String input){
  return input.replaceAll(" ", "");
}


