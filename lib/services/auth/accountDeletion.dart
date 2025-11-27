// import 'dart:convert';
// import 'dart:io';

// import 'package:fanexp/constants/size.dart';
// import 'package:fanexp/screens/ticket/ticketing.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class AccountDeletionDialogBox extends StatefulWidget {
//   final String title, descriptions, text, textTwo, number;
//   final dynamic img;
//   final bool isLogout, isSuccess, isBio;
//   final bool isSuccessLoan;
//   const AccountDeletionDialogBox({
//     required this.isBio,
//     required this.title,
//     required this.descriptions,
//     required this.text,
//     required this.img,
//     required this.isLogout,
//     required this.textTwo,
//     required this.isSuccess,
//     required this.number,
//     required this.isSuccessLoan,
//   });

//   @override
//   _AccountDeletionDialogBoxState createState() =>
//       _AccountDeletionDialogBoxState();
// }

// class _AccountDeletionDialogBoxState extends State<AccountDeletionDialogBox> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool? _canCheckBiometrics;
//   // List<BiometricType>? _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;

//   _saveBio(bool isUseBio) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'isUseBio';
//     final value = isUseBio;
//     prefs.setBool(key, value);
//     print('saved $value');
//   }

//   _saveShowPopup(bool showPopup) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'showPopup';
//     final value = showPopup;
//     prefs.setBool(key, value);
//     print('saved $value');
//   }

//   void initState() {
//     super.initState();

//     auth.isDeviceSupported().then(
//       (isSupported) => setState(
//         () => _supportState = isSupported
//             ? _SupportState.supported
//             : _SupportState.unsupported,
//       ),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(Constants.padding),
//       ),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }

//   contentBox(context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           height: mediaHeight(context) * 0.32,
//           padding: EdgeInsets.only(
//             left: Constants.padding,
//             top: Constants.avatarRadius + 10,
//             right: Constants.padding,
//             bottom: Constants.padding,
//           ),
//           margin: EdgeInsets.only(top: Constants.avatarRadius + 20),
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(Constants.padding),
//           ),
//           child: !widget.isLogout
//               ? Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     SizedBox(height: 10),
//                     Text(
//                       widget.title,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       widget.descriptions,
//                       style: TextStyle(fontSize: 13),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 10),
//                     Align(
//                       alignment: Alignment.center,
//                       child: GlowButton(
//                         label: widget.text,
//                         glowColor: gaindeLine,
//                         bgColor: gaindeGreen,
//                         color: appMainColor(),
//                         textColor: appBackgroundColor,
//                         onTap: () {
//                           if (widget.isSuccess) {
//                             Navigator.of(context).pop();
//                             if (widget.isSuccessLoan) {}
//                           } else {
//                             Navigator.of(context).pop();
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 )
//               : Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Text(
//                       widget.title,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Text(
//                       widget.descriptions,
//                       style: TextStyle(fontSize: 14),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.bottomRight,
//                             child: RoundedTwoButton(
//                               text: widget.textTwo,
//                               color: Colors.white,
//                               textColor: redColor,
//                               press: () {
//                                 if (widget.isBio) {
//                                   _saveShowPopup(true);
//                                   Navigator.of(context).pop();
//                                 } else {
//                                   Navigator.of(context).pop();
//                                 }
//                               },
//                             ),
//                           ),
//                           flex: 6,
//                         ),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.bottomLeft,
//                             child: RoundedTwoButton(
//                               text: widget.text,
//                               color: redColor,
//                               textColor: appBackgroundColor,
//                               press: () async {
//                                 if (widget.isBio == false) {
//                                   try {
//                                     EasyLoading.show(status: 'Chargement...');
//                                     var result =
//                                         await AuthService.deleteAccount();
//                                     // var resultState = result
//                                     //     .toString()
//                                     //     .substring(3, result.toString().length);
//                                     final Map<String, dynamic> parsed = json
//                                         .decode(result);
//                                     //print("RESUKLT DEL $parsed");
//                                     setState(() {
//                                       EasyLoading.dismiss();
//                                     });

//                                     EasyLoading.showInfo(
//                                       'Votre compte ainsi que vos données ont été supprimés avec succès.',
//                                     );
//                                     Navigator.pushAndRemoveUntil(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (BuildContext context) =>
//                                             new Login(haveNumber: false),
//                                       ),
//                                       (Route route) => false,
//                                     );

//                                     return result;
//                                   } on SocketException {
//                                     //Navigator.pop(context);
//                                     EasyLoading.dismiss();
//                                     onAlertErrorButtonPressed(
//                                       context,
//                                       "Erreur",
//                                       "Veuillez vérifier votre connexion internet",
//                                       "",
//                                       false,
//                                     );
//                                   } catch (e) {
//                                     // Navigator.of(context, rootNavigator: true)
//                                     // .pop();
//                                     //Navigator.pop(context);
//                                     EasyLoading.dismiss();
//                                     onAlertErrorButtonPressed(
//                                       context,
//                                       "Erreur",
//                                       "Numéro ou code pin incorrect",
//                                       "",
//                                       false,
//                                     );
//                                     // }
//                                   }
//                                 } else {
//                                   setState(() {
//                                     // _authenticateWithBiometrics();
//                                     // Navigator.of(context).pop();
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                           flex: 6,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//         ),
//       ],
//     );
//   }
// }

// enum _SupportState { unknown, supported, unsupported }
