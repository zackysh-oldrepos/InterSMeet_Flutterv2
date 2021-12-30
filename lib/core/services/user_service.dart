// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intersmeet/core/constants/api_constants.dart';
import 'package:intersmeet/core/models/degree.dart';
import 'package:intersmeet/core/models/language.dart';
import 'package:intersmeet/core/models/province.dart';

class UserService {
  Future<List<Province>> findAllProvinces() async {
    var res = await http.get(Uri.parse("$apiUrl/users/provinces"));
    await Future.delayed(const Duration(milliseconds: 600));
    return Future.value(List<Province>.from(jsonDecode(res.body).map((p) => Province.fromJson(p))));
  }

  Future<List<Language>> findAllLanguages() async {
    var res = await http.get(Uri.parse("$apiUrl/users/languages"));
    return Future.value(List<Language>.from(jsonDecode(res.body).map((p) => Language.fromJson(p))));
  }

  Future<List<Degree>> findAllDegrees() async {
    var res = await http.get(Uri.parse("$apiUrl/students/degrees"));
    return Future.value(List<Degree>.from(jsonDecode(res.body).map((p) => Degree.fromJson(p))));
  }
}
