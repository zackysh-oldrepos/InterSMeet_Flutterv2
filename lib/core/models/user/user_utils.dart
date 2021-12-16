bool isEmail(String value) {
  RegExp _mailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
  var isValid = _mailRegex.hasMatch(value.toLowerCase());
  return isValid ? true : false;
}

class CustomValidators {
  static String? Function(String val) maxLength(int length) {
    return (String val) {
      if (val.length > length) {
        return "This field max length is $length characters";
      }
      return null;
    };
  }
}
