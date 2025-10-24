import 'package:flutter/material.dart';

MaterialColor primaryColor = MaterialColor(0xFF357964, customcolor);

//The purple is the main color
appMainColor() {
  //return Colors.purple[400];
  return primaryColor;
}

//background general color
var generalBackground = const Color(0xFFFFFFFF);
const mainColor = Color(0xFF357964);
const softPrimaryColor = Color.fromARGB(30, 60, 130, 109);
const softColor = Color(0xFFEDF8F9);
const verySoftPrimaryColor = Color(0xFFEAE7F9);
const inputBackgroundColor = Color(0xff3939390d);
const textBlackColor = Color(0xFF363636);
const cardColor = Color(0xFFF5F8F7);
const textInputTitleColor = Color(0xFF363636);
const redColor = Color(0xFFED4137);
const borderColor = Color(0XFF707070);
const k_darkGreen = Color(0xFF357964);
const k_darkGrey = Color(0xFF868686);

const k_softGreen = Color.fromARGB(30, 60, 130, 109);
const k_lightGrey = Color(0xFFaab5c2);
const percentColor = Color(0XFFE49339);
const dividerColor = Color(0XFF519D86);
const somoColor = Color.fromARGB(249, 248, 228, 205);
const k_Grey = Color.fromARGB(255, 204, 221, 216);
// The success color
const successColor = Color.fromRGBO(62, 192, 172, 1);

// warningColor
const warningColor = Color.fromRGBO(254, 229, 98, 1);

// failureColor
const failureColor = Color.fromRGBO(250, 105, 85, 1);

Map<int, Color> customcolor = {
  50: const Color.fromRGBO(239, 71, 111, .1),
  100: const Color.fromRGBO(239, 71, 111, .2),
  200: const Color.fromRGBO(239, 71, 111, .3),
  300: const Color.fromRGBO(239, 71, 111, .4),
  400: const Color.fromRGBO(239, 71, 111, .5),
  500: const Color.fromRGBO(239, 71, 111, .6),
  600: const Color.fromRGBO(239, 71, 111, .7),
  700: const Color.fromRGBO(239, 71, 111, .8),
  800: const Color.fromRGBO(239, 71, 111, .9),
  900: const Color.fromRGBO(239, 71, 111, 1),
};
