import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../provider/base_model.dart';
import '../provider/getit.dart';
import '../models/user_profile.dart';
import '../models/birth_chart.dart';
import '../services/storage_service.dart';
import '../services/astrology/astrology_service.dart';
import '../enum/view_state.dart';

class OnboardingViewModel extends BaseModel {
  final _storageService = getIt<StorageService>();
  final _astrologyService = getIt<AstrologyService>();
  final _uuid = const Uuid();

  // Form fields
  String name = '';
  String? email;
  DateTime? birthDate;
  TimeOfDay? birthTime;
  double? birthLatitude;
  double? birthLongitude;
  String? birthPlace;
  String? timezone;

  int currentStep = 0;
  final int totalSteps = 4;

  String? errorMessage;

  // Form validation
  bool get canProceedFromStep1 => name.isNotEmpty;
  bool get canProceedFromStep2 => birthDate != null && birthTime != null;
  bool get canProceedFromStep3 =>
      birthPlace != null &&
      birthLatitude != null &&
      birthLongitude != null;
  bool get canComplete => canProceedFromStep1 && canProceedFromStep2 && canProceedFromStep3;

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value.isNotEmpty ? value : null;
    notifyListeners();
  }

  void setBirthDate(DateTime date) {
    birthDate = date;
    notifyListeners();
  }

  void setBirthTime(TimeOfDay time) {
    birthTime = time;
    notifyListeners();
  }

  void setBirthLocation({
    required String place,
    required double latitude,
    required double longitude,
    required String tz,
  }) {
    birthPlace = place;
    birthLatitude = latitude;
    birthLongitude = longitude;
    timezone = tz;
    notifyListeners();
  }

  void nextStep() {
    if (currentStep < totalSteps - 1) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  Future<bool> completeOnboarding() async {
    if (!canComplete) {
      errorMessage = 'Please fill in all required fields';
      notifyListeners();
      return false;
    }

    setState(ViewState.Busy);
    errorMessage = null;

    try {
      // Create user profile
      final userId = _uuid.v4();
      final user = UserProfile(
        id: userId,
        name: name,
        email: email,
        birthDate: birthDate!,
        birthTime: '${birthTime!.hour.toString().padLeft(2, '0')}:${birthTime!.minute.toString().padLeft(2, '0')}',
        birthLatitude: birthLatitude!,
        birthLongitude: birthLongitude!,
        birthPlace: birthPlace!,
        timezone: timezone!,
        createdAt: DateTime.now(),
      );

      // Save user profile
      await _storageService.saveUserProfile(user);

      // Calculate birth chart
      final birthChart = await _astrologyService.calculateBirthChart(user);

      // Save birth chart
      await _storageService.saveBirthChart(birthChart);

      // Mark onboarding as complete
      await _storageService.setOnboardingComplete(true);

      setState(ViewState.Idle);
      return true;
    } catch (e) {
      errorMessage = 'Failed to create profile: ${e.toString()}';
      setState(ViewState.Idle);
      notifyListeners();
      return false;
    }
  }

  String get stepTitle {
    switch (currentStep) {
      case 0:
        return 'Welcome to AstroMusic';
      case 1:
        return 'Your Name';
      case 2:
        return 'Birth Details';
      case 3:
        return 'Birth Location';
      default:
        return '';
    }
  }

  String get stepDescription {
    switch (currentStep) {
      case 0:
        return 'Discover music that resonates with your cosmic energy';
      case 1:
        return 'What should we call you?';
      case 2:
        return 'When were you born?';
      case 3:
        return 'Where were you born?';
      default:
        return '';
    }
  }

  double get progress => (currentStep + 1) / totalSteps;
}
