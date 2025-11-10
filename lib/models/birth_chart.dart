import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'planet.dart';

part 'birth_chart.g.dart';

@JsonSerializable()
class BirthChart extends Equatable {
  final String userId;
  final DateTime calculatedAt;
  final List<Planet> planets;
  final ZodiacSign ascendant; // Lagna/Rising Sign
  final double ascendantDegree;
  final List<int> housePositions; // Starting degrees of each house
  final String moonSign; // Rashi
  final String sunSign;
  final String? description;

  const BirthChart({
    required this.userId,
    required this.calculatedAt,
    required this.planets,
    required this.ascendant,
    required this.ascendantDegree,
    required this.housePositions,
    required this.moonSign,
    required this.sunSign,
    this.description,
  });

  factory BirthChart.fromJson(Map<String, dynamic> json) =>
      _$BirthChartFromJson(json);

  Map<String, dynamic> toJson() => _$BirthChartToJson(this);

  /// Get planet by type
  Planet? getPlanet(PlanetType type) {
    try {
      return planets.firstWhere((p) => p.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Get all planets in a specific house
  List<Planet> getPlanetsInHouse(int house) {
    return planets.where((p) => p.house == house).toList();
  }

  /// Get all retrograde planets
  List<Planet> getRetrogradePlanets() {
    return planets.where((p) => p.isRetrograde).toList();
  }

  @override
  List<Object?> get props => [
        userId,
        calculatedAt,
        planets,
        ascendant,
        ascendantDegree,
        housePositions,
        moonSign,
        sunSign,
        description,
      ];
}
