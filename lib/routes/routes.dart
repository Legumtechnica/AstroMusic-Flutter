import 'package:flutter/cupertino.dart';
import 'package:astro_music/src/screens/splash_screen/splash_screen.dart';
import 'package:astro_music/src/screens/onboarding_screen/onboarding_screen.dart';
import 'package:astro_music/src/screens/home_screen/home_screen.dart';
import 'package:astro_music/src/screens/cosmic_dashboard/cosmic_dashboard_screen.dart';
import 'package:astro_music/src/screens/discover_screen/discover_screen.dart';
import 'package:astro_music/src/screens/player_screen/player_screen.dart';
import 'package:astro_music/src/screens/profile_screen/profile_screen.dart';
import 'package:astro_music/src/screens/premium_screen/premium_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  OnboardingScreen.routeName: (context) => OnboardingScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  CosmicDashboardScreen.routeName: (context) => CosmicDashboardScreen(),
  DiscoverScreen.routeName: (context) => DiscoverScreen(),
  PlayerScreen.routeName: (context) => PlayerScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  PremiumScreen.routeName: (context) => PremiumScreen(),
};
