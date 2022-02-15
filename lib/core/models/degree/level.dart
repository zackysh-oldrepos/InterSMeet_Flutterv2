import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonSerializable()
class Level {
  final int levelId;
  final String name;

  Level({required this.levelId, required this.name});
  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
}
