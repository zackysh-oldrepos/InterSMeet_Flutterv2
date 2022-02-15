// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_sign_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSignUp _$UserSignUpFromJson(Map<String, dynamic> json) => UserSignUp(
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      provinceId: json['provinceId'] as int,
      location: json['location'] as String,
      password: json['password'] as String,
      languageId: json['languageId'] as int,
    );

Map<String, dynamic> _$UserSignUpToJson(UserSignUp instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'provinceId': instance.provinceId,
      'location': instance.location,
      'password': instance.password,
      'languageId': instance.languageId,
    };
