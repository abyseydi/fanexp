import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';



import 'package:http/http.dart' as http;


String urlBase =
    "https://gogainde-back.apps.origins.heritage.africa";

String urlRessource = '/api/v1/mobile/matchs';

class MatchService {

  Future<List<Map<String, dynamic>>> getMatchs() async {
  try {
    
    var token = await getToken();
  
    final response = await http.get(
      Uri.parse('$urlBase$urlRessource'),
      headers: headerAuth(token),
    );

    List<dynamic> matchsData = json.decode(response.body);
    final List<Map<String, dynamic>> matchs = 
        matchsData.map((e) => Map<String, dynamic>.from(e)).toList();

    return matchs;
  } catch (e) {
    print("Erreur lors de la récupération des matchs : $e");
    return <Map<String, dynamic>>[];
  }
}

  Future<Map<String, dynamic>> getNextMatch() async {
  try {
    
    var token = await getToken();
  
    final response = await http.get(
      Uri.parse('$urlBase$urlRessource/next'),
      headers: headerAuth(token),
    );

   Map<String, dynamic> nextMatch = json.decode(response.body);
    
    print(nextMatch);
    return nextMatch;
  } catch (e) {
    print("Erreur lors de la récupération du match suivant : $e");
    return {};

  }
}

Future<Map<String, dynamic>> getNextMatchSenegal() async {
  try {
    
    var token = await getToken();
  
    final response = await http.get(
      Uri.parse('$urlBase$urlRessource/next/senegal'),
      headers: headerAuth(token),
    );

   Map<String, dynamic> nextMatchSenegal = json.decode(response.body);
   

    if (nextMatchSenegal.containsKey('matchId')) {
      saveMatchId(nextMatchSenegal['matchId']);
      print('matchId stocké : ${nextMatchSenegal['matchId']}');
    }

    return nextMatchSenegal;
  } catch (e) {
    print("Erreur lors de la récupération du match du senegal : $e");
    return {};

  }
}


  headerAuth(String token) {
  return {
    HttpHeaders.contentTypeHeader: "application/json",
    'Authorization': 'Bearer $token',
  };

}

Future<String> getToken () async {
   final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("Aucun token trouvé dans SharedPreferences !");
      return ""; 
    }
    return token;
}

/// Stocke le matchId dans les SharedPreferences
Future<void> saveMatchId(int matchId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('matchId', matchId);
}

/// Récupère le matchId depuis les SharedPreferences
Future<int?> getMatchId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('nextMatchId'); // retourne null si non défini
}
}