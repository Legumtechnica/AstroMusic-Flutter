import 'package:sweph/sweph.dart';
import '../../models/birth_chart.dart';
import '../../models/planet.dart';
import '../../models/user_profile.dart';
import '../../models/cosmic_influence.dart';

class AstrologyService {
  late Sweph _sweph;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Swiss Ephemeris
      _sweph = Sweph();
      await Sweph.init();
      _isInitialized = true;
    } catch (e) {
      print('Error initializing Swiss Ephemeris: $e');
      rethrow;
    }
  }

  /// Calculate birth chart for a user
  Future<BirthChart> calculateBirthChart(UserProfile user) async {
    if (!_isInitialized) await initialize();

    try {
      // Parse birth time
      final timeParts = user.birthTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Create DateTime with birth details
      final birthDateTime = DateTime(
        user.birthDate.year,
        user.birthDate.month,
        user.birthDate.day,
        hour,
        minute,
      );

      // Convert to Julian Day
      final julianDay = Sweph.swe_julday(
        birthDateTime.year,
        birthDateTime.month,
        birthDateTime.day,
        birthDateTime.hour + birthDateTime.minute / 60.0,
        CalendarType.gregorian,
      );

      // Calculate planetary positions
      final planets = await _calculatePlanets(julianDay);

      // Calculate houses and ascendant
      final houses = await _calculateHouses(
        julianDay,
        user.birthLatitude,
        user.birthLongitude,
      );

      // Determine ascendant sign
      final ascendantSign = _getZodiacSign(houses['ascendant']!);

      // Get moon sign and sun sign
      final moonPlanet = planets.firstWhere((p) => p.type == PlanetType.moon);
      final sunPlanet = planets.firstWhere((p) => p.type == PlanetType.sun);

      return BirthChart(
        userId: user.id,
        calculatedAt: DateTime.now(),
        planets: planets,
        ascendant: ascendantSign,
        ascendantDegree: houses['ascendant']!,
        housePositions: houses['houses']!.cast<int>(),
        moonSign: moonPlanet.sign.toString().split('.').last,
        sunSign: sunPlanet.sign.toString().split('.').last,
        description: _generateChartDescription(planets, ascendantSign),
      );
    } catch (e) {
      print('Error calculating birth chart: $e');
      rethrow;
    }
  }

  /// Calculate current planetary positions for transits
  Future<List<Planet>> calculateCurrentTransits() async {
    if (!_isInitialized) await initialize();

    final now = DateTime.now();
    final julianDay = Sweph.swe_julday(
      now.year,
      now.month,
      now.day,
      now.hour + now.minute / 60.0,
      CalendarType.gregorian,
    );

    return await _calculatePlanets(julianDay);
  }

  /// Calculate cosmic influence for today
  Future<CosmicInfluence> calculateCosmicInfluence(
    UserProfile user,
    BirthChart birthChart,
  ) async {
    final currentTransits = await calculateCurrentTransits();

    // Analyze transits against birth chart
    final activeTransits = _analyzeTransits(birthChart.planets, currentTransits);

    // Determine energy level
    final energyLevel = _calculateEnergyLevel(activeTransits);

    // Determine dominant moods
    final moods = _determineMoods(activeTransits, birthChart);

    // Generate recommendations
    final recommendations = _generateRecommendations(activeTransits, moods);

    // Find lucky raag
    final luckyRaag = _determineLuckyRaag(currentTransits, birthChart);

    // Calculate overall score
    final score = _calculateOverallScore(activeTransits);

    return CosmicInfluence(
      userId: user.id,
      date: DateTime.now(),
      energyLevel: energyLevel,
      dominantMoods: moods,
      overallDescription: _generateOverallDescription(activeTransits, energyLevel),
      recommendations: recommendations,
      activeTransits: activeTransits,
      luckyRaag: luckyRaag,
      overallScore: score,
    );
  }

  // Private helper methods

  Future<List<Planet>> _calculatePlanets(double julianDay) async {
    final planets = <Planet>[];

    // List of planets to calculate (Swiss Ephemeris constants)
    final planetIds = [
      0,  // Sun
      1,  // Moon
      2,  // Mercury
      3,  // Venus
      4,  // Mars
      5,  // Jupiter
      6,  // Saturn
      11, // Rahu (mean node)
    ];

    final planetTypes = [
      PlanetType.sun,
      PlanetType.moon,
      PlanetType.mercury,
      PlanetType.venus,
      PlanetType.mars,
      PlanetType.jupiter,
      PlanetType.saturn,
      PlanetType.rahu,
    ];

    for (var i = 0; i < planetIds.length; i++) {
      try {
        final result = Sweph.swe_calc_ut(
          julianDay,
          HeavenlyBody.values[planetIds[i]],
          SwephFlag.speed,
        );

        final longitude = result.longitude;
        final latitude = result.latitude;
        final sign = _getZodiacSign(longitude);
        final house = _getHouseFromLongitude(longitude);
        final isRetrograde = result.longitudeSpeed < 0; // Speed < 0 means retrograde

        planets.add(Planet(
          type: planetTypes[i],
          longitude: longitude,
          latitude: latitude,
          sign: sign,
          house: house,
          isRetrograde: isRetrograde,
        ));
      } catch (e) {
        print('Error calculating planet ${planetTypes[i]}: $e');
      }
    }

    // Calculate Ketu (180 degrees opposite to Rahu)
    final rahu = planets.firstWhere((p) => p.type == PlanetType.rahu);
    final ketuLongitude = (rahu.longitude + 180) % 360;
    planets.add(Planet(
      type: PlanetType.ketu,
      longitude: ketuLongitude,
      latitude: -rahu.latitude,
      sign: _getZodiacSign(ketuLongitude),
      house: _getHouseFromLongitude(ketuLongitude),
      isRetrograde: rahu.isRetrograde,
    ));

    return planets;
  }

  Future<Map<String, dynamic>> _calculateHouses(
    double julianDay,
    double latitude,
    double longitude,
  ) async {
    try {
      // Use Placidus house system (common in Western astrology)
      // For Vedic, you might want to use Whole Sign houses
      final houses = Sweph.swe_houses(
        julianDay,
        latitude,
        longitude,
        Hsys.placidus,
      );

      return {
        'ascendant': houses.ascendant,
        'mc': houses.mc, // Midheaven
        'houses': houses.cusps, // House cusps
      };
    } catch (e) {
      print('Error calculating houses: $e');
      rethrow;
    }
  }

  ZodiacSign _getZodiacSign(double longitude) {
    final signIndex = (longitude / 30).floor();
    return ZodiacSign.values[signIndex % 12];
  }

  int _getHouseFromLongitude(double longitude) {
    // Simplified house calculation
    // In real implementation, use proper house system
    return ((longitude / 30).floor() % 12) + 1;
  }

  String _generateChartDescription(List<Planet> planets, ZodiacSign ascendant) {
    return 'Birth chart with ${ascendant.toString().split('.').last} rising. '
        'This chart shows the cosmic blueprint at the time of birth.';
  }

  List<PlanetaryTransit> _analyzeTransits(
    List<Planet> natalPlanets,
    List<Planet> transitPlanets,
  ) {
    final transits = <PlanetaryTransit>[];

    for (final transitPlanet in transitPlanets) {
      // Find aspects to natal planets
      // This is simplified - real implementation would calculate exact aspects
      transits.add(PlanetaryTransit(
        planet: transitPlanet.type,
        currentSign: transitPlanet.sign,
        description: '${transitPlanet.name} in ${transitPlanet.sign.toString().split('.').last}',
        influence: 'Neutral',
        startDate: DateTime.now(),
        intensity: 0.5,
      ));
    }

    return transits;
  }

  EnergyLevel _calculateEnergyLevel(List<PlanetaryTransit> transits) {
    // Simplified energy calculation
    // In reality, analyze Mars, Sun positions and aspects
    return EnergyLevel.moderate;
  }

  List<MoodType> _determineMoods(
    List<PlanetaryTransit> transits,
    BirthChart chart,
  ) {
    // Analyze Moon position and aspects for moods
    return [MoodType.calm, MoodType.focused];
  }

  List<String> _generateRecommendations(
    List<PlanetaryTransit> transits,
    List<MoodType> moods,
  ) {
    return [
      'Good day for meditation and introspection',
      'Listen to calming raags to balance your energy',
      'Practice deep breathing exercises',
    ];
  }

  String? _determineLuckyRaag(List<Planet> transits, BirthChart chart) {
    // Map current planetary positions to appropriate raag
    // This would use the raag mapping system
    return 'Raag Yaman';
  }

  double _calculateOverallScore(List<PlanetaryTransit> transits) {
    // Calculate overall favorability score
    return 75.0;
  }

  String _generateOverallDescription(
    List<PlanetaryTransit> transits,
    EnergyLevel energy,
  ) {
    return 'Today\'s cosmic energy is ${energy.toString().split('.').last}. '
        'The planets are aligned favorably for creative pursuits and meditation.';
  }

  void dispose() {
    if (_isInitialized) {
      Sweph.swe_close();
      _isInitialized = false;
    }
  }
}
