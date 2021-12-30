import 'package:intersmeet/core/exceptions/base_api_exception.dart';

/// Serves as a wrapper for BaseApiException to
/// represent not found exceptions (specially usefull when ).
class UnauthorizedException extends BaseApiException {
  UnauthorizedException({required String message})
      : super(message: message, statusCode: 400, title: "Unauthorized");
}
