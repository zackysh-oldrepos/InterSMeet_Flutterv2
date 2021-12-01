import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intersmeet/core/constants/api_constants.dart';
import 'package:intersmeet/core/models/user.dart';

class AuthenticationService {
  late FlutterSecureStorage _storage;

  AuthenticationService() {
    _storage = const FlutterSecureStorage();
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  Future<User?> signInUsingToken() async {
    String? token = await getAccessToken();
    if (token == null) return null;

    Response res = await http.post(apiUrl, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token)',
    });

    switch (res.statusCode) {
      case 200:
        return res.body as User;
      case 401:
        return null;
    }
  }
}
