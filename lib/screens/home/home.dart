import 'dart:async';
import 'package:fanexp/screens/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:fanexp/screens/chat/chat.dart';
// import 'package:fanexp/screens/profil.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../../constants/colors/main_color.dart';

final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  final bool _dark = false;
  bool haveProduct = false;
  bool isCommingBag = false;
  int counter = 0;
  bool active = true;
  double currency = 0.0;
  String currencyId = "";
  var token = "";
  String userId = '';
  late Timer timer;
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    setState(() {});
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        //_read();
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      active = false;
    }
    if (state == AppLifecycleState.resumed) {
      counter = 0;
      active = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: _getBrightness()),
      child: Scaffold(
        body: Container(
          child: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            // confineInSafeArea: true,
            backgroundColor: _dark
                ? textBlackColor
                : generalBackground, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.

            // hideNavigationBarWhenKeyboardShows:
            //     true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Colors.white,
            ),

            // popAllScreensOnTapOfSelectedTab: true,
            // popActionScreens: PopActionScreensType.all,
            // itemAnimationProperties: const ItemAnimationProperties(
            //   // Navigation Bar's items animation properties.
            //   duration: Duration(milliseconds: 200),
            //   curve: Curves.ease,
            // ),
            // screenTransitionAnimation: const ScreenTransitionAnimation(
            //   // Screen transition animation on change of selected tab.
            //   animateTabTransition: true,
            //   curve: Curves.ease,
            //   duration: Duration(milliseconds: 200),
            // ),
            navBarStyle: NavBarStyle.style1,
            // Choose the nav bar style with this property.
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const Homepage(),
      //  const Chat(),
      //  const Profil()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        title: 'Accueil',
        activeColorPrimary: appMainColor(),
        inactiveColorPrimary: textBlackColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Image(
          image: AssetImage('assets/images/bubble-chat_2076218@3x.png'),
        ),
        title: 'Chat',
        activeColorPrimary: appMainColor(),
        inactiveColorPrimary: textBlackColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Image(
          image: AssetImage('assets/images/profile_3569815@3x.png'),
        ),
        title: ("Profil"),
        textStyle: TextStyle(color: generalBackground),
        activeColorPrimary: appMainColor(),
        inactiveColorPrimary: textBlackColor,
      ),
    ];
  }
}
