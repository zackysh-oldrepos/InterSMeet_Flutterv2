import 'package:intersmeet/core/exceptions/base_api_exception.dart';
import 'package:rxdart/rxdart.dart';

/// Class which offer a stream where unhandled exceptions (like an error with code 500) are published.
/// Widgets can listen the stream and react accordingly.
class ExceptionHandler {
  BaseApiException? currentException;
  BehaviorSubject<BaseApiException> alert = BehaviorSubject();

  publishException(BaseApiException ex) {
    alert.add(ex);
  }

  Stream<BaseApiException> suscribe() {
    return alert.stream;
  }
}
