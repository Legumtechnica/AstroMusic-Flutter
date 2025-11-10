// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birth_chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BirthChart _$BirthChartFromJson(Map<String, dynamic> json) => BirthChart(
      userId: json['userId'] as String,
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      planets: (json['planets'] as List<dynamic>)
          .map((e) => Planet.fromJson(e as Map<String, dynamic>))
          .toList(),
      ascendant: $enumDecode(_$ZodiacSignEnumMap, json['ascendant']),
      ascendantDegree: (json['ascendantDegree'] as num).toDouble(),
      housePositions: (json['housePositions'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      moonSign: json['moonSign'] as String,
      sunSign: json['sunSign'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BirthChartToJson(BirthChart instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'planets': instance.planets,
      'ascendant': _$ZodiacSignEnumMap[instance.ascendant]!,
      'ascendantDegree': instance.ascendantDegree,
      'housePositions': instance.housePositions,
      'moonSign': instance.moonSign,
      'sunSign': instance.sunSign,
      'description': instance.description,
    };

const _$ZodiacSignEnumMap = {
  ZodiacSign.aries: 'aries',
  ZodiacSign.taurus: 'taurus',
  ZodiacSign.gemini: 'gemini',
  ZodiacSign.cancer: 'cancer',
  ZodiacSign.leo: 'leo',
  ZodiacSign.virgo: 'virgo',
  ZodiacSign.libra: 'libra',
  ZodiacSign.scorpio: 'scorpio',
  ZodiacSign.sagittarius: 'sagittarius',
  ZodiacSign.capricorn: 'capricorn',
  ZodiacSign.aquarius: 'aquarius',
  ZodiacSign.pisces: 'pisces',
};
