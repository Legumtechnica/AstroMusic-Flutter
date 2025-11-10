import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'raag.dart';

part 'music_track.g.dart';

enum TrackType {
  raagTherapy,
  meditation,
  sleep,
  focus,
  yoga,
}

enum GenerationStatus {
  pending,
  generating,
  completed,
  failed,
}

@JsonSerializable()
class MusicTrack extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String raagId;
  final String raagName;
  final TrackType type;
  final int durationSeconds;
  final String audioUrl;
  final String? coverImageUrl;
  final DateTime createdAt;
  final String? userId; // If personalized
  final GenerationStatus generationStatus;
  final List<String> instruments;
  final int tempo; // BPM
  final String? description;
  final List<String> tags;
  final bool isPremium;
  final int playCount;
  final double? userRating;

  const MusicTrack({
    required this.id,
    required this.title,
    this.subtitle,
    required this.raagId,
    required this.raagName,
    required this.type,
    required this.durationSeconds,
    required this.audioUrl,
    this.coverImageUrl,
    required this.createdAt,
    this.userId,
    this.generationStatus = GenerationStatus.completed,
    this.instruments = const [],
    this.tempo = 120,
    this.description,
    this.tags = const [],
    this.isPremium = false,
    this.playCount = 0,
    this.userRating,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) =>
      _$MusicTrackFromJson(json);

  Map<String, dynamic> toJson() => _$MusicTrackToJson(this);

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  MusicTrack copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? raagId,
    String? raagName,
    TrackType? type,
    int? durationSeconds,
    String? audioUrl,
    String? coverImageUrl,
    DateTime? createdAt,
    String? userId,
    GenerationStatus? generationStatus,
    List<String>? instruments,
    int? tempo,
    String? description,
    List<String>? tags,
    bool? isPremium,
    int? playCount,
    double? userRating,
  }) {
    return MusicTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      raagId: raagId ?? this.raagId,
      raagName: raagName ?? this.raagName,
      type: type ?? this.type,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      audioUrl: audioUrl ?? this.audioUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      generationStatus: generationStatus ?? this.generationStatus,
      instruments: instruments ?? this.instruments,
      tempo: tempo ?? this.tempo,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isPremium: isPremium ?? this.isPremium,
      playCount: playCount ?? this.playCount,
      userRating: userRating ?? this.userRating,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        raagId,
        raagName,
        type,
        durationSeconds,
        audioUrl,
        coverImageUrl,
        createdAt,
        userId,
        generationStatus,
        instruments,
        tempo,
        description,
        tags,
        isPremium,
        playCount,
        userRating,
      ];
}
