import 'package:intersmeet/core/exceptions/base_api_exception.dart';

/// Serves as a wrapper for BaseApiException to
/// represent bad-request exceptions.
class BadRequestException extends BaseApiException {
  BadRequestException({required String message})
      : super(message: message, statusCode: 400, title: "Bad request");
}
