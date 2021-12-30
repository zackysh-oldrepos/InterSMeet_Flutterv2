import 'package:dio/dio.dart';
import 'package:intersmeet/core/services/authentication_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var authService = AuthenticationService();

    // @ Headers
    String? accessToken = await authService.getAccessToken();
    if (accessToken != null) {
      options.headers.addAll({"Authorization": "Bearer $accessToken"});
    }
    if (!options.headers.containsKey('Content-Type')) {
      options.headers.addAll({
        "Content-Type": "application/json",
      });
    }
    // @ Dio options
    options.followRedirects = false;
    options.validateStatus = (status) {
      return status != null && status < 500;
    };
    handler.next(options);
  }
}
