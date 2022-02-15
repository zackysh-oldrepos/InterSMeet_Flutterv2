// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      userId: fields[0] as int,
      username: fields[1] as String,
      email: fields[2] as String,
      firstName: fields[3] as String,
      lastName: fields[4] as String,
      provinceId: fields[5] as int,
      location: fields[6] as String,
      languageId: fields[7] as int,
      emailVerified: fields[12] as bool,
      degreeId: fields[8] as int,
      birthDate: fields[10] as String,
      averageGrades: fields[11] as int,
    )..avatar = (fields[9] as List?)?.cast<int>();
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.provinceId)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.languageId)
      ..writeByte(12)
      ..write(obj.emailVerified)
      ..writeByte(8)
      ..write(obj.degreeId)
      ..writeByte(11)
      ..write(obj.averageGrades)
      ..writeByte(10)
      ..write(obj.birthDate)
      ..writeByte(9)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      provinceId: json['provinceId'] as int,
      location: json['location'] as String,
      languageId: json['languageId'] as int,
      emailVerified: json['emailVerified'] as bool,
      degreeId: json['degreeId'] as int,
      birthDate: json['birthDate'] as String,
      averageGrades: json['averageGrades'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'provinceId': instance.provinceId,
      'location': instance.location,
      'languageId': instance.languageId,
      'emailVerified': instance.emailVerified,
      'degreeId': instance.degreeId,
      'averageGrades': instance.averageGrades,
      'birthDate': instance.birthDate,
    };
