import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../models/music_track.dart';
import '../../models/raag.dart';
import '../../models/birth_chart.dart';

/// Service for AI-generated Indian classical music
/// This can be connected to various AI music generation backends
class MusicGenerationService {
  final Dio _dio;
  final String _apiBaseUrl;
  final Uuid _uuid = const Uuid();

  MusicGenerationService({
    required String apiBaseUrl,
    Dio? dio,
  })  : _apiBaseUrl = apiBaseUrl,
        _dio = dio ?? Dio();

  /// Generate a personalized track based on raag and user's chart
  Future<MusicTrack> generatePersonalizedTrack({
    required Raag raag,
    required BirthChart birthChart,
    required TrackType type,
    int durationMinutes = 5,
  }) async {
    try {
      // Create generation request
      final trackId = _uuid.v4();

      final requestData = {
        'raag_id': raag.id,
        'raag_name': raag.name,
        'notes': raag.notes,
        'thaat': raag.thaat,
        'moods': raag.moods.map((m) => m.toString()).toList(),
        'duration_seconds': durationMinutes * 60,
        'tempo': _getTempoForMood(raag.moods.first),
        'birth_chart': {
          'sun_sign': birthChart.sunSign,
          'moon_sign': birthChart.moonSign,
          'ascendant': birthChart.ascendant.toString(),
        },
        'track_type': type.toString(),
      };

      // For now, return a mock track (replace with actual API call)
      // In production, this would call your AI music generation API

      // Uncomment when API is ready:
      // final response = await _dio.post(
      //   '$_apiBaseUrl/generate',
      //   data: requestData,
      // );

      // Mock response for development
      return MusicTrack(
        id: trackId,
        title: _generateTrackTitle(raag, birthChart),
        subtitle: 'Personalized ${raag.name} composition',
        raagId: raag.id,
        raagName: raag.name,
        type: type,
        durationSeconds: durationMinutes * 60,
        audioUrl: 'https://example.com/audio/$trackId.mp3', // Placeholder
        coverImageUrl: raag.imageUrl,
        createdAt: DateTime.now(),
        userId: birthChart.userId,
        generationStatus: GenerationStatus.pending,
        instruments: _getInstrumentsForRaag(raag),
        tempo: _getTempoForMood(raag.moods.first),
        description: _generateTrackDescription(raag, birthChart),
        tags: [raag.name, raag.thaat, ...raag.moods.map((m) => m.toString())],
        isPremium: false,
      );
    } catch (e) {
      print('Error generating track: $e');
      rethrow;
    }
  }

  /// Generate a standard raag track (not personalized)
  Future<MusicTrack> generateStandardTrack({
    required Raag raag,
    required TrackType type,
    int durationMinutes = 5,
  }) async {
    try {
      final trackId = _uuid.v4();

      return MusicTrack(
        id: trackId,
        title: 'Raag ${raag.name}',
        subtitle: raag.description,
        raagId: raag.id,
        raagName: raag.name,
        type: type,
        durationSeconds: durationMinutes * 60,
        audioUrl: 'https://example.com/audio/$trackId.mp3',
        coverImageUrl: raag.imageUrl,
        createdAt: DateTime.now(),
        generationStatus: GenerationStatus.pending,
        instruments: _getInstrumentsForRaag(raag),
        tempo: _getTempoForMood(raag.moods.first),
        description: raag.description,
        tags: [raag.name, raag.thaat],
        isPremium: false,
      );
    } catch (e) {
      print('Error generating standard track: $e');
      rethrow;
    }
  }

  /// Check generation status
  Future<GenerationStatus> checkGenerationStatus(String trackId) async {
    try {
      // In production, check with your API
      // final response = await _dio.get('$_apiBaseUrl/status/$trackId');
      // return GenerationStatus.values.firstWhere(
      //   (s) => s.toString() == response.data['status'],
      // );

      // Mock: return completed after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      return GenerationStatus.completed;
    } catch (e) {
      print('Error checking generation status: $e');
      return GenerationStatus.failed;
    }
  }

  /// Generate meditation mix (layered ambient + raag)
  Future<MusicTrack> generateMeditationMix({
    required Raag raag,
    required BirthChart birthChart,
    int durationMinutes = 10,
    bool includeAmbience = true,
    bool includeBinaural = false,
  }) async {
    final trackId = _uuid.v4();

    return MusicTrack(
      id: trackId,
      title: 'Meditation: ${raag.name}',
      subtitle: 'Cosmic meditation aligned with your chart',
      raagId: raag.id,
      raagName: raag.name,
      type: TrackType.meditation,
      durationSeconds: durationMinutes * 60,
      audioUrl: 'https://example.com/audio/$trackId.mp3',
      coverImageUrl: raag.imageUrl,
      createdAt: DateTime.now(),
      userId: birthChart.userId,
      generationStatus: GenerationStatus.pending,
      instruments: [
        ...(_getInstrumentsForRaag(raag)),
        if (includeAmbience) 'Ambient Pads',
        if (includeBinaural) 'Binaural Beats',
      ],
      tempo: 60, // Slow tempo for meditation
      description: 'Deep meditation track blending ${raag.name} with cosmic frequencies',
      tags: ['meditation', raag.name, 'cosmic', 'healing'],
      isPremium: true,
    );
  }

  /// Generate sleep track (very slow, ambient heavy)
  Future<MusicTrack> generateSleepTrack({
    required Raag raag,
    required BirthChart birthChart,
    int durationMinutes = 30,
  }) async {
    final trackId = _uuid.v4();

    return MusicTrack(
      id: trackId,
      title: 'Sleep Therapy: ${raag.name}',
      subtitle: 'Cosmic lullaby for deep rest',
      raagId: raag.id,
      raagName: raag.name,
      type: TrackType.sleep,
      durationSeconds: durationMinutes * 60,
      audioUrl: 'https://example.com/audio/$trackId.mp3',
      coverImageUrl: raag.imageUrl,
      createdAt: DateTime.now(),
      userId: birthChart.userId,
      generationStatus: GenerationStatus.pending,
      instruments: ['Ambient Synth', 'Tanpura', 'Soft Flute'],
      tempo: 40, // Very slow for sleep
      description: 'Gentle sleep-inducing composition based on ${raag.name}',
      tags: ['sleep', raag.name, 'relaxation', 'healing'],
      isPremium: true,
    );
  }

  // Private helper methods

  String _generateTrackTitle(Raag raag, BirthChart birthChart) {
    final signs = [birthChart.sunSign, birthChart.moonSign];
    return '${raag.name} for ${signs.join(' & ')}';
  }

  String _generateTrackDescription(Raag raag, BirthChart birthChart) {
    return 'A personalized ${raag.name} composition aligned with your birth chart. '
        'This track resonates with your ${birthChart.moonSign} moon sign, '
        'bringing ${raag.benefits.join(", ").toLowerCase()}.';
  }

  List<String> _getInstrumentsForRaag(Raag raag) {
    // Traditional instruments for different moods
    if (raag.moods.contains(RaagMood.devotional)) {
      return ['Sitar', 'Tanpura', 'Tabla', 'Harmonium'];
    } else if (raag.moods.contains(RaagMood.powerful)) {
      return ['Shehnai', 'Dhol', 'Tanpura'];
    } else if (raag.moods.contains(RaagMood.romantic)) {
      return ['Bansuri', 'Sitar', 'Tanpura', 'Tabla'];
    } else if (raag.moods.contains(RaagMood.calm)) {
      return ['Bansuri', 'Santoor', 'Tanpura'];
    } else {
      return ['Sitar', 'Tabla', 'Tanpura'];
    }
  }

  int _getTempoForMood(RaagMood mood) {
    switch (mood) {
      case RaagMood.calm:
      case RaagMood.contemplative:
        return 60;
      case RaagMood.devotional:
        return 80;
      case RaagMood.romantic:
        return 90;
      case RaagMood.joyful:
        return 110;
      case RaagMood.energetic:
      case RaagMood.powerful:
        return 130;
      case RaagMood.melancholic:
        return 70;
    }
  }
}
