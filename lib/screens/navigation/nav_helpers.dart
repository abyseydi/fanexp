import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

void goWithNav(BuildContext context, Widget page) {
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: page,
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}
