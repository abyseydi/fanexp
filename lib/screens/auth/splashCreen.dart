import 'dart:async';
//import 'package:jeff_sa_gox_app_client/screens/onboarding/login.dart';
import 'package:fanexp/screens/auth/auth.dart';
import 'package:flutter/material.dart';
// import 'package:jeff_sa_gox_app_client/screens/login/login-Signin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(
        seconds: 3,
      ), // Temps d'affichage du splash screen (3 secondes dans cet exemple)
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Auth()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png', width: 150, height: 150),
              SizedBox(height: 20),
              CircularProgressIndicator(), // Vous pouvez utiliser un indicateur de chargement ici
            ],
          ),
        ),
      ),
    );
  }
}
