import 'package:fanexp/screens/fanzone/fanzone.dart';
import 'package:fanexp/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/screens/auth/splash.dart';
import 'package:fanexp/screens/home/homepage.dart';
import 'package:fanexp/screens/timeline/timelinePage.dart';
import 'package:fanexp/screens/match/matchHub.dart';
import 'package:fanexp/screens/player/playerAnalytics.dart';
import 'package:fanexp/screens/prediction/predictReco.dart';
import 'package:fanexp/screens/shop/shop.dart';
import 'package:fanexp/screens/profil/profil.dart';
import 'package:fanexp/screens/auth/login.dart';
import 'package:fanexp/screens/auth/register.dart';

// ==== Palette Go Gaïndé ====
const gaindeGreen = Color(0xFF00C853);
const gaindeGold = Color(0xFFF9B233);
const gaindeDark = Color(0xFF0F1D13);
const gaindeLight = Color(0xFFF6F8FB);

/// Routes Go Gaïndé — centralisation des écrans
class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const timeline = '/timeline';
  static const match = '/match';
  static const players = '/players';
  static const predict = '/predict';
  static const fanzone = '/fanzone';
  static const shop = '/shop';
  static const profile = '/profile';
  static const login = '/login';
  static const register = '/register';
  static const settings = '/settings';

  /// Tableau des routes déclaratives
  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    home: (_) => const HomePage(),
    timeline: (_) => const TimelinePage(),
    match: (_) => const MatchHub(),
    players: (_) => const PlayerAnalytics(), // <- corrigé
    predict: (_) => const PredictionReco(),
    fanzone: (_) => const Fanzone(),
    shop: (_) => const Shop(),
    profile: (_) => const Profil(),
    login: (_) => const Login(),
    register: (_) => const Register(),
    settings: (_) => const Settings(),
  };
}

/// Transitions customisées (optionnelles via onGenerateRoute)
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.timeline:
      return _fade(const TimelinePage());
    case AppRoutes.match:
      return _slide(const MatchHub());
    case AppRoutes.players:
      return _slide(const PlayerAnalytics());
    default:
      return MaterialPageRoute(builder: (_) => const HomePage());
  }
}

/// Transition fondu
PageRouteBuilder _fade(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

/// Transition slide latéral
PageRouteBuilder _slide(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) {
      final offsetAnim = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(anim);
      return SlideTransition(position: offsetAnim, child: child);
    },
  );
}
