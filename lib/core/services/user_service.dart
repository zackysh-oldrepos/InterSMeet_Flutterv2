import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intersmeet/core/constants/api.dart';
import 'package:intersmeet/core/models/degree/company.dart';
import 'package:intersmeet/core/models/degree/degree.dart';
import 'package:intersmeet/core/models/degree/family.dart';
import 'package:intersmeet/core/models/degree/level.dart';
import 'package:intersmeet/core/models/offer/application.dart';
import 'package:intersmeet/core/models/offer/application_pagination_response.dart';
import 'package:intersmeet/core/models/offer/offer_pagination_response.dart';
import 'package:intersmeet/core/models/offer/pagination_options.dart';
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

  // -----------------------------------------------------------
  // @ User
  // -----------------------------------------------------------

  Future<bool> updateProfile(UpdateStudent updateStudent) async {
    var res = await _dio.put(
      "$apiUrl/students/update-profile",
      data: jsonEncode(updateStudent.toJson()),
    );

    if (res.statusCode == 200) _storeSessionData(res);
    return res.statusCode == 200;
  }

  // -----------------------------------------------------------
  // @ Offer
  // -----------------------------------------------------------

  Future<OfferPaginationResponse> findAllOffers(PaginationOptions pagination) async {
    // don't fetch applications
    pagination.privateData = false;
    var res = await _dio.get(
      "$apiUrl/offers/pagination",
      queryParameters: pagination.toJson(),
    );

    return OfferPaginationResponse.fromJson(res.data);
  }

  Future<List<Application>?> findAllApplications(PaginationOptions? pagination) async {
    // fetch applications
    if (pagination != null) {
      pagination.privateData = true;
    } else {
      pagination = PaginationOptions(page: 0, size: 1000, privateData: true);
    }
    var res = await _dio.get(
      "$apiUrl/offers/pagination",
      queryParameters: pagination.toJson(),
    );

    var response = ApplicationPaginationResponse.fromJson(res.data);

    return response.results;
  }

  // -----------------------------------------------------------
  // @ Other
  // -----------------------------------------------------------

  // @ Province
  Future<List<Province>> findAllProvinces() async {
    var res = await _dio.get("$apiUrl/users/provinces");
    return Future.value(List<Province>.from(res.data.map((p) => Province.fromJson(p))));
  }

  // @ Language
  Future<List<Language>> findAllLanguages() async {
    var res = await _dio.get("$apiUrl/users/languages");
    return Future.value(List<Language>.from(res.data.map((p) => Language.fromJson(p))));
  }

  // @ Degree
  Future<List<Degree>> findAllDegrees() async {
    var res = await _dio.get("$apiUrl/students/degrees");
    return Future.value(List<Degree>.from(res.data.map((p) => Degree.fromJson(p))));
  }

  // @ Family
  Future<List<Family>> findAllFamilies() async {
    var res = await _dio.get("$apiUrl/students/families");
    return Future.value(List<Family>.from(res.data.map((p) => Family.fromJson(p))));
  }

  // @ Level
  Future<List<Level>> findAllLevels() async {
    var res = await _dio.get("$apiUrl/students/levels");
    return Future.value(List<Level>.from(res.data.map((p) => Level.fromJson(p))));
  }

  // @ Company
  Future<List<Company>> findAllCompanies() async {
    var res = await _dio.get("$apiUrl/companies");
    return Future.value(List<Company>.from(res.data.map((p) => Company.fromJson(p))));
  }

  // @ Application
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
