// import 'package:http/http.dart' as http;
import 'package:intersmeet/core/models/language.dart';
import 'package:intersmeet/core/models/province.dart';

class UserService {
  Future<List<Province>> findAllProvinces() async {
    // var res = await http.post(Uri.parse("$apiUrl/users/provinces"));
    return [
      Province(1, "province 1"),
      Province(2, "province 2"),
      Province(3, "province 3"),
      Province(4, "province 4")
    ];
  }

  Future<List<Language>> findAllLanguages() async {
    // var res = await http.post(Uri.parse("$apiUrl/users/languages"));
    return [
      Language(1, "province 1"),
      Language(2, "province 2"),
      Language(3, "province 3"),
      Language(4, "province 4")
    ];
  }
}
