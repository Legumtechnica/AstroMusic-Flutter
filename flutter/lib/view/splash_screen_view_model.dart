import 'package:flutter/cupertino.dart';
import 'package:astro_music/provider/base_model.dart';
import 'package:astro_music/provider/getit.dart';
import 'package:astro_music/services/storage_service.dart';
import 'package:astro_music/src/screens/home_screen/home_screen.dart';
import 'package:astro_music/src/screens/onboarding_screen/onboarding_screen.dart';
import 'package:astro_music/src/screens/splash_screen/components/page.dart';

class SplashScreenViewModel extends BaseModel {
  final PageController controller = PageController();
  final _storageService = getIt<StorageService>();

  List<Widget> list = [
    CustomPage(
      subline:
          'Experience AI-generated Indian classical music tailored to your birth chart and planetary transits.',
      index: 0,
      headline: 'AstroMusic\nWhere Universe\nMeets Melody',
      image: 'assets/images/Meditation.png',
    ),
    CustomPage(
      subline:
          'Your personalized dashboard shows how celestial alignments shape your energy and mood.',
      index: 1,
      headline: 'Live\nCosmic\nInfluence',
      image: 'assets/images/Breathe.png',
    ),
    CustomPage(
      subline:
          'Daily playlists with raag therapy compositions that resonate with your soul\'s unique vibration.',
      index: 2,
      headline: 'Personalized\nRaag\nTherapy',
      image: 'assets/images/Stone.png',
    ),
  ];

  Future<void> checkOnboardingStatus(BuildContext context) async {
    final isComplete = await _storageService.isOnboardingComplete();
    final route = isComplete ? HomeScreen.routeName : OnboardingScreen.routeName;

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  void animateSlider(int nextPage, BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then((_) async {
      if (nextPage == list.length) {
        await checkOnboardingStatus(context);
        return;
      }

      controller
          .animateToPage(nextPage,
              duration: Duration(seconds: 1), curve: Curves.easeOut)
          .then((_) => animateSlider(nextPage + 1, context));
    });
  }
}
