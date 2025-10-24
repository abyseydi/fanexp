// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/screens/auth/register.dart';
import 'package:fanexp/screens/home/home.dart';
import 'package:fanexp/widgets/appBarGeneral.dart';
import 'package:fanexp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fanexp/screens/home.dart';
// import 'package:fanexp/screens/login/signin.dart';
// import 'package:fanexp/screens/services/auth.services.dart';
import 'package:fanexp/widgets/AlertAndLoaderCustom.dart';
// import 'package:fanexp/widgets/appBarGeneral.dart';
// import 'package:fanexp/widgets/name_text_field2.dart';
// import 'package:fanexp/widgets/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/size.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.haveNumber}) : super(key: key);
  final bool haveNumber;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String initialCountry = 'SN';
  PhoneNumber phoneText = PhoneNumber(isoCode: 'SN');
  bool isShowChar = true;
  int selectedStep = 0;
  int nbSteps = 2;
  var indicator = PhoneNumber();
  String changePhone = "";
  bool isChecked = false;
  //final int _currentStep = 0;
  var currentTextPinOne = "";
  bool isShowCharConfirm = true;
  bool isvalidPrevious = false;
  var fToast = FToast();
  var phoneNumber = "";
  bool status = false;
  bool _obscureText = true;

  _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'userId';
    final value = userId;
    prefs.setString(key, value);
    print('ID USER ' + value);
  }

  _savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'phoneNumber';
    final value = phoneNumber;
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

  _savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'password';
    final value = password;
    prefs.setString(key, value);
  }

  _saveToken(String password) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = password;
    prefs.setString(key, value);
  }

  Widget _submitForm() {
    return SizedBox(
      width: mediaWidth(context) * 0.85,
      //height: 48,
      child: (passwordController.toString().isNotEmpty)
          ? RoundedButton(
              color: Colors.white,
              text: 'SE CONNECTER',
              press: () async {
                print("press login");
                var number = indicator.phoneNumber.toString();
                var userPass = passwordController.text.toString();
                final isValid = formKey.currentState!.validate();

                // if (isValid || isvalidPrevious) {
                //   try {
                //     showAlertDialog(context);
                //     var result = await AuthService.login(
                //       phoneNumber: number,
                //       password: userPass,
                //     );
                //     var resultState = result
                //         .toString()
                //         .substring(3, result.toString().length);

                //     final Map<String, dynamic> parsed =
                //         json.decode(resultState);
                //     setState(() {
                //       // _saveUserId(parsed['user']['collectorInfo']['_id']);
                //       _saveToken(parsed['token']);
                //       _savePhoneNumber(parsed['user']['phoneNumber']);
                //       _savePassword(userPass);
                //       _saveUserId(parsed['user']['_id'].toString());
                //       _saveFirstName(parsed['user']['firstName']);
                //       _saveLastName(parsed['user']['lastName']);
                //     });
                //     Navigator.of(context).push(_createRoute());

                //     return result;
                //   } on SocketException {
                //     Navigator.pop(context);

                //     onAlertErrorButtonPressed(
                //         context, ' erreur', 'verifier_connexion', "", false);
                //   } catch (e) {
                //     print("erreur : ${e}");
                //     Navigator.of(context, rootNavigator: true).pop();
                //     //Navigator.pop(context);

                //     onAlertErrorButtonPressed(
                //         context, 'erreur', 'numero_pin_incorrect', "", false);
                //   }
                // }
              }, //isChecked
            )
          : RoundedTwoButton(
              color: mainColor,
              textColor: Colors.white,
              text: 'SE CONNECTER',
              press: () async {
                await _showToast('Veillez remplir les cellules', 0xFFFF0000);
              }, //isChecked
            ),
    );
  }

  _showToast(text, color) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning, color: Color(color)),
          SizedBox(width: 12.0),
          Text(text, style: TextStyle(color: appMainColor())),
        ],
      ),
    );

    fToast.showToast(
      child: Card(elevation: 3, child: toast),
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
  }

  _readPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'phoneNumber';
    final value = prefs.getString(key) ?? '';
    phoneNumber = value;
  }

  @override
  void initState() {
    super.initState();
    _readPhoneNumber();

    Future.delayed(const Duration(seconds: 0), () async {
      fToast = FToast();
      fToast.init(context);
      // });
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarGeneral(),
      body: Container(
        height: mediaHeight(context),
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          //padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 40),
                                        Container(
                                          height: 130,
                                          color: Colors.white,
                                          width: mediaWidth(context) * 0.3,
                                          child: Image.asset(
                                            "assets/images/logo.png",
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          color: Colors.white,
                                          width: mediaWidth(context) * 0.6,
                                          child: Text(
                                            'CONNEXION',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Josefin Sans',
                                              fontSize: 18,
                                              color: textBlackColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          color: Colors.white,
                                          width: mediaWidth(context) * 0.85,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Entrez votre numéro",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Josefin Sans',
                                                  fontSize: 18,
                                                  color: textBlackColor,
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     AssetsAudioPlayer
                                              //             .newPlayer()
                                              //         .open(
                                              //       Audio(
                                              //           "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav"),
                                              //       autoStart: true,
                                              //       showNotification:
                                              //           true,
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
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          width: mediaWidth(context) * 0.85,
                                          height: 75,
                                          child: InternationalPhoneNumberInput(
                                            onInputChanged:
                                                (PhoneNumber number) {
                                                  indicator = number;
                                                  changePhone =
                                                      phoneNumberController
                                                          .text;
                                                },
                                            onInputValidated: (bool value) {},
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
                                            errorMessage: 'Numéro invalide',
                                            textFieldController:
                                                phoneNumberController,
                                            formatInput: false,
                                            autoFocus: false,
                                            inputDecoration: InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintText: 'Numéro de téléphone',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Josefin Sans',
                                                color: textBlackColor,
                                              ),
                                              labelStyle: TextStyle(
                                                color: textBlackColor,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            onSaved: (PhoneNumber number) {},
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: mediaWidth(context) * 0.85,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 10,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Entrez le mot de passe",
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
                                                    //     AssetsAudioPlayer
                                                    //             .newPlayer()
                                                    //         .open(
                                                    //       Audio(
                                                    //           "assets/audios/mixkit-cool-impact-movie-trailer-2909.wav"),
                                                    //       autoStart: true,
                                                    //       showNotification:
                                                    //           true,
                                                    //     );
                                                    //   },
                                                    //   child: Container(
                                                    //     width: 40,
                                                    //     height: 40,
                                                    //     child: Image(
                                                    //         image:
                                                    //             AssetImage(
                                                    //       "assets/images/Groupe 1002@3x.png",
                                                    //     )),
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
                                                        : Icons.visibility_off,
                                                  ),
                                                  color: mainColor,
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_obscureText) {
                                                        _obscureText = false;
                                                      } else {
                                                        _obscureText = true;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Container(
                                //   padding: EdgeInsets.only(
                                //       left: 7.0, right: 7, top: 0, bottom: 0),
                                //   alignment: Alignment.center,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(
                                //         color: Colors.grey,
                                //       ),
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(8))),
                                //   width: mediaWidth(context) * 0.85,
                                //   height: 75,
                                //   child: NameTextField2('Mot de passe',
                                //       passwordController, _obscureText),
                                // ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                      top: 10,
                                      bottom: 0,
                                    ),
                                    child: _submitForm(),
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
                                              builder: (context) => Register(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Pas de compte? ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'S\'inscrire',
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
                            //)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
