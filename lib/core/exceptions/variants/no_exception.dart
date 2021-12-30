import 'package:intersmeet/core/exceptions/base_api_exception.dart';

/// This is an auxiliar class to allow non-exception
/// in behaviour subject, since null-safety doesn't allow
/// publishing "null".
class NoException extends BaseApiException {
  NoException({required String message})
      : super(message: message, statusCode: 400, title: "No exception");
}
