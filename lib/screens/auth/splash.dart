// import 'dart:async';
// //import 'package:jeff_sa_gox_app_client/screens/onboarding/login.dart';
// import 'package:fanexp/screens/auth/auth.dart';
// import 'package:flutter/material.dart';
// // import 'package:jeff_sa_gox_app_client/screens/login/login-Signin.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//       Duration(
//         seconds: 3,
//       ), // Temps d'affichage du splash screen (3 secondes dans cet exemple)
//       () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (BuildContext context) => Auth()),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image.asset('assets/images/flagband.png', width: 150, height: 150),
//               SizedBox(height: 20),
//               CircularProgressIndicator(), // Vous pouvez utiliser un indicateur de chargement ici
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fanexp/screens/auth/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Animation de 3 secondes
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    // Zoom progressif de 1.0 à 1.15 (15 % d’agrandissement)
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Après la fin de l’animation -> aller vers Auth
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goNext();
      }
    });
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => Auth(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Image avec zoom in
          AnimatedBuilder(
            animation: _scale,
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: Image.asset(
                  'assets/img/supporter.png',
                  fit: BoxFit.cover, // occupe tout l'écran
                ),
              );
            },
          ),

          // Texte en bas
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.8,
              child: Text(
                'Go GAINDE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
