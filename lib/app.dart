// // ignore_for_file: library_private_types_in_public_api
// import 'dart:async';
// // import 'package:camera/camera.dart';
// import 'package:fanexp/screens/auth/splash.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// // import 'package:flutter_easyloading/flutter_easyloading.dart';
// // import 'package:geolocator/geolocator.dart';

// // import 'package:shared_preferences/shared_preferences.dart';
// import 'constants/colors/main_color.dart';
// // import 'package:flutter_localizations/flutter_localizations.dart';

// class MyApp extends StatefulWidget {
//   // This widget is the root of your application.
//   @override
//   _MyAppState createState() => _MyAppState();
//   static void setLocale(BuildContext context, Locale newLocale) {
//     _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
//     state?.setLocale(newLocale);
//   }
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   late BuildContext context;

//   Locale? _locale;
//   var tokenBackend = '';
//   bool haveToken = false;

//   // _readToken() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final key = 'token';
//   //   final value = prefs.getString(key) ?? '';
//   //   tokenBackend = value;

//   //   if (tokenBackend.isNotEmpty) {
//   //     setState(() {
//   //       haveToken = true;
//   //     });
//   //   }
//   // }

//   setLocale(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     // _readToken();
//     // configLoading();
//     super.initState();
//     // _askLocationPermission();
//   }

//   // _askLocationPermission() async {
//   //   // LocationPermission permission;
//   //   // permission =
//   //   await Geolocator.requestPermission();
//   // }

//   // void configLoading() {
//   //   EasyLoading.instance
//   //     ..displayDuration = const Duration(milliseconds: 2000)
//   //     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//   //     ..loadingStyle = EasyLoadingStyle.custom
//   //     ..indicatorSize = 45.0
//   //     ..radius = 10.0
//   //     ..progressColor = mainColor
//   //     ..backgroundColor = Colors.grey.shade200
//   //     ..indicatorColor = mainColor
//   //     ..textColor = mainColor
//   //     ..maskColor = mainColor
//   //     ..userInteractions = false
//   //     ..maskType = EasyLoadingMaskType.black
//   //     ..dismissOnTap = false;
//   //   // ..customAnimation = CustomAnimation();
//   // }

//   // List<CameraDescription> cameras = [];

//   Future<void> main() async {
//     runApp(MyApp());
//     // configLoading();
//     // Fetch the available cameras before initializing the app.
//     // try {
//     //   WidgetsFlutterBinding.ensureInitialized();
//     //   cameras = await availableCameras();
//     // } on CameraException catch (e) {
//     //   print('Error in fetching the cameras: $e');
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Digital Parrainage collecteur',
//       theme: ThemeData(
//         primarySwatch: appMainColor(),
//         fontFamily: 'Josefin Sans',
//       ),

//       // 👇 Localisation
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       supportedLocales: [Locale('fr', '')],
//       locale: _locale,
//       home:
//           // (haveToken == true)
//           //     ? const Login(
//           //         haveNumber: true,
//           //       )
//           //     :
//           SplashScreen(),
//       // builder: EasyLoading.init(),
//       //routes: routes(context),
//       initialRoute: "/",
//     );
//   }
// }

// lib/main.dart
// ignore_for_file: library_private_types_in_public_api
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

  // Permet de changer la locale dynamiquement si besoin
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
    // Palette Go Gaïndé
    const gaindeGreen = Color(0xFF00C853);
    const gaindeLight = Color(0xFFF6F8FB);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go Gaïndé',
      // Thème : garde ton primarySwatch + un colorScheme seed pour le vert
      theme: ThemeData(
        useMaterial3: true,
        // primarySwatch: appMainColor(), // depuis ton main_color.dart
        colorScheme: ColorScheme.fromSeed(
          seedColor: gaindeGreen,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: gaindeLight,
        fontFamily: 'Josefin Sans',
      ),

      // Localisation FR
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr')],
      locale: _locale,

      // ⚠️ Utilise EITHER home OU initialRoute (+ routes). Ici on choisit les routes.
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: generateRoute,
    );
  }
}
