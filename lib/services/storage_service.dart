import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';
import '../models/birth_chart.dart';
import '../models/music_track.dart';
import '../models/playlist.dart';

class StorageService {
  static const String _userBoxName = 'user_data';
  static const String _chartBoxName = 'birth_charts';
  static const String _tracksBoxName = 'music_tracks';
  static const String _playlistsBoxName = 'playlists';
  static const String _prefsKeyCurrentUserId = 'current_user_id';
  static const String _prefsKeyOnboardingComplete = 'onboarding_complete';

  late Box<String> _userBox;
  late Box<String> _chartBox;
  late Box<String> _tracksBox;
  late Box<String> _playlistsBox;
  late SharedPreferences _prefs;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();

      _userBox = await Hive.openBox<String>(_userBoxName);
      _chartBox = await Hive.openBox<String>(_chartBoxName);
      _tracksBox = await Hive.openBox<String>(_tracksBoxName);
      _playlistsBox = await Hive.openBox<String>(_playlistsBoxName);

      _prefs = await SharedPreferences.getInstance();

      _isInitialized = true;
    } catch (e) {
      print('Error initializing storage: $e');
      rethrow;
    }
  }

  // User Profile Methods

  Future<void> saveUserProfile(UserProfile user) async {
    await _ensureInitialized();
    final json = jsonEncode(user.toJson());
    await _userBox.put(user.id, json);
    await _prefs.setString(_prefsKeyCurrentUserId, user.id);
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    await _ensureInitialized();
    final json = _userBox.get(userId);
    if (json == null) return null;
    return UserProfile.fromJson(jsonDecode(json));
  }

  Future<UserProfile?> getCurrentUser() async {
    await _ensureInitialized();
    final userId = _prefs.getString(_prefsKeyCurrentUserId);
    if (userId == null) return null;
    return getUserProfile(userId);
  }

  Future<void> deleteUserProfile(String userId) async {
    await _ensureInitialized();
    await _userBox.delete(userId);
  }

  // Birth Chart Methods

  Future<void> saveBirthChart(BirthChart chart) async {
    await _ensureInitialized();
    final json = jsonEncode(chart.toJson());
    await _chartBox.put(chart.userId, json);
  }

  Future<BirthChart?> getBirthChart(String userId) async {
    await _ensureInitialized();
    final json = _chartBox.get(userId);
    if (json == null) return null;
    return BirthChart.fromJson(jsonDecode(json));
  }

  Future<void> deleteBirthChart(String userId) async {
    await _ensureInitialized();
    await _chartBox.delete(userId);
  }

  // Music Track Methods

  Future<void> saveTrack(MusicTrack track) async {
    await _ensureInitialized();
    final json = jsonEncode(track.toJson());
    await _tracksBox.put(track.id, json);
  }

  Future<MusicTrack?> getTrack(String trackId) async {
    await _ensureInitialized();
    final json = _tracksBox.get(trackId);
    if (json == null) return null;
    return MusicTrack.fromJson(jsonDecode(json));
  }

  Future<List<MusicTrack>> getAllTracks() async {
    await _ensureInitialized();
    final tracks = <MusicTrack>[];
    for (final json in _tracksBox.values) {
      tracks.add(MusicTrack.fromJson(jsonDecode(json)));
    }
    return tracks;
  }

  Future<List<MusicTrack>> getUserTracks(String userId) async {
    await _ensureInitialized();
    final allTracks = await getAllTracks();
    return allTracks.where((t) => t.userId == userId).toList();
  }

  Future<void> deleteTrack(String trackId) async {
    await _ensureInitialized();
    await _tracksBox.delete(trackId);
  }

  // Playlist Methods

  Future<void> savePlaylist(Playlist playlist) async {
    await _ensureInitialized();
    final json = jsonEncode(playlist.toJson());
    await _playlistsBox.put(playlist.id, json);
  }

  Future<Playlist?> getPlaylist(String playlistId) async {
    await _ensureInitialized();
    final json = _playlistsBox.get(playlistId);
    if (json == null) return null;
    return Playlist.fromJson(jsonDecode(json));
  }

  Future<List<Playlist>> getAllPlaylists() async {
    await _ensureInitialized();
    final playlists = <Playlist>[];
    for (final json in _playlistsBox.values) {
      playlists.add(Playlist.fromJson(jsonDecode(json)));
    }
    return playlists;
  }

  Future<List<Playlist>> getUserPlaylists(String userId) async {
    await _ensureInitialized();
    final allPlaylists = await getAllPlaylists();
    return allPlaylists.where((p) => p.userId == userId).toList();
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _ensureInitialized();
    await _playlistsBox.delete(playlistId);
  }

  // Onboarding Methods

  Future<bool> isOnboardingComplete() async {
    await _ensureInitialized();
    return _prefs.getBool(_prefsKeyOnboardingComplete) ?? false;
  }

  Future<void> setOnboardingComplete(bool complete) async {
    await _ensureInitialized();
    await _prefs.setBool(_prefsKeyOnboardingComplete, complete);
  }

  // Clear All Data

  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _userBox.clear();
    await _chartBox.clear();
    await _tracksBox.clear();
    await _playlistsBox.clear();
    await _prefs.clear();
  }

  // Helper Methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  void dispose() {
    _userBox.close();
    _chartBox.close();
    _tracksBox.close();
    _playlistsBox.close();
  }
}
