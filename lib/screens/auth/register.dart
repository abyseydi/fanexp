import 'dart:async';

import 'package:fanexp/entity/OtpEntity.dart';
import 'package:fanexp/entity/OtpResponseEntity.dart';
import 'package:fanexp/entity/UserEntity.dart';
import 'package:fanexp/screens/auth/login.dart';
import 'package:fanexp/widgets/birthdatePicker.dart';
import 'package:fanexp/entity/locationEntity.dart';
import 'package:fanexp/widgets/osm_place_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/screens/home/home.dart' hide gaindeGreen, gaindeWhite;
import 'package:fanexp/services/auth/UserService.dart';

import 'package:fanexp/widgets/appBarGeneral.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:fanexp/widgets/name_text_field.dart';
import 'package:steps_indicator/steps_indicator.dart';
import '../../constants/size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/buttons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:fanexp/widgets/buttons.dart';

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
  TextEditingController codeSecretCtrl = TextEditingController();
  TextEditingController codeSecretCtrl2 = TextEditingController();
  final birthdayCtrl = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  bool step0_isnot_valid = false;
  bool step1_isnot_valid = false;
  bool step2_isnot_valid = false;


  final localiteCtrl = TextEditingController();

  late DateTime birthdayDate;
  var dropdownvalue;
  var dropdownvalue2 = '';
  late Future? zone;
  var otp;
  var verifiedOtp;
  int otpId = 0;

  bool _loading = false;
  bool _codeSent = false;
  int _secondsLeft = 0;
  Timer? _timer;

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
  bool verification_number_valid = false;
  // var fToast = FToast();
  double selectedOperatorFees = 0;
  var amountWithFees = 0.0;
  String _firstName = "";
  String _lastName = "";
  String _phoneNumber = "";
  String _dateNaissance = "";
  double _latitude = 0;
  double _longitude = 0;
  String _codeSecret = "";
  String _codeSecret2 = "";

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

  Widget _submitForm() {
    return SizedBox(
      width: mediaWidth(context) / 1.2,
      child: GlowButton(
        label: (selectedStep == 2) ? 'TERMINER' : 'SUIVANT  ',
        onTap: () async {
          _codeSecret = codeSecretCtrl.text.trim();
          _codeSecret2 = codeSecretCtrl2.text.trim();

          if(_codeSecret != _codeSecret2){
            // si les 2 code secrets ne sont pas identiques
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Les codes ne correspondent pas')),
            );
              return;
            }
          var resp = UtilisateurService().register(otpId, _codeSecret);

          final Map<String, dynamic> respData = await resp;

          

          if (respData.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Réponse vide du serveur')),
            );
            return;
          }

          if (!respData.containsKey('verified')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inscription echouee')),
            );
            return;
          }

          // if (respData['token'] == null ||
          //     respData['prenom'].toString().isEmpty) {
          //   ScaffoldMessenger.of(
          //     context,
          //   ).showSnackBar(const SnackBar(content: Text('OTP ID invalide')));
          //   return;
          // }

          //_saveToken(respData['verified']);
          if(respData['verified'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inscription réussie')),
            );
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => Login()));
          }
          
        },
        glowColor: gaindeGreen,
        bgColor: Colors.white,
        textColor: gaindeGreen,
      ),
    );
  }

  Future<void> saveFirstInfos() async {
    setState(() {
      _firstName = firstNameController.text.trim();
      _lastName = nameController.text.trim();
      //_localite = localiteCtrl.text.trim();
      _dateNaissance = birthdayCtrl.text.trim();
      _phoneNumber = phoneNumberController.text.trim();
    });

    UserEntity user = UserEntity(
      firstName: _firstName,
      lastName: _lastName,
      dateNaissance: _dateNaissance,
      phoneNumber: _phoneNumber,
      latitude: _latitude,
      longitude: _longitude,
    );

    debugPrint("envoi des donnees");

    try {
      otp = await UtilisateurService().sendOtp(user);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une erreur s'est produite ")),
      );
      debugPrint("Exception : $e");
    }

    debugPrint("Prénom : $_firstName");
    debugPrint("Nom : $_lastName");
    //debugPrint("Localité : $_localite");
    debugPrint("Date de naissance : $_dateNaissance");
    debugPrint("Téléphone : $_phoneNumber");
    debugPrint("Latitude : $_latitude, Longitude : $_longitude");

    debugPrint("otp : $otp");
  }

  _savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'phoneNumber';
    final value = phoneNumber;
    prefs.setString(key, value);
  }

  void _startCountdown([int seconds = 60]) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
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

  Future<void> _sendCode() async {
    if (phoneNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un numéro.')),
      );

      return;
    }
    saveFirstInfos();

    setState(() => _loading = true);
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _loading = false;
      _codeSent = true;
    });
    _startCountdown(60);
  }

  Future<void> _verifyCode() async {
    if (!_codeSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demandez le code d’abord.')),
      );
    }

    // final Map<String, dynamic> otpData = await otp;

    // otpId = otpData['otpId'];

    // OtpEntity otpEntity = OtpEntity(
    //   otpId: otpData['otpId'],
    //   code: codeCtrl.text.trim(),
    // );

    final Map<String, dynamic>? otpData = await otp;

    // 1️⃣ Vérifier si otpData est null
    if (otpData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune donnée reçue du serveur')),
      );
      return;
    }

    // 2️⃣ Vérifier si otpData est vide
    if (otpData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Réponse vide du serveur')));
      return;
    }

    // 3️⃣ Vérifier si otpId n’existe pas
    if (!otpData.containsKey('otpId')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP ID non trouvé dans la réponse')),
      );
      return;
    }

    // 4️⃣ Vérifier si otpId est null ou vide
    if (otpData['otpId'] == null || otpData['otpId'].toString().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP ID invalide')));
      return;
    }

    debugPrint("dans verify opt bien recu");


    // 👉 Si toutes les vérifications passent
    otpId = otpData['otpId'];
    

    OtpEntity otpEntity = OtpEntity(
      otpId: otpData['otpId'],
      code: codeCtrl.text.trim(),
    );

    verifiedOtp = UtilisateurService().verifyOtp(otpEntity);
    debugPrint("verification du otp...");

    final Map<String, dynamic> verificationData = await verifiedOtp;
    print("le numero");
    
    print("+221${phoneNumberController.text.trim()}");

    print("reponse recue");
    print(verificationData['phoneNumber']);

    if (verificationData['phoneNumber'] == "+221${phoneNumberController.text.trim()}") {
      verification_number_valid = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Numero validé.')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Numero non verifie')));
    }
  }

  @override
  void initState() {
    super.initState();
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
                    onTap: () async {
                      
                      step0_isnot_valid = firstNameController.text.isEmpty || nameController.text.isEmpty || localiteCtrl.text.isEmpty || birthdayCtrl.text.isEmpty;
                      step1_isnot_valid = phoneNumberController.text.isEmpty || codeCtrl.text.isEmpty;
                      final isValid = formKey.currentState!.validate();
                      
                      if (isValid || isvalidPrevious) {

                        if (selectedStep == 0 && step0_isnot_valid == false) {
                          print("on est sur le step 0");
                          setState(() {
                            selectedStep += 1;
                          });
                        } else if (selectedStep == 1 && step1_isnot_valid == false && verification_number_valid == true) {
                          setState(() {
                            selectedStep += 1;
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
                              doneLineColor: gaindeGreen,
                              doneStepColor: gaindeGreen,
                              undoneLineColor: gaindeGreen,
                              lineLength: 25,
                              doneStepWidget: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: gaindeGreen,
                                ),
                                child: Center(
                                  child: Icon(Icons.check, color: gaindeGreen),
                                ),
                              ),
                              selectedStepWidget: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: gaindeGreen,
                                ),
                                child: Center(
                                  child: Icon(Icons.check, color: gaindeGreen),
                                ),
                              ),
                              unselectedStepWidget: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: gaindeGreen,
                                ),
                                child: Center(
                                  child: Icon(Icons.clear, color: gaindeGreen),
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
                                                      'Prenom',
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
                                                      firstNameController,
                                                  hint: "prenom",
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'nom',
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
                                                  controller: nameController,
                                                  hint: "nom",
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
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 7),

                                              OSMPlacePicker(
                                                controller: localiteCtrl,
                                                onSelected: (name, coord) {
                                                  _latitude = coord.latitude;
                                                  _longitude = coord.longitude;
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
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 7),

                                              BirthdayPickerField(
                                                birthdayController:
                                                    birthdayCtrl,
                                                birthdayValidator:
                                                    birthdayValidator,
                                                gaindeWhite: gaindeWhite,
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
                                              SizedBox(height: 20),
                                              //debut
                                              Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        mediaWidth(context) *
                                                        0.5,
                                                    child: GlowButton(
                                                      textColor: Colors.white,

                                                      bgColor: gaindeGreen,
                                                      label: "Envoyer le code",
                                                      onTap: _sendCode,

                                                      glowColor: gaindeGreen,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  SizedBox(
                                                    width: 80,
                                                    child: Center(
                                                      child: Text(
                                                        '',
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(.6),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 16),

                                              _CodeField(
                                                controller: codeCtrl,
                                                enabled: _codeSent,
                                              ),

                                              const SizedBox(height: 20),
                                              SizedBox(
                                                width: double.infinity,
                                                child: FilledButton(
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        gaindeGreen,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: _loading
                                                      ? null
                                                      : _verifyCode,
                                                  child: _loading
                                                      ? const SizedBox(
                                                          height: 18,
                                                          width: 18,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        )
                                                      : const Text(
                                                          'Vérifier & Entrer',
                                                        ),
                                                ),
                                              ),

                                              //fin
                                            ],
                                          ),
                                        )
                                      : Container
                                      (
                                          child: Column(
                                            children: [
                                              SizedBox(height: 30),
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
                                                            "Entrez un code à 4 chiffres",
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
                                                    
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),

                                              //debut

                                              // fin
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
                                                  controller: codeSecretCtrl,
                                                ),
                                              ),
                                              SizedBox(height: 20,),
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
                                                            "Confirmez le code à 4 chiffres",
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
                                                  
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),

                                              //debut

                                              // fin
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
                                                  controller: codeSecretCtrl2,
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
  final bool enabled;
  const _CodeField({required this.controller, this.enabled = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
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

class _CodeField2 extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _CodeField2({required this.controller, this.enabled = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
