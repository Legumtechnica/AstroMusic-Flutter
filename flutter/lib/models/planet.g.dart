// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Planet _$PlanetFromJson(Map<String, dynamic> json) => Planet(
      type: $enumDecode(_$PlanetTypeEnumMap, json['type']),
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      sign: $enumDecode(_$ZodiacSignEnumMap, json['sign']),
      house: (json['house'] as num).toInt(),
      isRetrograde: json['isRetrograde'] as bool? ?? false,
      nakshatra: json['nakshatra'] as String?,
      nakshatraPada: (json['nakshatraPada'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlanetToJson(Planet instance) => <String, dynamic>{
      'type': _$PlanetTypeEnumMap[instance.type]!,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'sign': _$ZodiacSignEnumMap[instance.sign]!,
      'house': instance.house,
      'isRetrograde': instance.isRetrograde,
      'nakshatra': instance.nakshatra,
      'nakshatraPada': instance.nakshatraPada,
    };

const _$PlanetTypeEnumMap = {
  PlanetType.sun: 'sun',
  PlanetType.moon: 'moon',
  PlanetType.mercury: 'mercury',
  PlanetType.venus: 'venus',
  PlanetType.mars: 'mars',
  PlanetType.jupiter: 'jupiter',
  PlanetType.saturn: 'saturn',
  PlanetType.rahu: 'rahu',
  PlanetType.ketu: 'ketu',
  PlanetType.uranus: 'uranus',
  PlanetType.neptune: 'neptune',
  PlanetType.pluto: 'pluto',
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
