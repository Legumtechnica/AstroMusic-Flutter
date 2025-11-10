// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      birthDate: DateTime.parse(json['birthDate'] as String),
      birthTime: json['birthTime'] as String,
      birthLatitude: (json['birthLatitude'] as num).toDouble(),
      birthLongitude: (json['birthLongitude'] as num).toDouble(),
      birthPlace: json['birthPlace'] as String,
      timezone: json['timezone'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'birthDate': instance.birthDate.toIso8601String(),
      'birthTime': instance.birthTime,
      'birthLatitude': instance.birthLatitude,
      'birthLongitude': instance.birthLongitude,
      'birthPlace': instance.birthPlace,
      'timezone': instance.timezone,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
