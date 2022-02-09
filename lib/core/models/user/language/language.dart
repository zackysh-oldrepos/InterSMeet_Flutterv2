import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  final int languageId;
  final String name;

  Language(this.languageId, this.name);

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
}
