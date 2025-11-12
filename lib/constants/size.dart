import 'package:flutter/material.dart';

double mediaWidth(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return size.width;
}

double mediaHeight(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return size.height;
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 50;
}
