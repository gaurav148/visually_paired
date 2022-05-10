import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:visually_paired/functions/helper_functions.dart';

calculateInput(String input) {
  displayTextController.add(input);
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
    displayValueController.add(finalAnswer);
  }