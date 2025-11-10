// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicTrack _$MusicTrackFromJson(Map<String, dynamic> json) => MusicTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      raagId: json['raagId'] as String,
      raagName: json['raagName'] as String,
      type: $enumDecode(_$TrackTypeEnumMap, json['type']),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      audioUrl: json['audioUrl'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String?,
      generationStatus: $enumDecodeNullable(
              _$GenerationStatusEnumMap, json['generationStatus']) ??
          GenerationStatus.completed,
      instruments: (json['instruments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tempo: (json['tempo'] as num?)?.toInt() ?? 120,
      description: json['description'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isPremium: json['isPremium'] as bool? ?? false,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      userRating: (json['userRating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MusicTrackToJson(MusicTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'raagId': instance.raagId,
      'raagName': instance.raagName,
      'type': _$TrackTypeEnumMap[instance.type]!,
      'durationSeconds': instance.durationSeconds,
      'audioUrl': instance.audioUrl,
      'coverImageUrl': instance.coverImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'generationStatus': _$GenerationStatusEnumMap[instance.generationStatus]!,
      'instruments': instance.instruments,
      'tempo': instance.tempo,
      'description': instance.description,
      'tags': instance.tags,
      'isPremium': instance.isPremium,
      'playCount': instance.playCount,
      'userRating': instance.userRating,
    };

const _$TrackTypeEnumMap = {
  TrackType.raagTherapy: 'raagTherapy',
  TrackType.meditation: 'meditation',
  TrackType.sleep: 'sleep',
  TrackType.focus: 'focus',
  TrackType.yoga: 'yoga',
};

const _$GenerationStatusEnumMap = {
  GenerationStatus.pending: 'pending',
  GenerationStatus.generating: 'generating',
  GenerationStatus.completed: 'completed',
  GenerationStatus.failed: 'failed',
};
