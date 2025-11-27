import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';

class GaindeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const GaindeAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      titleSpacing: 12,
      title: Row(
        children: [
          Image.asset('assets/img/launchericon.jpeg', height: 30),
          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: gaindeInk,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart_sharp, color: gaindeInk),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: gaindeInk),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person, color: gaindeInk),
        ),
      ],
      bottom: const TabBar(
        isScrollable: true,
        labelColor: gaindeInk,
        unselectedLabelColor: Colors.grey,
        indicatorColor: gaindeGreen,
        indicatorWeight: 3,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: [
          Tab(text: 'Fil Gaïndé'),
          Tab(text: 'Inside Training'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
