import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'music_track.dart';

part 'playlist.g.dart';

enum PlaylistType {
  daily,
  weekly,
  planetBased,
  moodBased,
  custom,
  transit,
}

@JsonSerializable()
class Playlist extends Equatable {
  final String id;
  final String title;
  final String description;
  final PlaylistType type;
  final String? userId;
  final List<String> trackIds;
  final String? coverImageUrl;
  final DateTime createdAt;
  final DateTime? expiresAt; // For daily/weekly playlists
  final Map<String, dynamic>? astrologicalContext; // Planet positions, transits, etc.
  final bool isPersonalized;
  final List<String> tags;

  const Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.userId,
    required this.trackIds,
    this.coverImageUrl,
    required this.createdAt,
    this.expiresAt,
    this.astrologicalContext,
    this.isPersonalized = false,
    this.tags = const [],
  });

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  int get trackCount => trackIds.length;

  Playlist copyWith({
    String? id,
    String? title,
    String? description,
    PlaylistType? type,
    String? userId,
    List<String>? trackIds,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? expiresAt,
    Map<String, dynamic>? astrologicalContext,
    bool? isPersonalized,
    List<String>? tags,
  }) {
    return Playlist(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      trackIds: trackIds ?? this.trackIds,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      astrologicalContext: astrologicalContext ?? this.astrologicalContext,
      isPersonalized: isPersonalized ?? this.isPersonalized,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        userId,
        trackIds,
        coverImageUrl,
        createdAt,
        expiresAt,
        astrologicalContext,
        isPersonalized,
        tags,
      ];
}
