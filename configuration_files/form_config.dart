import 'package:flutter/services.dart';

class FormValidator {
  static String? passwordFieldValidator(String? value) {
    final RegExp _passwordExp =
    RegExp(r'^(?=.*?[A-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isNotEmpty && value.length >= 8 && value.contains(_passwordExp)) {
      return null;
    } else {
      return 'Should be 8 character long, Must include '
          '\nAlphabets,digits,and special characters';
    }
  }

  static String? emailFieldValidator(String? value) {
    final RegExp _emailExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))'
        r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.'
        r'[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value!.isNotEmpty && value.contains(_emailExp)) {
      return null;
    } else {
      return 'Invalid Email';
    }
  }

  static String? textFieldValidator({String? value, String? errorText}) {
    if (value!.isNotEmpty) {
      return null;
    } else {
      return errorText;
    }
  }
}


class InputFormat {
  static final emailInputFormat = <FilteringTextInputFormatter>[
    FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
  ];
  static final passwordInputFormat = <FilteringTextInputFormatter>[
    FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
  ];
}