import 'package:fanexp/app.dart';
import 'package:flutter/material.dart';

//les routes
Map<String, Widget Function(BuildContext)> routes(BuildContext context) {
  return {
    "": (context) => MyApp(),
    // "/signup": (context) => Signup(),
    // //"forgot": (context) => Forgot(),
    // "/userHome": (context) => HomeScreen(),
    // "/hospitals": (context) => Hospitals(),
    // "/loyalty": (context) => LoyaltyHome(),
    // "/home": (context) => HomePage(),
    // "forgot": (context) => Forgot(),
    // "verify_your_mail": (context) => VerifyYourEmail(),
    // "change_password": (context) => ChangePassword(),
  };
}
