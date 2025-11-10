import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'planet.g.dart';

enum PlanetType {
  sun,
  moon,
  mercury,
  venus,
  mars,
  jupiter,
  saturn,
  rahu, // North Node
  ketu, // South Node
  uranus,
  neptune,
  pluto,
}

enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
}

@JsonSerializable()
class Planet extends Equatable {
  final PlanetType type;
  final double longitude; // Degrees (0-360)
  final double latitude;
  final ZodiacSign sign;
  final int house; // House number (1-12)
  final bool isRetrograde;
  final String? nakshatra; // Vedic lunar mansion
  final int? nakshatraPada; // Pada (1-4)

  const Planet({
    required this.type,
    required this.longitude,
    required this.latitude,
    required this.sign,
    required this.house,
    this.isRetrograde = false,
    this.nakshatra,
    this.nakshatraPada,
  });

  factory Planet.fromJson(Map<String, dynamic> json) => _$PlanetFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetToJson(this);

  @override
  List<Object?> get props => [
        type,
        longitude,
        latitude,
        sign,
        house,
        isRetrograde,
        nakshatra,
        nakshatraPada,
      ];

  String get name {
    switch (type) {
      case PlanetType.sun:
        return 'Sun (Surya)';
      case PlanetType.moon:
        return 'Moon (Chandra)';
      case PlanetType.mercury:
        return 'Mercury (Budha)';
      case PlanetType.venus:
        return 'Venus (Shukra)';
      case PlanetType.mars:
        return 'Mars (Mangala)';
      case PlanetType.jupiter:
        return 'Jupiter (Guru)';
      case PlanetType.saturn:
        return 'Saturn (Shani)';
      case PlanetType.rahu:
        return 'Rahu (North Node)';
      case PlanetType.ketu:
        return 'Ketu (South Node)';
      case PlanetType.uranus:
        return 'Uranus';
      case PlanetType.neptune:
        return 'Neptune';
      case PlanetType.pluto:
        return 'Pluto';
    }
  }
}
