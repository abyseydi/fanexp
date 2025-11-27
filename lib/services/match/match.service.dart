import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';



import 'package:http/http.dart' as http;


String urlBase =
    "https://gogainde-back.apps.origins.heritage.africa";

String urlRessource = '/api/v1/mobile';

class MatchService {

  Future<List<Map<String, dynamic>>> getMatchs() async {
  try {
    
    var token = await getToken();
  
    final response = await http.get(
      Uri.parse('$urlBase$urlRessource/matchs'),
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
}