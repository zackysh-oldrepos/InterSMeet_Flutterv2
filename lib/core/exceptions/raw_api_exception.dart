import 'dart:convert';

class RawApiException {
  final String message;
  final int statusCode;

  RawApiException({required this.message, required this.statusCode});

  static RawApiException fromJson(String json) {
    var decoded = jsonDecode(json);
    return RawApiException(message: decoded['error'], statusCode: decoded['statusCode']);
  }
}
