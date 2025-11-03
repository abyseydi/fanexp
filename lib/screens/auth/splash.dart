import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fanexp/screens/auth/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _animDuration = Duration(seconds: 5);

  late final AnimationController _controller;
  late final Animation<double> _scale;

  bool _reduceMotion = false;
  ImageProvider _bg = const AssetImage('assets/img/yallapitie.jpeg');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _animDuration);
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _goNext();
    });
  }

  // Pré-cache l’image + lit la préférence d’accessibilité
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.of(context).disableAnimations;

    // Préchargement pour éviter les clignotements
    precacheImage(_bg, context).then((_) {
      if (!mounted) return;
      // Lance l’anim sauf si l’utilisateur préfère moins d’animations
      if (_reduceMotion) {
        Future.delayed(const Duration(milliseconds: 600), _goNext);
      } else {
        _controller.forward();
      }
    });
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: _reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const Auth(),
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
    // Masquer la barre de statut (optionnel)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌄 Image plein écran avec zoom-in
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final scale = _reduceMotion ? 1.0 : _scale.value;
              return Transform.scale(
                scale: scale,
                child: Semantics(
                  label: 'Supporters de l’équipe nationale',
                  image: true,
                  child: Image(image: _bg, fit: BoxFit.cover),
                ),
              );
            },
          ),

          // (Optionnel) Logo centré en Hero pour transition vers Auth
          // Center(
          //   child: Hero(
          //     tag: 'fsf-logo',
          //     child: Image.asset(
          //       'assets/img/federation.png',
          //       width: 120,
          //       height: 120,
          //     ),
          //   ),
          // ),

          // Slogan en bas
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.9,
              child: Text(
                'Go GAINDE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: .4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
