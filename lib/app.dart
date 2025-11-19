import 'package:fanexp/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants/colors/main_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    const gaindeGreen = Color(0xFF00C853);
    const gaindeLight = Color(0xFFF6F8FB);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go Gaïndé',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gaindeGreen,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: gaindeLight,
        fontFamily: 'Josefin Sans',
      ),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr')],
      locale: _locale,

      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: generateRoute,
    );
  }
}
