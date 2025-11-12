import 'package:flutter/material.dart';

const gaindeGreen = Color(0xFF007A33);
const gaindeRed = Color(0xFFE31E24);
const gaindeGold = Color(0xFFFFD100);
const gaindeWhite = Color(0xFFFFFFFF);
const gaindeBlack = Color(0xFF0F0F0F);
const gaindeGray = Color(0xFFF6F8FB);
const gaindeDarkGray = Color(0xFF424242);

ThemeData gaindeTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: gaindeGreen,
      brightness: Brightness.light,
      primary: gaindeGreen,
      secondary: gaindeGold,
      onPrimary: gaindeWhite,
      onSecondary: gaindeBlack,
    ),
    scaffoldBackgroundColor: gaindeGray,
    appBarTheme: const AppBarTheme(
      backgroundColor: gaindeWhite,
      foregroundColor: gaindeBlack,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: base.textTheme.apply(
      fontFamily: 'Josefin Sans',
      bodyColor: gaindeBlack,
      displayColor: gaindeBlack,
    ),
  );
}
