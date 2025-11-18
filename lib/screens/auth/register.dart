// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_final_fields
// import 'dart:convert';
// import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fanexp/screens/auth/login.dart';
import 'package:fanexp/widgets/birthdatePicker.dart';
// import 'package:fanexp/screens/home/homepage.dart'
//     hide gaindeWhite, gaindeGreen;
import 'package:fanexp/widgets/osm_place_picker.dart';
import 'package:fanexp/widgets/registerStepIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/screens/home/home.dart' hide gaindeGreen, gaindeWhite;
// import 'package:fanexp/screens/login/login-Register.dart';
// import 'package:fanexp/screens/login/login.dart';
// import 'package:fanexp/screens/services/auth.services.dart';
// import 'package:fanexp/screens/services/signalement.services.dart';
// import 'package:fanexp/widgets/AlertAndLoaderCustom.dart';
import 'package:fanexp/widgets/appBarGeneral.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:fanexp/widgets/name_text_field.dart';
// import 'package:fanexp/widgets/name_text_field2.dart';
import 'package:steps_indicator/steps_indicator.dart';
import '../../constants/size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/buttons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController localityExpendController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();
  final birthdayCtrl = TextEditingController();

  TextEditingController fullNameController = TextEditingController();
  final localiteCtrl = TextEditingController();

  late DateTime birthdayDate;
  var dropdownvalue;
  var dropdownvalue2 = '';
  late Future? zone;

  // SignalementServices zoneService = SignalementServices();

  String initialCountry = 'SN';
  PhoneNumber phoneText = PhoneNumber(isoCode: 'SN');
  bool isShowChar = true;
  int selectedStep = 0;
  int nbSteps = 3;
  var indicator = PhoneNumber();
  var indicator2 = PhoneNumber();
  String changePhone = "";
  bool isChecked = false;
  var currentTextPinOne = "";
  bool isShowCharConfirm = true;
  bool isvalidPrevious = false;
  bool _obscureText = true;
  // var fToast = FToast();
  double selectedOperatorFees = 0;
  var amountWithFees = 0.0;
  String _firstName = "";
  String _lastName = "";
  Brightness _getBrightness() {
    return Brightness.light;
  }

  final birthdayValidator = MultiValidator([
    RequiredValidator(errorText: "Champ obligatoire"),
    MinLengthValidator(1, errorText: "Au moins 3 chiffres"),
  ]);

  Container _buildDivider(color) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20, bottom: 0),
      width: double.infinity,
      height: 0.5,
      color: color,
    );
  }

  void _saveName() {
    String fullName = nameController.text.trim();
    List<String> nameParts = fullName.split(' ');

    if (nameParts.length == 2) {
      setState(() {
        _firstName = nameParts[0];
        _lastName = nameParts[1];
      });
    }
  }

  _savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'phoneNumber';
    final value = phoneNumber;
    prefs.setString(key, value);
  }

  _savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'password';
    final value = password;
    prefs.setString(key, value);
  }

  _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userId';
    final value = userId;
    prefs.setString(key, value);
  }

  _saveToken(String password) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = password;
    prefs.setString(key, value);
  }

  _saveFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'firstName';
    final value = firstName;
    prefs.setString(key, value);
  }

  _saveLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'lastName';
    final value = lastName;
    prefs.setString(key, value);
  }

  onStepCancel() {
    if (selectedStep == 0) {
      return;
    } else {
      setState(() {
        isvalidPrevious = true;
        selectedStep -= 1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // zone = zoneService.getAllAllReportingLocalite();
  }

  Route _createRouteToWelcomePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInBack;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Widget _bottomBar() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          (selectedStep < 2)
              ? Container(
                  width: mediaWidth(context) / 1.2,
                  child: GlowButton(
                    label: (selectedStep == 2) ? 'TERMINER' : 'SUIVANT  ',
                    // icon: Icons.navigate_next,
                    onTap: () async {
                      final isValid = formKey.currentState!.validate();
                      if (isValid || isvalidPrevious) {
                        if (selectedStep == 0) {
                          setState(() {
                            _saveName();
                            // isUploadOk = true;
                            selectedStep += 1;
                          });
                        } else if (selectedStep == 1) {
                          setState(() {
                            // isUploadOk = true;
                            selectedStep += 1;
                          });
                        } else if (selectedStep >= 1) {
                          setState(() {
                            // isUploadOk = true;
                            selectedStep += 1;

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          });
                        }
                      }
                    },
                    glowColor: gaindeGreen,
                    bgColor: Colors.white,
                    textColor: Colors.black,
                  ),
                )
              : _submitForm(),
          (selectedStep == 0)
              ? Container(
                  width: mediaWidth(context) / 1.2,
                  margin: EdgeInsets.only(top: 10),
                  child: OutlineSoftButton(
                    label: "ANNULER",
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      ),
                    },
                  ),
                )
              : Container(
                  width: mediaWidth(context) / 1.2,
                  margin: EdgeInsets.only(top: 10),
                  child: OutlineSoftButton(
                    label: "PRÉCEDENT",
                    onTap: () => {onStepCancel()},
                  ),
                ),
        ],
      ),
    );
  }

  Widget _submitForm() {
    return SizedBox(
      width: mediaWidth(context) / 1.2,
      //height: 48,
      child: GlowButton(
        label: (selectedStep == 2) ? 'TERMINER' : 'SUIVANT  ',
        onTap: () async {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Login()));
        },
        glowColor: gaindeGreen,
        bgColor: Colors.white,
        textColor: gaindeGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarGeneral(),
      backgroundColor: gaindeWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: mediaWidth(context) * 0.85,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  SizedBox(
                    width: mediaWidth(context) * 0.3,
                    child: Image(
                      image: AssetImage("assets/img/federation.png"),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'INSCRIPTION',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDivider(gaindeGreen),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            // child: StepsIndicator(
                            //   selectedStep: selectedStep,
                            //   nbSteps: nbSteps,
                            //   doneLineColor: gaindeGreen,
                            //   doneStepColor: gaindeGreen,
                            //   undoneLineColor: gaindeGreen,
                            //   lineLength: 25,
                            //   doneStepWidget: Container(
                            //     width: 30,
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: gaindeGreen,
                            //     ),
                            //     child: Center(
                            //       child: Icon(Icons.check, color: gaindeGreen),
                            //     ),
                            //   ),
                            //   selectedStepWidget: Container(
                            //     width: 30,
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: gaindeGreen,
                            //     ),
                            //     child: Center(
                            //       child: Icon(Icons.check, color: gaindeGreen),
                            //     ),
                            //   ),
                            //   unselectedStepWidget: Container(
                            //     width: 30,
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: gaindeGreen,
                            //     ),
                            //     child: Center(
                            //       child: Icon(Icons.clear, color: gaindeGreen),
                            //     ),
                            //   ),
                            //   lineLengthCustomStep: [
                            //     StepsIndicatorCustomLine(nbStep: 3, length: 40),
                            //   ],
                            //   enableLineAnimation: true,
                            //   enableStepAnimation: true,
                            // ),
                            child: RegisterStepsIndicator(),
                          ),
                          Form(
                            key: formKey,
                            child: Container(
                              width: mediaWidth(context) * 0.85,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (selectedStep == 0)
                                      ? Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 20),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Pseudo',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Josefin Sans',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              // NameTextField(
                                              //   'Entrez votre nom complet',
                                              //   nameController,
                                              // ),
                                              Container(
                                                // height: 30,
                                                // width: 60,
                                                child: AiTextField(
                                                  controller:
                                                      fullNameController,
                                                  hint: "pseudo",
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Localité',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Josefin Sans',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     AssetsAudioPlayer.newPlayer()
                                                    //         .open(
                                                    //           Audio(
                                                    //             "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav",
                                                    //           ),
                                                    //           autoStart: true,
                                                    //           showNotification:
                                                    //               true,
                                                    //         );
                                                    //   },
                                                    //   child: Container(
                                                    //     width: 40,
                                                    //     height: 40,
                                                    //     child: Image(
                                                    //       image: AssetImage(
                                                    //         "assets/images/Groupe 1002@3x.png",
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 7),

                                              // FutureBuilder(
                                              //   future:
                                              //       zone, // Remplacez par votre propre future qui récupère les données
                                              //   builder: (context, snapshot) {
                                              //     if (snapshot
                                              //             .connectionState ==
                                              //         ConnectionState.waiting) {
                                              //       return Center(
                                              //         child:
                                              //             CircularProgressIndicator(
                                              //               color: gaindeGreen,
                                              //               strokeWidth: 1,
                                              //             ),
                                              //       );
                                              //     } else if (snapshot
                                              //         .hasError) {
                                              //       return Center(
                                              //         child: Text(
                                              //           'Erreur: ${snapshot.error}',
                                              //         ),
                                              //       );
                                              //     } else {
                                              //       List<dynamic> zones =
                                              //           snapshot.data
                                              //               as List<dynamic>;

                                              //       return Column(
                                              //         children: [
                                              //           TypeAheadField(
                                              //             emptyBuilder:
                                              //                 (
                                              //                   context,
                                              //                 ) => const Text(
                                              //                   'Aucune localité n\'a été trouvée.',
                                              //                 ),
                                              //             builder:
                                              //                 (
                                              //                   context,
                                              //                   controller,
                                              //                   focusNode,
                                              //                 ) {
                                              //                   return TextField(
                                              //                     controller:
                                              //                         controller,
                                              //                     focusNode:
                                              //                         focusNode,
                                              //                     autofocus:
                                              //                         true,
                                              //                     decoration: InputDecoration(
                                              //                       hintText:
                                              //                           'Veuillez sélectionner une localité',
                                              //                       contentPadding: const EdgeInsets.symmetric(
                                              //                         vertical:
                                              //                             20.0, // Adjust the vertical padding for height
                                              //                         horizontal:
                                              //                             15,
                                              //                       ),
                                              //                       fillColor:
                                              //                           gaindeWhite,
                                              //                       filled:
                                              //                           true,
                                              //                       border:
                                              //                           InputBorder
                                              //                               .none,
                                              //                     ),
                                              //                   );
                                              //                 },
                                              //             controller:
                                              //                 TextEditingController(
                                              //                   text: dropdownvalue2
                                              //                       .toString(),
                                              //                 ),
                                              //             suggestionsCallback: (pattern) async {
                                              //               return zones
                                              //                   .where(
                                              //                     (
                                              //                       zone,
                                              //                     ) => zone['label']
                                              //                         .toLowerCase()
                                              //                         .contains(
                                              //                           pattern
                                              //                               .toLowerCase(),
                                              //                         ),
                                              //                   )
                                              //                   .toList();
                                              //             },
                                              //             itemBuilder:
                                              //                 (
                                              //                   context,
                                              //                   suggestion,
                                              //                 ) {
                                              //                   return ListTile(
                                              //                     title: Text(
                                              //                       suggestion['label']
                                              //                           .toString(),
                                              //                     ),
                                              //                   );
                                              //                 },
                                              //             onSelected: (suggestion) {
                                              //               setState(() {
                                              //                 dropdownvalue =
                                              //                     suggestion['_id']
                                              //                         .toString();
                                              //                 dropdownvalue2 =
                                              //                     suggestion['label']
                                              //                         .toString();
                                              //               });
                                              //             },
                                              //           ),
                                              //         ],
                                              //       );
                                              //     }
                                              //   },
                                              // ),
                                              OSMPlacePicker(
                                                controller: localiteCtrl,
                                                onSelected: (name, coord) {
                                                  print(
                                                    'Localité sélectionnée : $name (${coord.latitude}, ${coord.longitude})',
                                                  );
                                                },
                                              ),

                                              SizedBox(height: 20),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Date de naissance',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Josefin Sans',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     AssetsAudioPlayer.newPlayer()
                                                    //         .open(
                                                    //           Audio(
                                                    //             "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav",
                                                    //           ),
                                                    //           autoStart: true,
                                                    //           showNotification:
                                                    //               true,
                                                    //         );
                                                    //   },
                                                    //   child: Container(
                                                    //     width: 40,
                                                    //     height: 40,
                                                    //     child: Image(
                                                    //       image: AssetImage(
                                                    //         "assets/images/Groupe 1002@3x.png",
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 7),
                                              // Container(
                                              //   alignment: Alignment.center,
                                              //   decoration: BoxDecoration(
                                              //     boxShadow: [
                                              //       BoxShadow(
                                              //         color: Colors.grey
                                              //             .withOpacity(.35),
                                              //         blurRadius: 24,
                                              //         spreadRadius: 1,
                                              //       ),
                                              //     ],
                                              //   ),
                                              //   // height: 60,
                                              //   child: Column(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.center,
                                              //     children: [
                                              //       TextFormField(
                                              //         textAlignVertical:
                                              //             TextAlignVertical
                                              //                 .center,
                                              //         controller:
                                              //             birthdayController,
                                              //         validator:
                                              //             birthdayValidator,
                                              //         readOnly: true,
                                              //         decoration: InputDecoration(
                                              //           fillColor: gaindeWhite,
                                              //           filled: true,
                                              //           border:
                                              //               InputBorder.none,
                                              //           hintText: 'JJ/MM/AAAA',
                                              //           hintStyle: TextStyle(
                                              //             fontFamily:
                                              //                 'Josefin Sans',
                                              //           ),
                                              //           enabledBorder: const OutlineInputBorder(
                                              //             borderRadius:
                                              //                 BorderRadius.all(
                                              //                   Radius.circular(
                                              //                     5,
                                              //                   ),
                                              //                 ),
                                              //             borderSide: BorderSide(
                                              //               color: Colors
                                              //                   .transparent,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //         onTap: () async {
                                              //           DateTime?
                                              //           pickedDate = await showDatePicker(
                                              //             context: context,
                                              //             initialDate: DateTime(
                                              //               1900,
                                              //             ),
                                              //             firstDate: DateTime(
                                              //               1900,
                                              //             ),
                                              //             lastDate:
                                              //                 DateTime.now(),
                                              //             builder: (context, child) {
                                              //               return Theme(
                                              //                 data: ThemeData.light().copyWith(
                                              //                   colorScheme: ColorScheme.light(
                                              //                     // change the border color
                                              //                     primary:
                                              //                         gaindeGreen,
                                              //                     // change the text color
                                              //                     onSurface:
                                              //                         Colors
                                              //                             .black,
                                              //                   ),
                                              //                   // button colors
                                              //                   buttonTheme: ButtonThemeData(
                                              //                     colorScheme:
                                              //                         ColorScheme.light(
                                              //                           primary:
                                              //                               Colors.green,
                                              //                         ),
                                              //                   ),
                                              //                 ),
                                              //                 child: child!,
                                              //               );
                                              //             },
                                              //           );
                                              //           if (pickedDate !=
                                              //               null) {
                                              //             String formattedDate =
                                              //                 DateFormat(
                                              //                   'dd-MM-yyyy',
                                              //                 ).format(
                                              //                   pickedDate,
                                              //                 );

                                              //             setState(() {
                                              //               birthdayController
                                              //                       .text =
                                              //                   formattedDate;
                                              //               birthdayDate =
                                              //                   pickedDate;
                                              //             });
                                              //           } else {}
                                              //         },
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              BirthdayPickerField(
                                                birthdayController:
                                                    birthdayCtrl,
                                                birthdayValidator:
                                                    birthdayValidator,
                                                gaindeWhite:
                                                    gaindeWhite, // tes constantes si tu veux
                                                gaindeGreen: gaindeGreen,
                                              ),
                                            ],
                                          ),
                                        )
                                      : (selectedStep == 1)
                                      ? Container(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 20),
                                              Container(
                                                color: Colors.white,
                                                width:
                                                    mediaWidth(context) * 0.85,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Entrez votre numéro",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Josefin Sans',
                                                        fontSize: 18,
                                                        color: gaindeDarkGray,
                                                      ),
                                                    ),
                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     AssetsAudioPlayer.newPlayer()
                                                    //         .open(
                                                    //           Audio(
                                                    //             "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav",
                                                    //           ),
                                                    //           autoStart: true,
                                                    //           showNotification:
                                                    //               true,
                                                    //         );
                                                    //   },
                                                    //   child: Container(
                                                    //     width: 40,
                                                    //     height: 40,
                                                    //     child: Image(
                                                    //       image: AssetImage(
                                                    //         "assets/images/Groupe 1002@3x.png",
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 7.0,
                                                  right: 7,
                                                  top: 0,
                                                  bottom: 0,
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                ),
                                                width:
                                                    mediaWidth(context) * 0.85,
                                                height: 75,
                                                child: InternationalPhoneNumberInput(
                                                  onInputChanged:
                                                      (PhoneNumber number) {
                                                        indicator = number;
                                                        changePhone =
                                                            phoneNumberController
                                                                .text;
                                                      },
                                                  onInputValidated:
                                                      (bool value) {},
                                                  selectorConfig: SelectorConfig(
                                                    selectorType:
                                                        PhoneInputSelectorType
                                                            .BOTTOM_SHEET,
                                                  ),
                                                  ignoreBlank: false,
                                                  autoValidateMode:
                                                      AutovalidateMode.disabled,
                                                  selectorTextStyle: TextStyle(
                                                    color: gaindeDarkGray,
                                                  ),
                                                  initialValue: phoneText,
                                                  errorMessage:
                                                      'Numéro invalide',
                                                  textFieldController:
                                                      phoneNumberController,
                                                  formatInput: false,
                                                  autoFocus: false,
                                                  inputDecoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    hintText:
                                                        'Numéro de téléphone',
                                                    hintStyle: TextStyle(
                                                      fontFamily:
                                                          'Josefin Sans',
                                                      color: gaindeDarkGray,
                                                    ),
                                                    labelStyle: TextStyle(
                                                      color: gaindeDarkGray,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.0,
                                                              ),
                                                        ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onSaved:
                                                      (PhoneNumber number) {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              SizedBox(
                                                width:
                                                    mediaWidth(context) * 0.85,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 10,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Entrez votre mot de passe",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Josefin Sans',
                                                              fontSize: 18,
                                                              color:
                                                                  gaindeDarkGray,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          _obscureText
                                                              ? Icons.visibility
                                                              : Icons
                                                                    .visibility_off,
                                                        ),
                                                        color: gaindeGreen,
                                                        onPressed: () {
                                                          setState(() {
                                                            if (_obscureText) {
                                                              _obscureText =
                                                                  false;
                                                            } else {
                                                              _obscureText =
                                                                  true;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              // Container(
                                              //   padding: EdgeInsets.only(
                                              //     left: 7.0,
                                              //     right: 7,
                                              //     top: 0,
                                              //     bottom: 0,
                                              //   ),
                                              //   alignment: Alignment.center,
                                              //   decoration: BoxDecoration(
                                              //     border: Border.all(
                                              //       color: Colors.grey,
                                              //     ),
                                              //     borderRadius:
                                              //         BorderRadius.all(
                                              //           Radius.circular(8),
                                              //         ),
                                              //   ),
                                              //   width:
                                              //       mediaWidth(context) * 0.85,
                                              //   height: 75,
                                              //   child: NameTextField2(
                                              //     'mot de passe',
                                              //     otpController,
                                              //     _obscureText,
                                              //   ),
                                              // ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 7.0,
                                                  right: 7,
                                                  top: 0,
                                                  bottom: 0,
                                                ),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                ),
                                                width:
                                                    mediaWidth(context) * 0.85,
                                                height: 75,
                                                child: _CodeField(
                                                  controller: codeCtrl,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                top: 20,
                                bottom: 0,
                              ),
                              child: _bottomBar(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Vous avez déja un compte? ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'S\'identifier',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeField extends StatelessWidget {
  final TextEditingController controller;
  // final bool enabled;
  const _CodeField({
    required this.controller,
    // , this.enabled = false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      textAlign: TextAlign.center,
      style: const TextStyle(
        letterSpacing: 8,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: '— — — —',
        hintStyle: TextStyle(
          letterSpacing: 8,
          color: Colors.black.withOpacity(.25),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: gaindeGreen, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}
