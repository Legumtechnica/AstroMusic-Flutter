import 'package:flutter/material.dart';
import 'package:astro_music/config/size_config.dart';
import 'package:astro_music/provider/base_view.dart';
import 'package:astro_music/view/onboarding_view_model.dart';
import 'package:astro_music/src/screens/home_screen/home_screen.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<OnboardingViewModel>(
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        body: Container(
          height: SizeConfig.height,
          width: SizeConfig.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(model),
                Expanded(
                  child: _buildStepContent(model),
                ),
                _buildFooter(model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(OnboardingViewModel model) {
    return Padding(
      padding: EdgeInsets.all(proportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: model.progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE94560)),
            ),
          ),
          SizedBox(height: proportionateScreenHeight(20)),
          // Title
          Text(
            model.stepTitle,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: proportionateScreenWidth(32),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: proportionateScreenHeight(8)),
          // Description
          Text(
            model.stepDescription,
            style: TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: proportionateScreenWidth(16),
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(OnboardingViewModel model) {
    switch (model.currentStep) {
      case 0:
        return _buildWelcomeStep(model);
      case 1:
        return _buildNameStep(model);
      case 2:
        return _buildBirthDetailsStep(model);
      case 3:
        return _buildLocationStep(model);
      default:
        return Container();
    }
  }

  Widget _buildWelcomeStep(OnboardingViewModel model) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(proportionateScreenWidth(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              size: proportionateScreenWidth(100),
              color: Color(0xFFE94560),
            ),
            SizedBox(height: proportionateScreenHeight(30)),
            Text(
              '🎧 Personalized Raag Therapy',
              style: TextStyle(
                fontSize: proportionateScreenWidth(18),
                color: Colors.white,
                fontFamily: 'SF Pro Text',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: proportionateScreenHeight(15)),
            Text(
              '🔮 Astro-Aligned Playlists',
              style: TextStyle(
                fontSize: proportionateScreenWidth(18),
                color: Colors.white,
                fontFamily: 'SF Pro Text',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: proportionateScreenHeight(15)),
            Text(
              '🎼 AI-Composed Music',
              style: TextStyle(
                fontSize: proportionateScreenWidth(18),
                color: Colors.white,
                fontFamily: 'SF Pro Text',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: proportionateScreenHeight(15)),
            Text(
              '📅 Live Cosmic Influence',
              style: TextStyle(
                fontSize: proportionateScreenWidth(18),
                color: Colors.white,
                fontFamily: 'SF Pro Text',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameStep(OnboardingViewModel model) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(proportionateScreenWidth(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGlassTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              onChanged: model.setName,
            ),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildGlassTextField(
              controller: _emailController,
              label: 'Email (Optional)',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              onChanged: model.setEmail,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthDetailsStep(OnboardingViewModel model) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(proportionateScreenWidth(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGlassButton(
              label: model.birthDate == null
                  ? 'Select Birth Date'
                  : 'Birth Date: ${model.birthDate!.day}/${model.birthDate!.month}/${model.birthDate!.year}',
              icon: Icons.calendar_today,
              onTap: () => _selectBirthDate(context, model),
            ),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildGlassButton(
              label: model.birthTime == null
                  ? 'Select Birth Time'
                  : 'Birth Time: ${model.birthTime!.format(context)}',
              icon: Icons.access_time,
              onTap: () => _selectBirthTime(context, model),
            ),
            SizedBox(height: proportionateScreenHeight(20)),
            Text(
              'Accurate birth time helps us create better personalized music for you',
              style: TextStyle(
                fontSize: proportionateScreenWidth(12),
                color: Colors.white.withOpacity(0.6),
                fontFamily: 'SF Pro Text',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStep(OnboardingViewModel model) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(proportionateScreenWidth(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGlassTextField(
              controller: _locationController,
              label: 'Birth Place (City, Country)',
              icon: Icons.location_on,
              readOnly: true,
              onChanged: (_) {},
            ),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildGlassButton(
              label: 'Use Current Location',
              icon: Icons.my_location,
              onTap: () => _getCurrentLocation(model),
            ),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildGlassButton(
              label: 'Search Location',
              icon: Icons.search,
              onTap: () => _searchLocation(model),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: proportionateScreenHeight(60),
      borderRadius: 15,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: TextStyle(
          color: Colors.white,
          fontSize: proportionateScreenWidth(16),
          fontFamily: 'SF Pro Text',
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xFFE94560)),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontFamily: 'SF Pro Text',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: proportionateScreenWidth(20),
            vertical: proportionateScreenHeight(18),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: proportionateScreenHeight(60),
        borderRadius: 15,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFFE94560)),
            SizedBox(width: proportionateScreenWidth(10)),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: proportionateScreenWidth(16),
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(OnboardingViewModel model) {
    return Padding(
      padding: EdgeInsets.all(proportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (model.currentStep > 0)
            _buildFooterButton(
              label: 'Back',
              onTap: model.previousStep,
              isPrimary: false,
            )
          else
            SizedBox(width: proportionateScreenWidth(100)),
          if (model.errorMessage != null)
            Expanded(
              child: Text(
                model.errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: proportionateScreenWidth(12),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          _buildFooterButton(
            label: model.currentStep == model.totalSteps - 1 ? 'Complete' : 'Next',
            onTap: () => _handleNext(model),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: proportionateScreenWidth(100),
        height: proportionateScreenHeight(50),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [Color(0xFFE94560), Color(0xFFFF6B9D)],
                )
              : null,
          color: isPrimary ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: proportionateScreenWidth(16),
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context, OnboardingViewModel model) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      model.setBirthDate(date);
    }
  }

  Future<void> _selectBirthTime(BuildContext context, OnboardingViewModel model) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 0),
    );

    if (time != null) {
      model.setBirthTime(time);
    }
  }

  Future<void> _getCurrentLocation(OnboardingViewModel model) async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final location = '${place.locality}, ${place.country}';
        _locationController.text = location;

        model.setBirthLocation(
          place: location,
          latitude: position.latitude,
          longitude: position.longitude,
          tz: DateTime.now().timeZoneName,
        );
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _searchLocation(OnboardingViewModel model) async {
    // Show dialog to search for location
    // This is simplified - in production, use a proper location search
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Location'),
        content: Text('Location search not implemented yet. Use current location for now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext(OnboardingViewModel model) async {
    if (model.currentStep == model.totalSteps - 1) {
      // Complete onboarding
      final success = await model.completeOnboarding();
      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    } else {
      model.nextStep();
    }
  }
}
