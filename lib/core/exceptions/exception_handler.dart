import 'package:intersmeet/core/exceptions/base_api_exception.dart';
import 'package:intersmeet/core/exceptions/raw_api_exception.dart';
import 'package:intersmeet/core/exceptions/variants/forbidden.dart';
import 'package:intersmeet/core/exceptions/variants/no_exception.dart';
import 'package:intersmeet/core/exceptions/variants/not_found.dart';
import 'package:intersmeet/core/exceptions/variants/server_error.dart';
import 'package:intersmeet/core/exceptions/variants/unauthorized.dart';
import 'package:rxdart/rxdart.dart';

/// Class which offer a stream where unhandled exceptions (like an error with code 500) are published.
/// Widgets can listen the stream and react accordingly.
class ExceptionHandler {
  final BehaviorSubject<BaseApiException> _alert = BehaviorSubject();

  publishException(RawApiException ex) {
    // Default exception
    BaseApiException exception = ServerErrorException(message: "Unknown exception");

    switch (ex.statusCode) {
      case 404:
        exception = NotFoundException(message: ex.message);
        break;
      case 401:
        exception = UnauthorizedException(message: ex.message);
        break;
      case 403:
        exception = ForbiddenException(message: ex.message);
        break;
      case 500:
        exception = ServerErrorException(message: ex.message);
        break;
    }

    _alert.add(exception);
  }

  publishNull() {
    _alert.add(NoException(message: "No exception"));
  }

  Stream<BaseApiException> suscribe() {
    return _alert.stream;
  }
}
