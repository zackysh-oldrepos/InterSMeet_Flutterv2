import 'dart:typed_data';

import 'package:flutter/material.dart';

bool isEmail(String value) {
  RegExp _mailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
  var isValid = _mailRegex.hasMatch(value.toLowerCase());
  return isValid ? true : false;
}

typedef Validator = String? Function(String? val);
typedef DynamicValidator = String? Function(dynamic val);

MemoryImage imageFromList(List<int> bytes) {
  return MemoryImage(Uint8List.fromList(bytes));
}

class Validators {
  /// Return a validator that will execute provided validators to validate `val`.
  /// Returns first failing validator error fail or null if any validator fails.
  static Validator mixValidators(List<Validator> validators) {
    return (String? val) {
      for (var validator in validators) {
        var res = validator(val);
        if (res != null) return res;
      }

      return null;
    };
  }

  static Validator maxLength(int length) {
    return (String? val) {
      if (val != null && val.length > length) {
        return "This field maximum length is $length characters";
      }
      return null;
    };
  }

  static Validator minLength(int length) {
    return (String? val) {
      if (val != null && val.length < length) {
        return "This field minimum length is $length characters";
      }
      return null;
    };
  }

  static DynamicValidator requiredd() {
    return (dynamic val) {
      if (val == null ||
          val == false ||
          ((val is Iterable || val is String || val is Map) && val.isEmpty)) {
        return "Required";
      }
      return null;
    };
  }

  static Validator email() {
    return (String? string) {
      final emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
      if (string == null || string.isEmpty || emailRegExp.hasMatch(string)) {
        return null;
      }

      return "Invalid email";
    };
  }
}
