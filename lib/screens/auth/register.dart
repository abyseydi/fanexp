// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_final_fields
import 'dart:convert';
import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fanexp/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/screens/home/home.dart';
// import 'package:fanexp/screens/login/login-Register.dart';
// import 'package:fanexp/screens/login/login.dart';
// import 'package:fanexp/screens/services/auth.services.dart';
// import 'package:fanexp/screens/services/signalement.services.dart';
import 'package:fanexp/widgets/AlertAndLoaderCustom.dart';
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          (selectedStep < 2)
              ? Container(
                  width: mediaWidth(context) / 1.2,
                  child: RoundedButton(
                    press: () async {
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
                          });
                        }
                      }
                    },
                    text: (selectedStep == 2) ? 'TERMINER' : 'SUIVANT  ',
                  ),
                )
              : _submitForm(),
          (selectedStep == 0)
              ? Container(
                  width: mediaWidth(context) / 1.2,
                  margin: EdgeInsets.only(top: 10),
                  child: RoundedTwoButton(
                    color: Colors.white,
                    press: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      ),
                    },
                    text: "ANNULER",
                  ),
                )
              : Container(
                  width: mediaWidth(context) / 1.2,
                  margin: EdgeInsets.only(top: 10),
                  child: RoundedTwoButton(
                    color: Colors.white,
                    press: () => onStepCancel(),
                    text: 'PRÉCEDENT',
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
      child: RoundedButton(
        color: Colors.white,
        text: 'CONNEXION',
        press: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          var number = indicator.phoneNumber.toString();
          final isValid = formKey.currentState!.validate();

          // if (isValid || isvalidPrevious) {
          //   try {
          //     showAlertDialog(context);

          //     var result = await AuthService.signup(
          //       lastName: _lastName.toString(),
          //       firstName: _firstName.toString(),
          //       localityId: dropdownvalue,
          //       phoneNumber: number,
          //       password: otpController.text,
          //     );
          //     Navigator.pop(context);
          //     _savePassword(otpController.text);
          //     _savePhoneNumber(number);
          //     final Map<String, dynamic> parsed = json.decode(result);

          //     setState(() {
          //       // _saveToken(parsed['token']);
          //       _saveUserId(parsed['user']['_id'].toString());
          //       _saveFirstName(parsed['user']['firstName']);
          //       _saveLastName(parsed['user']['lastName']);
          //     });
          //     // ignore: use_build_context_synchronously
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) => Login(haveNumber: false),
          //       ),
          //     );
          //     return result;
          //   } on SocketException {
          //     Navigator.pop(context);
          //     onAlertErrorButtonPressed(
          //       context,
          //       Text('translation(context).erreur'),
          //       Text('translation(context).serveur_inaccessible'),
          //       "",
          //       false,
          //     );
          //   } catch (e) {
          //     Navigator.pop(context);
          //     final Map<String, dynamic> parsed = json.decode(
          //       e.toString().substring(11),
          //     );
          //     var status = parsed['status'];
          //     if (status == 409 || status == 404) {
          //       onAlertErrorButtonPressed(
          //         context,
          //         Text('translation(context).erreur'),
          //         parsed['message'],
          //         "",
          //         false,
          //       );
          //     } else {
          //       Navigator.pop(context);
          //       onAlertErrorButtonPressed(
          //         context,
          //         'translation(context).echoue',
          //         'translation(context).echec_inscription',
          //         "",
          //         false,
          //       );
          //     }
          //   }
          // }
        }, //isChecked
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGeneral(),
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
                    child: Image(image: AssetImage("assets/images/logo.png")),
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
                  _buildDivider(mainColor),
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
                            child: StepsIndicator(
                              selectedStep: selectedStep,
                              nbSteps: nbSteps,
                              doneLineColor: mainColor,
                              doneStepColor: mainColor,
                              undoneLineColor: mainColor,
                              lineLength: 25,
                              doneStepWidget: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: softPrimaryColor,
                                ),
                                child: Center(
                                  child: Icon(Icons.check, color: mainColor),
                                ),
                              ),
                              selectedStepWidget: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: softPrimaryColor,
                                ),
                                child: Center(
                                  child: Icon(Icons.check, color: mainColor),
                                ),
                              ),
                              unselectedStepWidget: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: mainColor,
                                ),
                                child: Center(
                                  child: Icon(Icons.clear, color: mainColor),
                                ),
                              ),
                              lineLengthCustomStep: [
                                StepsIndicatorCustomLine(nbStep: 3, length: 40),
                              ],
                              enableLineAnimation: true,
                              enableStepAnimation: true,
                            ),
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
                                                      'Nom Complet',
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
                                              NameTextField(
                                                'Entrez votre nom complet',
                                                nameController,
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
                                              FutureBuilder(
                                                future:
                                                    zone, // Remplacez par votre propre future qui récupère les données
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                            color: mainColor,
                                                            strokeWidth: 1,
                                                          ),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Center(
                                                      child: Text(
                                                        'Erreur: ${snapshot.error}',
                                                      ),
                                                    );
                                                  } else {
                                                    List<dynamic> zones =
                                                        snapshot.data
                                                            as List<dynamic>;

                                                    return Column(
                                                      children: [
                                                        TypeAheadField(
                                                          emptyBuilder:
                                                              (
                                                                context,
                                                              ) => const Text(
                                                                'Aucune localité n\'a été trouvée.',
                                                              ),
                                                          builder:
                                                              (
                                                                context,
                                                                controller,
                                                                focusNode,
                                                              ) {
                                                                return TextField(
                                                                  controller:
                                                                      controller,
                                                                  focusNode:
                                                                      focusNode,
                                                                  autofocus:
                                                                      true,
                                                                  decoration: InputDecoration(
                                                                    hintText:
                                                                        'Veuillez sélectionner une localité',
                                                                    contentPadding: const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          20.0, // Adjust the vertical padding for height
                                                                      horizontal:
                                                                          15,
                                                                    ),
                                                                    fillColor:
                                                                        generalBackground,
                                                                    filled:
                                                                        true,
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                );
                                                              },
                                                          controller:
                                                              TextEditingController(
                                                                text: dropdownvalue2
                                                                    .toString(),
                                                              ),
                                                          suggestionsCallback: (pattern) async {
                                                            return zones
                                                                .where(
                                                                  (
                                                                    zone,
                                                                  ) => zone['label']
                                                                      .toLowerCase()
                                                                      .contains(
                                                                        pattern
                                                                            .toLowerCase(),
                                                                      ),
                                                                )
                                                                .toList();
                                                          },
                                                          itemBuilder:
                                                              (
                                                                context,
                                                                suggestion,
                                                              ) {
                                                                return ListTile(
                                                                  title: Text(
                                                                    suggestion['label']
                                                                        .toString(),
                                                                  ),
                                                                );
                                                              },
                                                          onSelected: (suggestion) {
                                                            setState(() {
                                                              dropdownvalue =
                                                                  suggestion['_id']
                                                                      .toString();
                                                              dropdownvalue2 =
                                                                  suggestion['label']
                                                                      .toString();
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }
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
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                ),
                                                // height: 60,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextFormField(
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      controller:
                                                          birthdayController,
                                                      validator:
                                                          birthdayValidator,
                                                      readOnly: true,
                                                      decoration: InputDecoration(
                                                        fillColor:
                                                            generalBackground,
                                                        filled: true,
                                                        border:
                                                            InputBorder.none,
                                                        hintText: 'JJ/MM/AAAA',
                                                        hintStyle: TextStyle(
                                                          fontFamily:
                                                              'Josefin Sans',
                                                        ),
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                    Radius.circular(
                                                                      5,
                                                                    ),
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            ),
                                                      ),
                                                      onTap: () async {
                                                        DateTime?
                                                        pickedDate = await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime(
                                                            1900,
                                                          ),
                                                          firstDate: DateTime(
                                                            1900,
                                                          ),
                                                          lastDate:
                                                              DateTime.now(),
                                                          builder: (context, child) {
                                                            return Theme(
                                                              data: ThemeData.light().copyWith(
                                                                colorScheme: ColorScheme.light(
                                                                  // change the border color
                                                                  primary:
                                                                      mainColor,
                                                                  // change the text color
                                                                  onSurface:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                // button colors
                                                                buttonTheme: ButtonThemeData(
                                                                  colorScheme:
                                                                      ColorScheme.light(
                                                                        primary:
                                                                            Colors.green,
                                                                      ),
                                                                ),
                                                              ),
                                                              child: child!,
                                                            );
                                                          },
                                                        );
                                                        if (pickedDate !=
                                                            null) {
                                                          String formattedDate =
                                                              DateFormat(
                                                                'dd-MM-yyyy',
                                                              ).format(
                                                                pickedDate,
                                                              );

                                                          setState(() {
                                                            birthdayController
                                                                    .text =
                                                                formattedDate;
                                                            birthdayDate =
                                                                pickedDate;

                                                            //set output date to TextField value.
                                                          });
                                                        } else {}
                                                      },
                                                    ),
                                                  ],
                                                ),
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
                                                        color: textBlackColor,
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
                                                    color: textInputTitleColor,
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
                                                      color: textBlackColor,
                                                    ),
                                                    labelStyle: TextStyle(
                                                      color: textBlackColor,
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
                                                                  textBlackColor,
                                                            ),
                                                          ),
                                                          // InkWell(
                                                          //   onTap: () {
                                                          //     AssetsAudioPlayer.newPlayer().open(
                                                          //       Audio(
                                                          //         "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav",
                                                          //       ),
                                                          //       autoStart: true,
                                                          //       showNotification:
                                                          //           true,
                                                          //     );
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
                                                    Expanded(
                                                      flex: 2,
                                                      child: IconButton(
                                                        icon: Icon(
                                                          _obscureText
                                                              ? Icons.visibility
                                                              : Icons
                                                                    .visibility_off,
                                                        ),
                                                        color: mainColor,
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
