import 'package:intersmeet/core/exceptions/base_api_exception.dart';

/// Serves as a wrapper for BaseApiException to
/// represent internal server-error exceptions.
class ServerErrorException extends BaseApiException {
  ServerErrorException({required String message})
      : super(
            message: message,
            statusCode: 500,
            title: "Internal Api server error");
}
