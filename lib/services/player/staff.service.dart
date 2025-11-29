// // lib/services/staff/staff.service.dart

// import 'dart:convert';
// import 'dart:io';

// import 'package:fanexp/services/auth/UserService.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;

// import 'package:fanexp/constants/network.dart'; // apiUrl, headersAuth
// import 'package:fanexp/services/auth/sharedPreferences.service.dart';
// import 'package:fanexp/entity/staff.entity.dart';

// class StaffService {
//   final SharedPreferencesService _preferencesService =
//       SharedPreferencesService();

//   Future<List<StaffEntity>> getStaff() async {
//     try {
//       // Récupération du token
//       final token = await _preferencesService.getUserKeyValue('token');
//       final headers = headersAuth(token);

//       final uri = Uri.parse('$apiUrl/v1/vweb/staffs');

//       final response = await http.get(uri, headers: headers);

//       if (response.statusCode == 200) {
//         final body = response.body;

//         final List<dynamic> data = json.decode(body) as List<dynamic>;

//         final staffList = data
//             .map((e) => StaffEntity.fromJson(e as Map<String, dynamic>))
//             .toList();

//         return staffList;
//       } else if (response.statusCode == 401) {
//         // Token invalide / expiré
//         await EasyLoading.showError(
//           'Session expirée (401). Merci de vous reconnecter.',
//           duration: const Duration(seconds: 4),
//           dismissOnTap: true,
//         );
//         throw Exception('Non autorisé (401) – token invalide ou expiré');
//       } else {
//         await EasyLoading.showError(
//           'Erreur serveur: ${response.statusCode}',
//           duration: const Duration(seconds: 4),
//           dismissOnTap: true,
//         );
//         throw Exception(
//           'Erreur serveur: ${response.statusCode} - ${response.body}',
//         );
//       }
//     } on SocketException {
//       await EasyLoading.showError(
//         'Erreur internet. Vérifiez votre connexion.',
//         duration: const Duration(seconds: 4),
//         dismissOnTap: true,
//       );
//       throw Exception('Erreur réseau (SocketException)');
//     } catch (e) {
//       throw Exception('Erreur getStaff(): $e');
//     }
//   }
// }

// lib/services/player/player.service.dart

import 'dart:convert';
import 'dart:io';

import 'package:fanexp/constants/network.dart'; // apiUrl, headersAuth
import 'package:fanexp/entity/staff.entity.dart';
import 'package:fanexp/services/auth/UserService.dart';
import 'package:fanexp/services/auth/sharedPreferences.service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class StaffService {
  final SharedPreferencesService _prefs = SharedPreferencesService();

  Future<List<StaffEntity>> getStaff() async {
    try {
      final token = await _prefs.getUserKeyValue('token');
      final headers = headersAuth(token);
      final uri = Uri.parse('$apiUrl/v1/web/staffs');

      final resp = await http.get(uri, headers: headers);

      if (resp.statusCode == 200) {
        final decoded = json.decode(resp.body);
        if (decoded is List) {
          return decoded
              .map((e) => StaffEntity.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Format JSON inattendu (liste attendue)');
        }
      } else {
        throw Exception(
          'Erreur serveur (${resp.statusCode}): ${resp.body.toString()}',
        );
      }
    } on SocketException {
      await EasyLoading.showError(
        "Problème de connexion internet",
        duration: const Duration(seconds: 4),
        dismissOnTap: true,
      );
      rethrow;
    } catch (e) {
      throw Exception('Erreur getPlayers(): $e');
    }
  }
}
