import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'planet.dart';

part 'cosmic_influence.g.dart';

enum EnergyLevel {
  veryLow,
  low,
  moderate,
  high,
  veryHigh,
}

enum MoodType {
  calm,
  anxious,
  energetic,
  creative,
  focused,
  romantic,
  spiritual,
  restless,
}

@JsonSerializable()
class CosmicInfluence extends Equatable {
  final String userId;
  final DateTime date;
  final EnergyLevel energyLevel;
  final List<MoodType> dominantMoods;
  final String overallDescription;
  final List<String> recommendations;
  final List<PlanetaryTransit> activeTransits;
  final String? luckyRaag;
  final String? challengingAspect;
  final double overallScore; // 0-100
  final Map<String, double>? chakraBalances; // Chakra name -> balance %

  const CosmicInfluence({
    required this.userId,
    required this.date,
    required this.energyLevel,
    required this.dominantMoods,
    required this.overallDescription,
    required this.recommendations,
    required this.activeTransits,
    this.luckyRaag,
    this.challengingAspect,
    required this.overallScore,
    this.chakraBalances,
  });

  factory CosmicInfluence.fromJson(Map<String, dynamic> json) =>
      _$CosmicInfluenceFromJson(json);

  Map<String, dynamic> toJson() => _$CosmicInfluenceToJson(this);

  @override
  List<Object?> get props => [
        userId,
        date,
        energyLevel,
        dominantMoods,
        overallDescription,
        recommendations,
        activeTransits,
        luckyRaag,
        challengingAspect,
        overallScore,
        chakraBalances,
      ];
}

@JsonSerializable()
class PlanetaryTransit extends Equatable {
  final PlanetType planet;
  final ZodiacSign currentSign;
  final ZodiacSign? movingToSign;
  final String description;
  final String influence; // Positive, Neutral, Challenging
  final DateTime startDate;
  final DateTime? endDate;
  final double intensity; // 0-1

  const PlanetaryTransit({
    required this.planet,
    required this.currentSign,
    this.movingToSign,
    required this.description,
    required this.influence,
    required this.startDate,
    this.endDate,
    required this.intensity,
  });

  factory PlanetaryTransit.fromJson(Map<String, dynamic> json) =>
      _$PlanetaryTransitFromJson(json);

  Map<String, dynamic> toJson() => _$PlanetaryTransitToJson(this);

  @override
  List<Object?> get props => [
        planet,
        currentSign,
        movingToSign,
        description,
        influence,
        startDate,
        endDate,
        intensity,
      ];
}
