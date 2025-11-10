// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$PlaylistTypeEnumMap, json['type']),
      userId: json['userId'] as String?,
      trackIds:
          (json['trackIds'] as List<dynamic>).map((e) => e as String).toList(),
      coverImageUrl: json['coverImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      astrologicalContext: json['astrologicalContext'] as Map<String, dynamic>?,
      isPersonalized: json['isPersonalized'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$PlaylistTypeEnumMap[instance.type]!,
      'userId': instance.userId,
      'trackIds': instance.trackIds,
      'coverImageUrl': instance.coverImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'astrologicalContext': instance.astrologicalContext,
      'isPersonalized': instance.isPersonalized,
      'tags': instance.tags,
    };

const _$PlaylistTypeEnumMap = {
  PlaylistType.daily: 'daily',
  PlaylistType.weekly: 'weekly',
  PlaylistType.planetBased: 'planetBased',
  PlaylistType.moodBased: 'moodBased',
  PlaylistType.custom: 'custom',
  PlaylistType.transit: 'transit',
};
