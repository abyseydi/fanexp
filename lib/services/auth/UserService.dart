import 'dart:convert';
import 'dart:io';

import 'package:fanexp/entity/UserEntity.dart';
//import 'package:front/constante.dart';
import 'package:fanexp/entity/OtpEntity.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String urlBase = "https://gogainde-back.apps.origins.heritage.africa";

String urlRessource = '/api/v1/mobile/auth';

class UtilisateurService {
  Future<Map<String, dynamic>> sendOtp(UserEntity user) async {
    debugPrint(convertDate(user.dateNaissance!));

    try {
      http.Response response = await http.post(
        Uri.parse('$urlBase$urlRessource/send-otp'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": formatPhoneWith221(user.phoneNumber!),
          "prenom": user.firstName,
          "nom": user.lastName,
          "dateNaissance": convertDate(user.dateNaissance!),
          "phoneNumber": formatPhoneWith221(user.phoneNumber!),
          "latitude": user.latitude.toString(),
          "longitude": user.longitude.toString(),
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

  Future<Map<String, dynamic>> register(int otpId, String codeSecret) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$urlBase$urlRessource/register'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"otpId": otpId, "codeSecret": codeSecret}),
      );
      var userResponse = json.decode(response.body);
      print(userResponse);
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
          "numeroTelephone": formatPhoneWith221(phoneNumber),
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

  String convertDate(String inputDate) {
    // inputDate = "24/11/2025"
    DateTime date = DateFormat("dd/MM/yyyy").parse(inputDate);
    return DateFormat("yyyy-MM-dd").format(date);
  }

  String formatPhoneWith221(String phone) {
    phone = phone.trim().replaceAll(" ", "");

    if (phone.startsWith("+221")) {
      return phone;
    }

    if (phone.startsWith("0")) {
      phone = phone.substring(1);
    }

    return "+221$phone";
  }

  // Future<void> saveToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('token', token);
  // }
}

// headersAuth(String tokens) {
//   var headers = {
//     HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
//     'x-access-token': tokens,
//   };
//   return headers;
// }
Map<String, String> headersAuth(String? token) {
  final headers = <String, String>{
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  if (token != null && token.isNotEmpty) {
    headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  }

  return headers;
}
