// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUser _$UpdateUserFromJson(Map<String, dynamic> json) => UpdateUser(
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      provinceId: json['provinceId'] as int,
      location: json['location'] as String,
      languageId: json['languageId'] as int,
    );

Map<String, dynamic> _$UpdateUserToJson(UpdateUser instance) => <String, dynamic>{
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'provinceId': instance.provinceId,
      'location': instance.location,
      'languageId': instance.languageId,
    };
