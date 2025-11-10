import '../../models/planet.dart';
import '../../models/raag.dart';
import '../../models/birth_chart.dart';
import '../../models/cosmic_influence.dart';

/// Maps Vedic astrology to Indian classical raags
/// Based on traditional associations between planets, signs, and raags
class RaagMappingService {
  /// Get recommended raags based on birth chart
  List<Raag> getRaagsForBirthChart(BirthChart chart) {
    final raags = <Raag>[];

    // Map based on moon sign (most important in Vedic astrology)
    final moonPlanet = chart.getPlanet(PlanetType.moon);
    if (moonPlanet != null) {
      raags.addAll(_getRaagsForSign(moonPlanet.sign));
    }

    // Map based on ascendant
    raags.addAll(_getRaagsForSign(chart.ascendant));

    // Remove duplicates
    return raags.toSet().toList();
  }

  /// Get raags for current mood/energy
  List<Raag> getRaagsForMood(MoodType mood) {
    switch (mood) {
      case MoodType.calm:
        return _getCalmingRaags();
      case MoodType.energetic:
        return _getEnergeticRaags();
      case MoodType.creative:
        return _getCreativeRaags();
      case MoodType.focused:
        return _getFocusRaags();
      case MoodType.romantic:
        return _getRomanticRaags();
      case MoodType.spiritual:
        return _getSpiritualRaags();
      case MoodType.anxious:
        return _getAnxietyReliefRaags();
      case MoodType.restless:
        return _getGroundingRaags();
    }
  }

  /// Get raags for specific planetary influence
  List<Raag> getRaagsForPlanet(PlanetType planet) {
    switch (planet) {
      case PlanetType.sun:
        // Sun: Power, authority, confidence
        return [
          _createRaag(
            'Bhairav',
            'भैरव',
            'Powerful morning raag for confidence and strength',
            [RaagMood.powerful, RaagMood.energetic],
            ['Sa', 'Re komal', 'Ga', 'Ma', 'Pa', 'Dha komal', 'Ni'],
            'Bhairav',
            TimeOfDay.earlyMorning,
            [PlanetType.sun],
            [ZodiacSign.leo],
          ),
        ];

      case PlanetType.moon:
        // Moon: Emotions, mind, peace
        return [
          _createRaag(
            'Yaman',
            'यमन',
            'Soothing evening raag for emotional balance',
            [RaagMood.calm, RaagMood.romantic],
            ['Sa', 'Re', 'Ga', 'Ma tivra', 'Pa', 'Dha', 'Ni'],
            'Kalyan',
            TimeOfDay.evening,
            [PlanetType.moon, PlanetType.venus],
            [ZodiacSign.cancer, ZodiacSign.taurus],
          ),
        ];

      case PlanetType.mars:
        // Mars: Energy, action, courage
        return [
          _createRaag(
            'Darbari Kanada',
            'दरबारी कानडा',
            'Deep and intense raag for courage and determination',
            [RaagMood.powerful, RaagMood.contemplative],
            ['Sa', 'Re komal', 'Ga komal', 'Ma', 'Pa', 'Dha komal', 'Ni komal'],
            'Asavari',
            TimeOfDay.lateNight,
            [PlanetType.mars],
            [ZodiacSign.aries, ZodiacSign.scorpio],
          ),
        ];

      case PlanetType.mercury:
        // Mercury: Intelligence, communication, learning
        return [
          _createRaag(
            'Bihag',
            'बिहाग',
            'Melodious raag for mental clarity and communication',
            [RaagMood.joyful, RaagMood.calm],
            ['Sa', 'Re', 'Ga', 'Ma', 'Pa', 'Dha', 'Ni komal'],
            'Bilawal',
            TimeOfDay.evening,
            [PlanetType.mercury],
            [ZodiacSign.gemini, ZodiacSign.virgo],
          ),
        ];

      case PlanetType.jupiter:
        // Jupiter: Wisdom, spirituality, expansion
        return [
          _createRaag(
            'Bhupali',
            'भूपाली',
            'Serene pentatonic raag for wisdom and spiritual growth',
            [RaagMood.devotional, RaagMood.calm],
            ['Sa', 'Re', 'Ga', 'Pa', 'Dha'],
            'Kalyan',
            TimeOfDay.evening,
            [PlanetType.jupiter],
            [ZodiacSign.sagittarius, ZodiacSign.pisces],
          ),
        ];

      case PlanetType.venus:
        // Venus: Love, beauty, creativity
        return [
          _createRaag(
            'Kafi',
            'काफी',
            'Romantic semi-classical raag for love and beauty',
            [RaagMood.romantic, RaagMood.joyful],
            ['Sa', 'Re', 'Ga komal', 'Ma', 'Pa', 'Dha', 'Ni komal'],
            'Kafi',
            TimeOfDay.night,
            [PlanetType.venus],
            [ZodiacSign.taurus, ZodiacSign.libra],
          ),
        ];

      case PlanetType.saturn:
        // Saturn: Discipline, patience, introspection
        return [
          _createRaag(
            'Bageshri',
            'बागेश्री',
            'Meditative raag for patience and deep contemplation',
            [RaagMood.contemplative, RaagMood.calm],
            ['Sa', 'Re', 'Ga komal', 'Ma', 'Pa', 'Dha', 'Ni komal'],
            'Kafi',
            TimeOfDay.lateNight,
            [PlanetType.saturn],
            [ZodiacSign.capricorn, ZodiacSign.aquarius],
          ),
        ];

      case PlanetType.rahu:
        // Rahu: Transformation, unconventional
        return [
          _createRaag(
            'Marwa',
            'मारवा',
            'Unique sunset raag for transformation',
            [RaagMood.contemplative, RaagMood.powerful],
            ['Sa', 'Re komal', 'Ga', 'Ma tivra', 'Dha', 'Ni'],
            'Marwa',
            TimeOfDay.evening,
            [PlanetType.rahu],
            [],
          ),
        ];

      case PlanetType.ketu:
        // Ketu: Spirituality, detachment
        return [
          _createRaag(
            'Todi',
            'तोदी',
            'Deeply spiritual morning raag for enlightenment',
            [RaagMood.devotional, RaagMood.contemplative],
            ['Sa', 'Re komal', 'Ga komal', 'Ma tivra', 'Pa', 'Dha komal', 'Ni'],
            'Todi',
            TimeOfDay.morning,
            [PlanetType.ketu],
            [],
          ),
        ];

      default:
        return [];
    }
  }

  /// Get raags for time of day
  List<Raag> getRaagsForTimeOfDay(TimeOfDay time) {
    // This would return raags appropriate for the current time
    // Based on traditional raag-time associations
    return [];
  }

  // Private helper methods

  List<Raag> _getRaagsForSign(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
        return getRaagsForPlanet(PlanetType.mars);
      case ZodiacSign.taurus:
      case ZodiacSign.libra:
        return getRaagsForPlanet(PlanetType.venus);
      case ZodiacSign.gemini:
      case ZodiacSign.virgo:
        return getRaagsForPlanet(PlanetType.mercury);
      case ZodiacSign.cancer:
        return getRaagsForPlanet(PlanetType.moon);
      case ZodiacSign.leo:
        return getRaagsForPlanet(PlanetType.sun);
      case ZodiacSign.sagittarius:
      case ZodiacSign.pisces:
        return getRaagsForPlanet(PlanetType.jupiter);
      case ZodiacSign.capricorn:
      case ZodiacSign.aquarius:
        return getRaagsForPlanet(PlanetType.saturn);
      case ZodiacSign.scorpio:
        return getRaagsForPlanet(PlanetType.mars);
    }
  }

  List<Raag> _getCalmingRaags() {
    return [
      getRaagsForPlanet(PlanetType.moon).first,
      getRaagsForPlanet(PlanetType.jupiter).first,
    ];
  }

  List<Raag> _getEnergeticRaags() {
    return [
      getRaagsForPlanet(PlanetType.sun).first,
      getRaagsForPlanet(PlanetType.mars).first,
    ];
  }

  List<Raag> _getCreativeRaags() {
    return [
      getRaagsForPlanet(PlanetType.venus).first,
      getRaagsForPlanet(PlanetType.mercury).first,
    ];
  }

  List<Raag> _getFocusRaags() {
    return [
      getRaagsForPlanet(PlanetType.mercury).first,
      getRaagsForPlanet(PlanetType.saturn).first,
    ];
  }

  List<Raag> _getRomanticRaags() {
    return [getRaagsForPlanet(PlanetType.venus).first];
  }

  List<Raag> _getSpiritualRaags() {
    return [
      getRaagsForPlanet(PlanetType.jupiter).first,
      getRaagsForPlanet(PlanetType.ketu).first,
    ];
  }

  List<Raag> _getAnxietyReliefRaags() {
    return [
      getRaagsForPlanet(PlanetType.moon).first,
      getRaagsForPlanet(PlanetType.jupiter).first,
    ];
  }

  List<Raag> _getGroundingRaags() {
    return [getRaagsForPlanet(PlanetType.saturn).first];
  }

  Raag _createRaag(
    String name,
    String nameHindi,
    String description,
    List<RaagMood> moods,
    List<String> notes,
    String thaat,
    TimeOfDay preferredTime,
    List<PlanetType> planets,
    List<ZodiacSign> signs,
  ) {
    return Raag(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      nameHindi: nameHindi,
      description: description,
      moods: moods,
      notes: notes,
      thaat: thaat,
      preferredTime: preferredTime,
      associatedPlanets: planets,
      associatedSigns: signs,
      benefits: _getBenefitsForRaag(name),
    );
  }

  List<String> _getBenefitsForRaag(String raagName) {
    // Map raags to their traditional healing benefits
    final benefits = {
      'Bhairav': ['Increases confidence', 'Boosts energy', 'Enhances leadership'],
      'Yaman': ['Calms emotions', 'Promotes love', 'Reduces stress'],
      'Darbari Kanada': ['Builds courage', 'Increases focus', 'Deepens meditation'],
      'Bihag': ['Enhances communication', 'Improves memory', 'Brings joy'],
      'Bhupali': ['Spiritual awakening', 'Inner peace', 'Wisdom'],
      'Kafi': ['Opens heart chakra', 'Enhances creativity', 'Brings happiness'],
      'Bageshri': ['Patience', 'Discipline', 'Deep relaxation'],
      'Marwa': ['Transformation', 'Breaking patterns', 'Innovation'],
      'Todi': ['Enlightenment', 'Detachment', 'Spiritual insight'],
    };

    return benefits[raagName] ?? ['Promotes well-being', 'Balances energy'];
  }
}
