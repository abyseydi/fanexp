// lib/services/player/player.service.dart

import 'dart:convert';
import 'dart:io';

import 'package:fanexp/constants/network.dart'; // apiUrl, headersAuth
import 'package:fanexp/entity/player.entity.dart';
import 'package:fanexp/services/auth/UserService.dart';
import 'package:fanexp/services/auth/sharedPreferences.service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlayerService {
  final SharedPreferencesService _prefs = SharedPreferencesService();

  Future<List<PlayerEntity>> getPlayers() async {
    try {
      final token = await _prefs.getUserKeyValue('token');
      final headers = headersAuth(token);
      final uri = Uri.parse('$apiUrl/v1/players/allPlayers');

      final resp = await http.get(uri, headers: headers);

      if (resp.statusCode == 200) {
        final decoded = json.decode(resp.body);
        if (decoded is List) {
          return decoded
              .map((e) => PlayerEntity.fromJson(e as Map<String, dynamic>))
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
