// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Raag _$RaagFromJson(Map<String, dynamic> json) => Raag(
      id: json['id'] as String,
      name: json['name'] as String,
      nameHindi: json['nameHindi'] as String,
      description: json['description'] as String,
      moods: (json['moods'] as List<dynamic>)
          .map((e) => $enumDecode(_$RaagMoodEnumMap, e))
          .toList(),
      notes: (json['notes'] as List<dynamic>).map((e) => e as String).toList(),
      thaat: json['thaat'] as String,
      preferredTime:
          $enumDecodeNullable(_$TimeOfDayEnumMap, json['preferredTime']),
      associatedPlanets: (json['associatedPlanets'] as List<dynamic>)
          .map((e) => $enumDecode(_$PlanetTypeEnumMap, e))
          .toList(),
      associatedSigns: (json['associatedSigns'] as List<dynamic>)
          .map((e) => $enumDecode(_$ZodiacSignEnumMap, e))
          .toList(),
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$RaagToJson(Raag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameHindi': instance.nameHindi,
      'description': instance.description,
      'moods': instance.moods.map((e) => _$RaagMoodEnumMap[e]!).toList(),
      'notes': instance.notes,
      'thaat': instance.thaat,
      'preferredTime': _$TimeOfDayEnumMap[instance.preferredTime],
      'associatedPlanets': instance.associatedPlanets
          .map((e) => _$PlanetTypeEnumMap[e]!)
          .toList(),
      'associatedSigns':
          instance.associatedSigns.map((e) => _$ZodiacSignEnumMap[e]!).toList(),
      'benefits': instance.benefits,
      'imageUrl': instance.imageUrl,
    };

const _$RaagMoodEnumMap = {
  RaagMood.calm: 'calm',
  RaagMood.energetic: 'energetic',
  RaagMood.devotional: 'devotional',
  RaagMood.romantic: 'romantic',
  RaagMood.contemplative: 'contemplative',
  RaagMood.joyful: 'joyful',
  RaagMood.melancholic: 'melancholic',
  RaagMood.powerful: 'powerful',
};

const _$TimeOfDayEnumMap = {
  TimeOfDay.earlyMorning: 'earlyMorning',
  TimeOfDay.morning: 'morning',
  TimeOfDay.lateMorning: 'lateMorning',
  TimeOfDay.afternoon: 'afternoon',
  TimeOfDay.evening: 'evening',
  TimeOfDay.night: 'night',
  TimeOfDay.lateNight: 'lateNight',
  TimeOfDay.midnight: 'midnight',
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
