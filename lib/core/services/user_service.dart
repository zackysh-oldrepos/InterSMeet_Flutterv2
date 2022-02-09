import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intersmeet/core/constants/api.dart';
import 'package:intersmeet/core/models/degree/degree.dart';
import 'package:intersmeet/core/models/student/update_student.dart';
import 'package:intersmeet/core/models/user/auth/auth_response.dart';
import 'package:intersmeet/core/models/user/language/language.dart';
import 'package:intersmeet/core/models/user/province/province.dart';
import 'package:intersmeet/core/models/user/user.dart';
import 'package:intersmeet/core/services/storage_service.dart';

import '../../main.dart';

class UserService {
  final _dio = getIt<Dio>();
  final _storageService = getIt<StorageService>();

  Future<bool> updateProfile(UpdateStudent updateStudent) async {
    var res = await _dio.put(
      "$apiUrl/students/update-profile",
      data: jsonEncode(updateStudent.toJson()),
    );

    if (res.statusCode == 200) _storeSessionData(res);
    return res.statusCode == 200;
  }

  Future<List<Province>> findAllProvinces() async {
    var res = await _dio.get("$apiUrl/users/provinces");
    return Future.value(List<Province>.from(res.data.map((p) => Province.fromJson(p))));
  }

  Future<List<Language>> findAllLanguages() async {
    var res = await _dio.get("$apiUrl/users/languages");
    return Future.value(List<Language>.from(res.data.map((p) => Language.fromJson(p))));
  }

  Future<List<Degree>> findAllDegrees() async {
    var res = await _dio.get("$apiUrl/students/degrees");
    return Future.value(List<Degree>.from(res.data.map((p) => Degree.fromJson(p))));
  }

  Future<int> applicationCount() async {
    var res = await _dio.get("$apiUrl/students/application-count");
    return res.data;
  }

  Future<void> _storeSessionData(Response res) async {
    var user = User.fromJson(res.data);
    user.avatar = _storageService.getUser()?.avatar;
    _storageService.storeSessionData(AuthResponse(user: user), null);
  }
}
