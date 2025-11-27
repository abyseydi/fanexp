import 'dart:convert';
import 'package:fanexp/core/utils/api_config.dart';
import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_detail_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';
import 'package:fanexp/screens/timeline/service/i_timeline_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TimeLineService implements ITimelineService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<PostEntity>> getAllPosts() async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/posts'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PostEntity.fromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors du chargement des posts: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur getAllPosts: $e');
      rethrow;
    }
  }

  @override
  Future<PostDetailEntity> getPostDetail(int postId) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/posts/$postId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return PostDetailEntity.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Erreur lors du chargement du post: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur getPostDetail: $e');
      rethrow;
    }
  }

  @override
  Future<bool> toggleLike(int postId) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/posts/$postId/like'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final message = response.body;
        return message.contains('Liké');
      } else {
        throw Exception('Erreur lors du like: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur toggleLike: $e');
      rethrow;
    }
  }

  @override
  Future<CommentEntity> addComment(int postId, String content) async {
    try {
      final headers = await getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/posts/$postId/comment'),
        headers: headers,
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 201) {
        return CommentEntity.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Erreur lors de l\'ajout du commentaire: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur addComment: $e');
      rethrow;
    }
  }
}
