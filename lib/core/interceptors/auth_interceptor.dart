import 'package:dio/dio.dart';
import 'package:intersmeet/core/services/storage_service.dart';
import 'package:intersmeet/main.dart';

class AuthInterceptor extends Interceptor {
  final _tokenService = getIt<StorageService>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // @ Headers
    String? accessToken = _tokenService.getAccessToken();
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
