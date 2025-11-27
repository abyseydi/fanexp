import 'package:flutter/material.dart';

/// Palette Go Gaïndé (Sénégal + neutres)
const gaindeGreen = Color(0xFF007A33);
const gaindeGold = Color(0xFFFFD100);
const gaindeRed = Color(0xFFE31E24);
const gaindeInk = Color(0xFF0F1D13);
const gaindeBg = Color(0xFFF6F8FB);

const gaindeGreenSoft = Color(0xFFE5F3EC);
const gaindeGoldSoft = Color(0xFFFFF4C2);
const gaindeRedSoft = Color(0xFFFCE1E3);


ThemeData gaindeTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: gaindeBg,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: gaindeGreen,
          brightness: Brightness.light,
        ).copyWith(
          primary: gaindeGreen,
          secondary: gaindeGold,
          surface: Colors.white,
          onSurface: gaindeInk,
        ),
    fontFamily: 'Josefin Sans',
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: gaindeInk,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w800,
        color: gaindeInk,
        fontSize: 18,
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      side: BorderSide(color: gaindeInk.withOpacity(.12)),
      backgroundColor: gaindeGreenSoft,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
    ),
    // cardTheme: CardTheme(
    //   color: Colors.white,
    //   elevation: 0,
    //   surfaceTintColor: Colors.transparent,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    // ),
  );
}
