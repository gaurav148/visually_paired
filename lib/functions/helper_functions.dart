import 'dart:convert';
import 'package:alan_voice/alan_voice.dart';

callProjectApi(String funcName, Map<String, Object> data) {
    /// Providing any params with json
    var params = jsonEncode(data);
    AlanVoice.callProjectApi(funcName, params);
  }