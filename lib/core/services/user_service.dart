import 'package:dio/dio.dart';
import 'package:intersmeet/core/constants/api.dart';
import 'package:intersmeet/core/models/degree.dart';
import 'package:intersmeet/core/models/language.dart';
import 'package:intersmeet/core/models/province.dart';

import '../../main.dart';

class UserService {
  final _dio = getIt<Dio>();

  Future<List<Province>> findAllProvinces() async {
    var res = await _dio.get("$apiUrl/users/provinces");
    await Future.delayed(const Duration(milliseconds: 600));
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
}
