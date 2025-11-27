import 'dart:convert';
import 'dart:io';



import 'package:http/http.dart' as http;


String urlBase =
    "https://gogainde-back.apps.origins.heritage.africa";

String urlRessource = '/api/v1/mobile';

class MatchService {

  Future<List<Map<String, dynamic>>> getMatchs() async {
  try {
    
    var token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIrMjIxNzY0ODM3MDIyIiwiaWF0IjoxNzY0MTcxMzQ3LCJleHAiOjE3NjQyNTc3NDd9.TVxM_1ypCwmP7S3qDqqmUKfkvWQ8YSlbvqCcoJjmBUiYcGCyr5CUr2JpuK-KiG0o90lPb0z_-j386AqlOKjGTQ";

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
}