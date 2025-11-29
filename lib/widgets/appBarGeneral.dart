import 'package:flutter/material.dart';
import '../../constants/colors/main_color.dart';

class AppBarGeneral extends StatelessWidget implements PreferredSizeWidget {
  const AppBarGeneral({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(1);

  @override
  Widget build(BuildContext context) {
    return Container(color: gaindeGreen);
  }
}
