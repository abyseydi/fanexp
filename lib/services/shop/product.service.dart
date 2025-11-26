import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fanexp/entity/product.entity.dart';
import 'package:fanexp/services/auth/sharedPreferences.service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fanexp/constants/network.dart';
import 'package:http/http.dart' as http;

List<ProductInterface>? allProducts;

class ProductService {
  final SharedPreferencesService preferencesService =
      SharedPreferencesService();

  Future<List<ProductInterface>> getProducts() async {
    try {
      final token = await preferencesService.getUserKeyValue('token');
      final headers = headersAuth(token);

      final uri = Uri.parse('$apiUrl/v1/mobile/produits');
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final products = parsedData(response.body);
        allProducts = products;
        return products;
      } else {
        // 401, 500, etc.
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on SocketException {
      await EasyLoading.showError(
        'Erreur internet',
        duration: const Duration(seconds: 5),
        dismissOnTap: true,
      );
      throw Exception('Erreur réseau');
    } catch (e) {
      throw Exception('Erreur getProducts(): $e');
    }
  }

  static List<ProductInterface> parsedData(String responseBody) {
    final decoded = json.decode(responseBody);

    if (decoded is List) {
      return decoded
          .map((e) => ProductInterface.fromJSON(e as Map<String, dynamic>))
          .toList();
    }

    if (decoded is Map<String, dynamic>) {
      final dynamic data = decoded['data'] ?? decoded['content'];
      if (data is List) {
        return data
            .map((e) => ProductInterface.fromJSON(e as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Format de réponse inattendu pour les produits');
  }
}

Map<String, String> headersAuth(String? token) {
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
}
