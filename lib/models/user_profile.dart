import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String? email;
  final DateTime birthDate;
  final String birthTime; // HH:mm format
  final double birthLatitude;
  final double birthLongitude;
  final String birthPlace;
  final String timezone;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    required this.birthDate,
    required this.birthTime,
    required this.birthLatitude,
    required this.birthLongitude,
    required this.birthPlace,
    required this.timezone,
    required this.createdAt,
    this.lastUpdated,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? birthDate,
    String? birthTime,
    double? birthLatitude,
    double? birthLongitude,
    String? birthPlace,
    String? timezone,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthLatitude: birthLatitude ?? this.birthLatitude,
      birthLongitude: birthLongitude ?? this.birthLongitude,
      birthPlace: birthPlace ?? this.birthPlace,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        birthDate,
        birthTime,
        birthLatitude,
        birthLongitude,
        birthPlace,
        timezone,
        createdAt,
        lastUpdated,
      ];
}
