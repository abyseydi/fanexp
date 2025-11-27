import 'dart:convert';
import 'package:fanexp/core/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TimelineRepository {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> getAllPostsRequest() async {
    final headers = await _getAuthHeaders();
    return await http.get(
      Uri.parse('$_baseUrl/api/v1/posts'),
      headers: headers,
    );
  }

  Future<http.Response> getPostDetailRequest(int postId) async {
    final headers = await _getAuthHeaders();
    return await http.get(
      Uri.parse('$_baseUrl/api/v1/posts/$postId'),
      headers: headers,
    );
  }

  Future<http.Response> toggleLikeRequest(int postId) async {
    final headers = await _getAuthHeaders();
    return await http.post(
      Uri.parse('$_baseUrl/api/v1/posts/$postId/like'),
      headers: headers,
    );
  }

  Future<http.Response> addCommentRequest(int postId, String content) async {
    final headers = await _getAuthHeaders();
    return await http.post(
      Uri.parse('$_baseUrl/api/v1/posts/$postId/comment'),
      headers: headers,
      body: json.encode({'content': content}),
    );
  }
}
