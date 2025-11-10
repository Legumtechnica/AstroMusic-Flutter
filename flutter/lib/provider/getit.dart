import 'package:get_it/get_it.dart';
import 'package:astro_music/service/navigation_service.dart';
import 'package:astro_music/services/storage_service.dart';
import 'package:astro_music/services/astrology/astrology_service.dart';
import 'package:astro_music/services/astrology/raag_mapping_service.dart';
import 'package:astro_music/services/music/music_generation_service.dart';
import 'package:astro_music/view/splash_screen_view_model.dart';
import 'package:astro_music/view/onboarding_view_model.dart';
import 'package:astro_music/view/home_screen_view_model.dart';
import 'package:astro_music/view/discover_screen_view_model.dart';
import 'package:astro_music/view/player_screen_view_model.dart';
import 'package:astro_music/view/premium_screen_view_model.dart';
import 'package:astro_music/view/profile_screen_view_model.dart';
import 'package:astro_music/view/cosmic_dashboard_view_model.dart';

GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Services (Singletons)
  getIt.registerLazySingleton(() => NavigationService());

  final storageService = StorageService();
  await storageService.initialize();
  getIt.registerSingleton<StorageService>(storageService);

  // TODO: Replace with your actual backend API URL
  const apiBaseUrl = 'https://api.astromusic.app'; // Or use 'http://localhost:8000' for local dev

  final astrologyService = AstrologyService(baseUrl: apiBaseUrl);
  await astrologyService.initialize();
  getIt.registerSingleton<AstrologyService>(astrologyService);

  getIt.registerLazySingleton(() => RaagMappingService());

  getIt.registerLazySingleton(() => MusicGenerationService(
    apiBaseUrl: apiBaseUrl,
  ));

  // ViewModels (Factories - new instance each time)
  getIt.registerFactory(() => SplashScreenViewModel());
  getIt.registerFactory(() => OnboardingViewModel());
  getIt.registerFactory(() => HomeScreenViewModel());
  getIt.registerFactory(() => DiscoverScreenViewModel());
  getIt.registerFactory(() => PlayerScreenViewModel());
  getIt.registerFactory(() => PremiumScreenViewModel());
  getIt.registerFactory(() => ProfileScreenViewModel());
  getIt.registerFactory(() => CosmicDashboardViewModel());
}
