import 'package:fanexp/screens/navigation/nav_helpers.dart';
import 'package:fanexp/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

// Écrans
import 'package:fanexp/screens/home/homepage.dart';
import 'package:fanexp/screens/timeline/timelinePage.dart';
import 'package:fanexp/screens/match/matchHub.dart';
import 'package:fanexp/screens/fanzone/fanzone.dart';
import 'package:fanexp/screens/profil/profil.dart';
import 'package:fanexp/screens/shop/shop.dart';
import 'package:fanexp/screens/player/playerAnalytics.dart';
import 'package:fanexp/screens/prediction/predictReco.dart';

/// ===============================
/// 🎨 Palette Go Gaïndé (Sénégal)
/// ===============================
const gaindeGreen = Color(0xFF007A33); // Vert Sénégal
const gaindeRed = Color(0xFFE31E24); // Rouge passion
const gaindeGold = Color(0xFFFFD100); // Or
const gaindeWhite = Color(0xFFFFFFFF); // Blanc pur
const gaindeInk = Color(0xFF70726e); // Noir profond
const gaindeBg = Color(0xFFF6F8FB); // Fond doux

// Déclinaisons douces (pour fonds / badges / hover)
const gaindeGreenSoft = Color(0xFFE6F4EE);
const gaindeGoldSoft = Color(0xFFFFF4CC);
const gaindeLine = Color(0xFFE8ECF3);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() => const [
    HomePage(), // 0
    TimelinePage(), // 1
    MatchHub(), // 2
    Fanzone(), // 3
    // Profil(), // 4
    PlayerAnalytics(),
    // Shop(),
    // PredictionReco(),
    SizedBox.shrink(), // 5: dummy pour l’onglet "Plus"
  ];

  List<PersistentBottomNavBarItem> _items(BuildContext context) => [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home_outlined),
      title: "Accueil",
      activeColorPrimary: gaindeGreen,
      inactiveColorPrimary: gaindeInk,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.timeline_outlined),
      title: "Timeline",
      activeColorPrimary: gaindeGreen,
      inactiveColorPrimary: gaindeInk,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.sports_soccer_outlined),
      title: "Match",
      activeColorPrimary: gaindeGreen,
      inactiveColorPrimary: gaindeInk,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.group_outlined),
      title: "FanZone",
      activeColorPrimary: gaindeGreen,
      inactiveColorPrimary: gaindeInk,
    ),

    PersistentBottomNavBarItem(
      icon: const Icon(Icons.bar_chart),
      title: "Stats",
      activeColorPrimary: gaindeGreen,
      inactiveColorPrimary: gaindeInk,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.grid_view_rounded),
      title: "Plus",
      activeColorPrimary: gaindeGreen,
      inactiveColorPrimary: gaindeInk,
      onPressed: (ctx) => _openMoreSheet(context),
    ),
  ];

  void _openMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: false,
      backgroundColor: gaindeWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: gaindeLine,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.grid_view_rounded, color: gaindeGreen),
                  SizedBox(width: 8),
                  Text(
                    "Plus",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: gaindeInk,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: gaindeGreenSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: gaindeGreen, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Accès rapide aux autres modules Go Gaïndé",
                        style: TextStyle(color: gaindeInk),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              _sheetItem(
                context,
                icon: Icons.shopping_bag_outlined,
                iconBg: gaindeGoldSoft,
                iconColor: gaindeGold,
                label: "Boutique",

                onTap: () {
                  Navigator.pop(context); // fermer le sheet
                  _controller.index = 0; // aller sur "Accueil" (écran non-vide)
                  Future.microtask(() {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const Shop(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  });
                },
              ),

              // _sheetItem(
              //   context,
              //   icon: Icons.insights_outlined,
              //   iconBg: gaindeGreenSoft,
              //   iconColor: gaindeGreen,
              //   label: "Analytics Joueurs",
              //   onTap: () => _push(context, const PlayerAnalytics()),
              // ),
              _sheetItem(
                context,
                icon: Icons.psychology_alt_outlined,
                iconBg: Color(0xFFFFE8E8), // soft red
                iconColor: gaindeRed,
                label: "Prédictions & Recos",
                onTap: () {
                  Navigator.pop(context); // fermer le sheet
                  _controller.index = 0; // aller sur "Accueil" (écran non-vide)
                  Future.microtask(() {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const PredictionReco(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  });
                },
              ),
              _sheetItem(
                context,
                icon: Icons.settings,
                iconBg: gaindeBg, // soft red
                iconColor: gaindeInk,
                label: "Paramètres",
                onTap: () {
                  Navigator.pop(context); // fermer le sheet
                  _controller.index = 0; // aller sur "Accueil" (écran non-vide)
                  Future.microtask(() {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: const Settings(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                  });
                },
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  Widget _sheetItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconBg,
    required Color iconColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, color: gaindeInk),
      onTap: () {
        Navigator.pop(context);
        _push(context, const SizedBox.shrink()); // petit délai esthétique
        Future.delayed(const Duration(milliseconds: 60), onTap);
      },
    );
  }

  void _push(BuildContext context, Widget page) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: page,
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // Léger dégradé en fond pour une touche “premium”
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, -1),
          end: Alignment(0, 0.8),
          colors: [gaindeBg, gaindeWhite],
        ),
      ),
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _items(context),

        backgroundColor: gaindeWhite,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        handleAndroidBackButtonPress: true,
        navBarStyle: NavBarStyle.style6,

        decoration: const NavBarDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          colorBehindNavBar: gaindeBg,
        ),
      ),
    );
  }
}
