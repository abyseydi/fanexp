import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fanexp/services/auth/UserService.dart';
import 'package:fanexp/services/auth/sharedPreferences.service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fanexp/constants/functions.dart';
import 'package:fanexp/constants/network.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

dynamic allProducts;

class ProductService {
  SharedPreferencesService preferencesService = SharedPreferencesService();

  Future getProducts() async {
    try {
      var token = await preferencesService.getUserKeyValue('token');
      var headers = headersAuth(token);
      var response = await http.get(
        Uri.parse("$apiUrl/v1/mobile/produits"),
        headers: headers,
      );
      var productList = parsedData(response.body);
      allProducts = parsedData(response.body);

      return productList;
    } on SocketException {
      await EasyLoading.showError(
        "Erreur internet",
        duration: Duration(seconds: 5),
        dismissOnTap: true,
      );
    } catch (e) {
      throw Exception("$e");
    }
  }

  static parsedData(String responseBody) {
    final parsed = json.decode(responseBody);

    return parsed;
  }
}
