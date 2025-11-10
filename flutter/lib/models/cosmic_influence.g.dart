// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cosmic_influence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CosmicInfluence _$CosmicInfluenceFromJson(Map<String, dynamic> json) =>
    CosmicInfluence(
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      energyLevel: $enumDecode(_$EnergyLevelEnumMap, json['energyLevel']),
      dominantMoods: (json['dominantMoods'] as List<dynamic>)
          .map((e) => $enumDecode(_$MoodTypeEnumMap, e))
          .toList(),
      overallDescription: json['overallDescription'] as String,
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      activeTransits: (json['activeTransits'] as List<dynamic>)
          .map((e) => PlanetaryTransit.fromJson(e as Map<String, dynamic>))
          .toList(),
      luckyRaag: json['luckyRaag'] as String?,
      challengingAspect: json['challengingAspect'] as String?,
      overallScore: (json['overallScore'] as num).toDouble(),
      chakraBalances: (json['chakraBalances'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$CosmicInfluenceToJson(CosmicInfluence instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'energyLevel': _$EnergyLevelEnumMap[instance.energyLevel]!,
      'dominantMoods':
          instance.dominantMoods.map((e) => _$MoodTypeEnumMap[e]!).toList(),
      'overallDescription': instance.overallDescription,
      'recommendations': instance.recommendations,
      'activeTransits': instance.activeTransits,
      'luckyRaag': instance.luckyRaag,
      'challengingAspect': instance.challengingAspect,
      'overallScore': instance.overallScore,
      'chakraBalances': instance.chakraBalances,
    };

const _$EnergyLevelEnumMap = {
  EnergyLevel.veryLow: 'veryLow',
  EnergyLevel.low: 'low',
  EnergyLevel.moderate: 'moderate',
  EnergyLevel.high: 'high',
  EnergyLevel.veryHigh: 'veryHigh',
};

const _$MoodTypeEnumMap = {
  MoodType.calm: 'calm',
  MoodType.anxious: 'anxious',
  MoodType.energetic: 'energetic',
  MoodType.creative: 'creative',
  MoodType.focused: 'focused',
  MoodType.romantic: 'romantic',
  MoodType.spiritual: 'spiritual',
  MoodType.restless: 'restless',
};

PlanetaryTransit _$PlanetaryTransitFromJson(Map<String, dynamic> json) =>
    PlanetaryTransit(
      planet: $enumDecode(_$PlanetTypeEnumMap, json['planet']),
      currentSign: $enumDecode(_$ZodiacSignEnumMap, json['currentSign']),
      movingToSign:
          $enumDecodeNullable(_$ZodiacSignEnumMap, json['movingToSign']),
      description: json['description'] as String,
      influence: json['influence'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      intensity: (json['intensity'] as num).toDouble(),
    );

Map<String, dynamic> _$PlanetaryTransitToJson(PlanetaryTransit instance) =>
    <String, dynamic>{
      'planet': _$PlanetTypeEnumMap[instance.planet]!,
      'currentSign': _$ZodiacSignEnumMap[instance.currentSign]!,
      'movingToSign': _$ZodiacSignEnumMap[instance.movingToSign],
      'description': instance.description,
      'influence': instance.influence,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'intensity': instance.intensity,
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
