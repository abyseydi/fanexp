import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:jeff_sa_gox_app_client/widgets/wave_launch_url_popup.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants/colors/main_color.dart';
// import 'newPopup.dart';

bool isDark = false;
// var alertStyle = AlertStyle(
//   backgroundColor: isDark ? textBlackColor : generalBackground,
//   titleStyle: TextStyle(color: isDark ? generalBackground : textBlackColor),
//   descStyle: TextStyle(color: isDark ? generalBackground : textBlackColor),
// );

// onAlertLogout(context, bool dark, token) async {
//   isDark = dark;
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return const CustomDialogBox(
//           title: "Déconnexion",
//           descriptions: "Voulez-vous quitter l'application",
//           text: "Oui",
//           img: "assets/images/logo.png",
//           isLogout: true,
//           textTwo: "Non",
//           isSuccess: false,
//           isBio: false,
//           isSuccessLoan: false,
//           number: '',
//         );
//       });
// }

// onAlertWavePayment(context, title, body, route, bool dark) async {
//   isDark = dark;
//   print("onAlertErrorButtonPressed " + body);
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomDialogWavePopup(
//           title: title,
//           descriptions: body,
//           text: 'CONFIRMER',
//           route: route,
//           img: Icon(Icons.info, color: mainColor, size: 100),
//           isLogout: false,
//           textTwo: "",
//           isSuccess: false,
//           isBio: false,
//           isSuccessLoan: false,
//           number: '',
//         );
//       });
// }

// onAlertBio(context, bool dark, token) async {
//   isDark = dark;
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return const CustomDialogBox(
//           title: "Connexion Biométrique",
//           descriptions:
//               "Voulez-vous utiliser votre emprunte pour se connecter à l'application ?",
//           text: "Oui",
//           img: "assets/images/toucher.png",
//           isLogout: true,
//           textTwo: "Non",
//           isSuccess: false,
//           isBio: true,
//           isSuccessLoan: false,
//           number: '',
//         );
//       });
// }

// final spinkit = SpinKitFadingCircle(
//   itemBuilder: (BuildContext context, int index) {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: textBlackColor, width: 0.5),
//         image: const DecorationImage(
//           image: AssetImage('assets/images/loader.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   },
// );

// onAlertErrorButtonPressed(context, title, body, route, bool dark) async {
//   isDark = dark;
//   print("onAlertErrorButtonPressed " + body);
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomDialogBox(
//           title: title,
//           descriptions: body,
//           text: 'j\'ai compris',
//           img: const Icon(Icons.error, color: mainColor, size: 110),
//           isLogout: false,
//           textTwo: "",
//           isSuccess: false,
//           isBio: false,
//           isSuccessLoan: false,
//           number: '',
//         );
//       });
// }

// onAlertSuccessButtonPressed(context, title, body, number, bool dark) async {
//   isDark = dark;
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomDialogBox(
//           title: title,
//           descriptions: body,
//           text: 'j\'ai compris',
//           img: const Icon(Icons.check_circle, color: successColor, size: 110),
//           isLogout: false,
//           textTwo: "",
//           isSuccess: true,
//           isBio: false,
//           isSuccessLoan: false,
//           number: number,
//         );
//       });
// }

// showAlertDialog(BuildContext context) {
//   const alert = SpinKitFadingCircle(size: 100, color: mainColor);
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
