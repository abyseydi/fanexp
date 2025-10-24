// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/constants/size.dart';
import 'package:fanexp/screens/auth/login.dart';
import 'package:fanexp/screens/auth/register.dart';
import 'package:flutter/material.dart';
// import 'package:jeff_sa_gox_app_client/constants/colors/main_color.dart';
// import 'package:jeff_sa_gox_app_client/constants/size.dart';
// import 'package:jeff_sa_gox_app_client/screens/login/login.dart';
// import 'package:jeff_sa_gox_app_client/screens/login/signin.dart';
import 'package:lottie/lottie.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  AnimationController? _controller;
  @override
  void initState() {
    super.initState();
  }

  Route _createRouteLog() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          Login(haveNumber: false),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  Route _createRouteSign() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Register(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png', width: 150, height: 150),
              SizedBox(height: 10),
              Container(
                child: Lottie.asset(
                  'assets/images/animation_lkej780o.json',
                  controller: _controller,
                  height: MediaQuery.of(context).size.height * 0.3,
                  animate: true,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: mediaWidth(context) * 0.4,
                child: Text(
                  "S’engager & agir pour sa communauté",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Josefin Sans', fontSize: 16),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     AssetsAudioPlayer.newPlayer().open(
              //       Audio(
              //           "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav"),
              //       autoStart: true,
              //       showNotification: true,
              //     );
              //   },
              //   child: Container(
              //     width: 40,
              //     height: 40,
              //     child: Image(
              //         image: AssetImage(
              //       "assets/images/Groupe 1002@3x.png",
              //     )),
              //   ),
              // ),
              SizedBox(height: 20),
              Container(
                height: 60,
                width: mediaWidth(context) * 0.85,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    side: BorderSide(color: mainColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(_createRouteSign());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'INSCRIPTION',
                        style: TextStyle(color: Colors.white),
                      ), // <-- Text
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          // AssetsAudioPlayer.newPlayer().open(
                          //   Audio(
                          //       "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav"),
                          //   autoStart: true,
                          //   showNotification: true,
                          // );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Image(
                            image: AssetImage(
                              "assets/images/Groupe 1002@3x.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 60,
                width: mediaWidth(context) * 0.85,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: mainColor,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: mainColor, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(_createRouteLog());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('CONNEXION'), // <-- Text
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          child: Image(
                            image: AssetImage(
                              "assets/images/Groupe 1002@3x.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
