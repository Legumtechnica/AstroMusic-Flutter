import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'planet.dart';

part 'raag.g.dart';

enum RaagMood {
  calm,
  energetic,
  devotional,
  romantic,
  contemplative,
  joyful,
  melancholic,
  powerful,
}

enum TimeOfDay {
  earlyMorning, // 4-7 AM
  morning, // 7-10 AM
  lateMorning, // 10 AM-12 PM
  afternoon, // 12-4 PM
  evening, // 4-7 PM
  night, // 7-10 PM
  lateNight, // 10 PM-12 AM
  midnight, // 12-4 AM
}

@JsonSerializable()
class Raag extends Equatable {
  final String id;
  final String name;
  final String nameHindi;
  final String description;
  final List<RaagMood> moods;
  final List<String> notes; // Sa, Re, Ga, Ma, Pa, Dha, Ni
  final String thaat; // Parent scale
  final TimeOfDay? preferredTime;
  final List<PlanetType> associatedPlanets;
  final List<ZodiacSign> associatedSigns;
  final List<String> benefits; // Healing properties
  final String? imageUrl;

  const Raag({
    required this.id,
    required this.name,
    required this.nameHindi,
    required this.description,
    required this.moods,
    required this.notes,
    required this.thaat,
    this.preferredTime,
    required this.associatedPlanets,
    required this.associatedSigns,
    required this.benefits,
    this.imageUrl,
  });

  factory Raag.fromJson(Map<String, dynamic> json) => _$RaagFromJson(json);

  Map<String, dynamic> toJson() => _$RaagToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        nameHindi,
        description,
        moods,
        notes,
        thaat,
        preferredTime,
        associatedPlanets,
        associatedSigns,
        benefits,
        imageUrl,
      ];
}
