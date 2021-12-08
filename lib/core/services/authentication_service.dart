import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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

    var res = await http.post(Uri.parse("$apiUrl/users/refresh-access-token"),
        headers: {'Authorization': 'Bearer $token)'});

    if (res.statusCode == 200) return res.body as User;
    return null;
  }
}
