import 'dart:convert';

import 'package:fanexp/entity/UserEntity.dart';
//import 'package:front/constante.dart';
import 'package:fanexp/entity/OtpEntity.dart';
import 'package:fanexp/entity/OtpResponseEntity.dart';
import 'package:fanexp/entity/UserResponseEntity.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

String urlBase =
    "https://go-gainde-layendiayedevpro-dev.apps.rm3.7wse.p1.openshiftapps.com";

String urlRessource = '/api/v1/mobile/auth';

class UtilisateurService {
  Future<Map<String, dynamic>> sendOtp(UserEntity user) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$urlBase$urlRessource/send-otp'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "first_name": user.firstName,
          "last_name": user.lastName,
          "dateNaissance": user.dateNaissance,
          "phoneNumber": user.phoneNumber,
          "latitude": user.latitude,
          "longitude": user.longitude,
        }),
      );
      var otp = json.decode(response.body);
      print(response);
      print(otp);

      return otp;
    } catch (e) {
      print("details de l'erreur");
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(OtpEntity otpCode) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$urlBase$urlRessource/verify-otp'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"otpId": otpCode.otpId, "code": otpCode.code}),
      );
      var isVerified = json.decode(response.body);
      print(isVerified);

      return isVerified;
    } catch (e) {
      print("details de l'erreur");
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> register(double otpId, String codeSecret) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$urlBase$urlRessource/register'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"otpId": otpId, "codeSecret": codeSecret}),
      );
      var userResponse = json.decode(response.body);
      return userResponse;
    } catch (e) {
      print("details de l'erreur");
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> login(
    String phoneNumber,
    String codeSecret,
  ) async {
    try {
      //String urlRegister =;
      http.Response response = await http.post(
        Uri.parse('$urlBase$urlRessource/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "numeroTelephone": phoneNumber,
          "codeSecret": codeSecret,
        }),
      );
      var userResponse = json.decode(response.body);
      //print(data);

      return userResponse;
    } catch (e) {
      print("details de l'erreur");
      print(e);
      return {};
    }
  }
}
