import '../provider/base_model.dart';
import '../provider/getit.dart';
import '../models/user_profile.dart';
import '../models/birth_chart.dart';
import '../models/cosmic_influence.dart';
import '../models/raag.dart';
import '../models/music_track.dart';
import '../models/playlist.dart';
import '../services/storage_service.dart';
import '../services/astrology/astrology_service.dart';
import '../services/astrology/raag_mapping_service.dart';
import '../services/music/music_generation_service.dart';
import '../enum/view_state.dart';
import 'package:uuid/uuid.dart';

class CosmicDashboardViewModel extends BaseModel {
  final _storageService = getIt<StorageService>();
  final _astrologyService = getIt<AstrologyService>();
  final _raagMappingService = getIt<RaagMappingService>();
  final _musicService = getIt<MusicGenerationService>();
  final _uuid = const Uuid();

  UserProfile? _currentUser;
  BirthChart? _birthChart;
  CosmicInfluence? _todaysInfluence;
  Playlist? _dailyPlaylist;
  List<Raag> _recommendedRaags = [];
  List<MusicTrack> _personalizedTracks = [];

  UserProfile? get currentUser => _currentUser;
  BirthChart? get birthChart => _birthChart;
  CosmicInfluence? get todaysInfluence => _todaysInfluence;
  Playlist? get dailyPlaylist => _dailyPlaylist;
  List<Raag> get recommendedRaags => _recommendedRaags;
  List<MusicTrack> get personalizedTracks => _personalizedTracks;

  String? errorMessage;

  Future<void> loadDashboard() async {
    setState(ViewState.Busy);
    errorMessage = null;

    try {
      // Load current user
      _currentUser = await _storageService.getCurrentUser();
      if (_currentUser == null) {
        errorMessage = 'No user found';
        setState(ViewState.Idle);
        return;
      }

      // Load birth chart
      _birthChart = await _storageService.getBirthChart(_currentUser!.id);
      if (_birthChart == null) {
        // Calculate if not exists
        _birthChart = await _astrologyService.calculateBirthChart(_currentUser!);
        await _storageService.saveBirthChart(_birthChart!);
      }

      // Calculate today's cosmic influence
      _todaysInfluence = await _astrologyService.calculateCosmicInfluence(
        _currentUser!,
        _birthChart!,
      );

      // Get recommended raags based on today's influence
      _recommendedRaags = _getRecommendedRaagsForToday();

      // Load or generate daily playlist
      await _loadDailyPlaylist();

      // Load personalized tracks
      _personalizedTracks = await _storageService.getUserTracks(_currentUser!.id);

      setState(ViewState.Idle);
    } catch (e) {
      errorMessage = 'Failed to load dashboard: ${e.toString()}';
      setState(ViewState.Idle);
      print('Error loading dashboard: $e');
    }
  }

  List<Raag> _getRecommendedRaagsForToday() {
    if (_todaysInfluence == null) return [];

    final raags = <Raag>[];

    // Get raags for dominant moods
    for (final mood in _todaysInfluence!.dominantMoods) {
      raags.addAll(_raagMappingService.getRaagsForMood(mood));
    }

    // Get raag for lucky raag if specified
    // In real implementation, this would fetch the actual Raag object

    // Remove duplicates
    return raags.toSet().toList();
  }

  Future<void> _loadDailyPlaylist() async {
    if (_currentUser == null || _birthChart == null) return;

    try {
      // Check if we have a playlist for today
      final playlists = await _storageService.getUserPlaylists(_currentUser!.id);
      final today = DateTime.now();

      _dailyPlaylist = playlists.firstWhere(
        (p) =>
            p.type == PlaylistType.daily &&
            p.createdAt.year == today.year &&
            p.createdAt.month == today.month &&
            p.createdAt.day == today.day &&
            !p.isExpired,
        orElse: () => _createEmptyPlaylist(),
      );

      // Generate new playlist if needed
      if (_dailyPlaylist!.trackIds.isEmpty) {
        await _generateDailyPlaylist();
      }
    } catch (e) {
      print('Error loading daily playlist: $e');
    }
  }

  Playlist _createEmptyPlaylist() {
    return Playlist(
      id: _uuid.v4(),
      title: 'Today\'s Cosmic Playlist',
      description: 'Personalized music for your cosmic energy today',
      type: PlaylistType.daily,
      userId: _currentUser!.id,
      trackIds: [],
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(hours: 24)),
      isPersonalized: true,
    );
  }

  Future<void> _generateDailyPlaylist() async {
    if (_currentUser == null || _birthChart == null || _recommendedRaags.isEmpty) {
      return;
    }

    try {
      final trackIds = <String>[];

      // Generate 3-5 tracks based on recommended raags
      final raagsToUse = _recommendedRaags.take(3).toList();

      for (final raag in raagsToUse) {
        final track = await _musicService.generatePersonalizedTrack(
          raag: raag,
          birthChart: _birthChart!,
          type: TrackType.raagTherapy,
          durationMinutes: 5,
        );

        await _storageService.saveTrack(track);
        trackIds.add(track.id);
      }

      // Update playlist
      _dailyPlaylist = _dailyPlaylist!.copyWith(
        trackIds: trackIds,
        astrologicalContext: {
          'energy_level': _todaysInfluence?.energyLevel.toString(),
          'moods': _todaysInfluence?.dominantMoods.map((m) => m.toString()).toList(),
          'overall_score': _todaysInfluence?.overallScore,
        },
      );

      await _storageService.savePlaylist(_dailyPlaylist!);
      notifyListeners();
    } catch (e) {
      print('Error generating daily playlist: $e');
    }
  }

  Future<void> regeneratePlaylist() async {
    setState(ViewState.Busy);

    try {
      _dailyPlaylist = _createEmptyPlaylist();
      await _generateDailyPlaylist();
      setState(ViewState.Idle);
    } catch (e) {
      errorMessage = 'Failed to regenerate playlist';
      setState(ViewState.Idle);
    }
  }

  Future<void> generateMeditationTrack() async {
    if (_currentUser == null || _birthChart == null || _recommendedRaags.isEmpty) {
      return;
    }

    setState(ViewState.Busy);

    try {
      final raag = _recommendedRaags.first;
      final track = await _musicService.generateMeditationMix(
        raag: raag,
        birthChart: _birthChart!,
        durationMinutes: 10,
        includeAmbience: true,
        includeBinaural: true,
      );

      await _storageService.saveTrack(track);
      _personalizedTracks.insert(0, track);

      setState(ViewState.Idle);
    } catch (e) {
      errorMessage = 'Failed to generate meditation track';
      setState(ViewState.Idle);
    }
  }

  Future<void> generateSleepTrack() async {
    if (_currentUser == null || _birthChart == null || _recommendedRaags.isEmpty) {
      return;
    }

    setState(ViewState.Busy);

    try {
      final raag = _recommendedRaags.first;
      final track = await _musicService.generateSleepTrack(
        raag: raag,
        birthChart: _birthChart!,
        durationMinutes: 30,
      );

      await _storageService.saveTrack(track);
      _personalizedTracks.insert(0, track);

      setState(ViewState.Idle);
    } catch (e) {
      errorMessage = 'Failed to generate sleep track';
      setState(ViewState.Idle);
    }
  }

  String getEnergyLevelText() {
    if (_todaysInfluence == null) return 'Unknown';

    switch (_todaysInfluence!.energyLevel) {
      case EnergyLevel.veryLow:
        return 'Very Low - Rest & Recharge';
      case EnergyLevel.low:
        return 'Low - Take it Easy';
      case EnergyLevel.moderate:
        return 'Moderate - Balanced';
      case EnergyLevel.high:
        return 'High - Active & Productive';
      case EnergyLevel.veryHigh:
        return 'Very High - Peak Performance';
    }
  }

  String getEnergyLevelEmoji() {
    if (_todaysInfluence == null) return '🌟';

    switch (_todaysInfluence!.energyLevel) {
      case EnergyLevel.veryLow:
        return '🌙';
      case EnergyLevel.low:
        return '☁️';
      case EnergyLevel.moderate:
        return '⭐';
      case EnergyLevel.high:
        return '☀️';
      case EnergyLevel.veryHigh:
        return '🔥';
    }
  }
}
