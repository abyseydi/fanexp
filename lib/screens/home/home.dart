// import 'dart:async';
// import 'package:fanexp/screens/home/homepage.dart';
// import 'package:fanexp/screens/timeline/timelinePage.dart';
// import 'package:fanexp/screens/profil/profil.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// // import 'package:fanexp/screens/chat/chat.dart';
// // import 'package:fanexp/screens/profil.dart';
// // import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import '../../constants/colors/main_color.dart';

// final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//   @override
//   HomeScreenState createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   final PersistentTabController _controller = PersistentTabController(
//     initialIndex: 0,
//   );

//   final bool _dark = false;
//   bool haveProduct = false;
//   bool isCommingBag = false;
//   int counter = 0;
//   bool active = true;
//   double currency = 0.0;
//   String currencyId = "";
//   var token = "";
//   String userId = '';
//   late Timer timer;
//   int selectedPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     setState(() {});
//     WidgetsBinding.instance.addObserver(this);

//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         //_read();
//       });
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive) {
//       active = false;
//     }
//     if (state == AppLifecycleState.resumed) {
//       counter = 0;
//       active = true;
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void deactivate() {
//     // TODO: implement deactivate
//     super.deactivate();
//   }

//   Brightness _getBrightness() {
//     return _dark ? Brightness.dark : Brightness.light;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(brightness: _getBrightness()),
//       child: Scaffold(
//         body: Container(
//           child: PersistentTabView(
//             context,
//             controller: _controller,
//             screens: _buildScreens(),
//             items: _navBarsItems(),
//             // confineInSafeArea: true,
//             backgroundColor: _dark
//                 ? textBlackColor
//                 : generalBackground, // Default is Colors.white.
//             handleAndroidBackButtonPress: true, // Default is true.
//             resizeToAvoidBottomInset:
//                 true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
//             stateManagement: true, // Default is true.
//             // hideNavigationBarWhenKeyboardShows:
//             //     true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
//             decoration: NavBarDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               colorBehindNavBar: Colors.white,
//             ),

//             // popAllScreensOnTapOfSelectedTab: true,
//             // popActionScreens: PopActionScreensType.all,
//             // itemAnimationProperties: const ItemAnimationProperties(
//             //   // Navigation Bar's items animation properties.
//             //   duration: Duration(milliseconds: 200),
//             //   curve: Curves.ease,
//             // ),
//             // screenTransitionAnimation: const ScreenTransitionAnimation(
//             //   // Screen transition animation on change of selected tab.
//             //   animateTabTransition: true,
//             //   curve: Curves.ease,
//             //   duration: Duration(milliseconds: 200),
//             // ),
//             navBarStyle: NavBarStyle.style1,
//             // Choose the nav bar style with this property.
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildScreens() {
//     return [const TimelinePage(), const HomePage(), const Profil()];
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.dynamic_feed_rounded),
//         title: 'TL',
//         activeColorPrimary: appMainColor(),
//         inactiveColorPrimary: textBlackColor,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.home),

//         title: 'Accueil',
//         activeColorPrimary: appMainColor(),
//         inactiveColorPrimary: textBlackColor,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Icons.person),

//         title: ("Profil"),
//         textStyle: TextStyle(color: generalBackground),
//         activeColorPrimary: appMainColor(),
//         inactiveColorPrimary: textBlackColor,
//       ),
//     ];
//   }
// }
// lib/navigation/gainde_nav.dart
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
    Profil(), // 4
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
      icon: const Icon(Icons.person_outline),
      title: "Profil",
      activeColorPrimary: gaindeGreen,
      inactiveColorPrimary: gaindeInk,
    ),
    // Onglet "Plus" (ouvre une bottom sheet)
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
                onTap: () => _push(context, const Shop()),
              ),
              _sheetItem(
                context,
                icon: Icons.insights_outlined,
                iconBg: gaindeGreenSoft,
                iconColor: gaindeGreen,
                label: "Analytics Joueurs",
                onTap: () => _push(context, const PlayerAnalytics()),
              ),
              _sheetItem(
                context,
                icon: Icons.psychology_alt_outlined,
                iconBg: Color(0xFFFFE8E8), // soft red
                iconColor: gaindeRed,
                label: "Prédictions & Recos",
                onTap: () => _push(context, const PredictionReco()),
              ),
              _sheetItem(
                context,
                icon: Icons.settings,
                iconBg: gaindeBg, // soft red
                iconColor: gaindeInk,
                label: "Paramètres",
                onTap: () => _push(context, const Settings()),
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
