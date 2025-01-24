import 'package:flutter/material.dart';
import 'package:online_taxi/features/weather/presentation/screens/history/history_screen.dart';
import 'package:online_taxi/features/weather/presentation/screens/home/home_screen.dart';
import 'package:online_taxi/features/weather/presentation/screens/search/search_screen.dart';
import 'package:online_taxi/features/weather/presentation/screens/settings/settings_screen.dart';

import '../../core/extensions/navigation_extension.dart';
import '../../features/weather/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String homeScreen = '/homeScreen';
  static const String searchScreen = '/searchScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String historyScreen = '/historyScreen';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return customRoute(const SplashScreen());
      case homeScreen:
        return customRoute(const HomeScreen());
      case searchScreen:
        return customRoute(const SearchScreen());
      case settingsScreen:
        return customRoute(const SettingsScreen());
      case historyScreen:
        return customRoute(const HistoryScreen());
      default:
        return customRoute(const SplashScreen());
    }
  }
}
