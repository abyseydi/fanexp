// import 'package:flutter/material.dart';
// import 'package:go_tickets/widgets/account_deletion.dart';
// import 'package:go_tickets/widgets/newPopup.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:go_tickets/widgets/wave_launch_url_popup.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:go_tickets/constants/colors/main_color.dart';

// bool isDark = false;
// var alertStyle = AlertStyle(
//   backgroundColor: isDark ? blackColor : appBackgroundColor,
//   titleStyle: TextStyle(color: isDark ? appBackgroundColor : blackColor),
//   descStyle: TextStyle(color: isDark ? appBackgroundColor : blackColor),
// );

// onAlertLogout(context, bool dark, token) async {
//   isDark = dark;
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomDialogBox(
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

// onAlertAccountDeletion(context, bool dark, token) async {
//   isDark = dark;
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AccountDeletionDialogBox(
//           title: "Attention",
//           descriptions:
//               "Ceci entraîne la suppression définitive de votre compte ainsi que toutes vos données. Voulez-vous confirmer ?",
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
//           text: "Cliquez ici",
//           route: route,
//           img: Icon(Icons.info, color: redColor, size: 100),
//           isLogout: false,
//           textTwo: "",
//           isSuccess: false,
//           isBio: false,
//           isSuccessLoan: false,
//           number: '',
//         );
//       });
// }

// // onAlertConfirmation(context, bool dark, token, name, phone, sendedAmount,
// //     receivedAmount, fees) async {
// //   isDark = dark;
// //   showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return ConfirmTransactionDialogBox(
// //           phone: phone,
// //           name: name,
// //           sendedAmount: sendedAmount.toString(),
// //           receivedAmount: receivedAmount.toString(),
// //           fees: fees.toString(),
// //           text: "Oui",
// //           img: "assets/images/logo.png",
// //           textTwo: "Non",
// //           isSuccess: false,
// //           number: '',
// //         );
// //       });
// // }

// // onAlertConfirmationPayment(
// //   context,
// //   bool dark,
// //   token,
// //   name,
// //   phone,
// //   receivedAmount,
// // ) async {
// //   isDark = dark;
// //   showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return ConfirmPaymentDialogBox(
// //           phone: phone,
// //           name: name,
// //           receivedAmount: receivedAmount.toString(),
// //           text: "Oui",
// //           img: "assets/images/logo.png",
// //           textTwo: "Non",
// //           isSuccess: false,
// //           number: '',
// //         );
// //       });
// // }

// // onAlertLoyalty(context, bool dark, token, label, amount) async {
// //   isDark = dark;
// //   showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return ConfirmLoyaltyDialogBox(
// //           label: label,
// //           amount: amount.toString(),
// //         );
// //       });
// // }

// onAlertBio(context, bool dark, token) async {
//   isDark = dark;
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CustomDialogBox(
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

// onAlertLoan(context, bool dark, token) async {
//   isDark = dark;

//   Alert(
//     context: context,
//     type: AlertType.warning,
//     title: "Prêt",
//     desc: "Voulez-vous effectuer ce prêt ?",
//     style: alertStyle,
//     buttons: [
//       DialogButton(
//         child: Text(
//           "Oui",
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         ),
//         onPressed: () async {
//           Navigator.of(context, rootNavigator: true).pop(true);
//         },
//         color: Color.fromRGBO(0, 179, 134, 1.0),
//       ),
//       DialogButton(
//           child: Text(
//             "Non",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//           onPressed: () =>
//               {Navigator.of(context, rootNavigator: true).pop(true)})
//     ],
//   ).show();
// }

// final spinkit = SpinKitFadingCircle(
//   itemBuilder: (BuildContext context, int index) {
//     return Container(
//       decoration: new BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: borderGreyColor, width: 0.5),
//         image: new DecorationImage(
//           image: new AssetImage('assets/images/loader.png'),
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
//           text: "J'ai compris",
//           img: Icon(Icons.error, color: redColor, size: 110),
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
//           text: "J'ai compris",
//           img: Icon(Icons.check_circle, color: successColor, size: 110),
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
//   final alert = SpinKitFadingCircle(size: 100, color: redColor);
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
