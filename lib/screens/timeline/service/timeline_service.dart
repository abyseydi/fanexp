import 'dart:convert';
import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_detail_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';
import 'package:fanexp/screens/timeline/repository/timeline_repository.dart';

class TimelineService {
  final TimelineRepository _repository;

  TimelineService(this._repository);

  /// Récupère tous les posts et les transforme en entités
  Future<List<PostEntity>> getAllPosts() async {
    try {
      final response = await _repository.getAllPostsRequest();

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PostEntity.fromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors du chargement des posts: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Service Error - getAllPosts: $e');
      rethrow;
    }
  }

  /// Récupère les détails d'un post avec ses commentaires
  Future<PostDetailEntity> getPostDetail(int postId) async {
    try {
      final response = await _repository.getPostDetailRequest(postId);

      if (response.statusCode == 200) {
        return PostDetailEntity.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Erreur lors du chargement du post: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Service Error - getPostDetail: $e');
      rethrow;
    }
  }

  /// Toggle le like d'un post
  /// Retourne true si le post est maintenant liké, false sinon
  Future<bool> toggleLike(int postId) async {
    try {
      final response = await _repository.toggleLikeRequest(postId);

      if (response.statusCode == 200) {
        final message = response.body;
        // L'API retourne "Liké avec succès" ou "Like retiré"
        return message.contains('Liké');
      } else {
        throw Exception('Erreur lors du like: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Service Error - toggleLike: $e');
      rethrow;
    }
  }

  /// Ajoute un commentaire à un post
  Future<CommentEntity> addComment(int postId, String content) async {
    try {
      // Validation métier
      if (content.trim().isEmpty) {
        throw Exception('Le commentaire ne peut pas être vide');
      }

      if (content.length > 500) {
        throw Exception('Le commentaire est trop long (max 500 caractères)');
      }

      final response = await _repository.addCommentRequest(postId, content);

      if (response.statusCode == 201) {
        return CommentEntity.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Erreur lors de l\'ajout du commentaire: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Service Error - addComment: $e');
      rethrow;
    }
  }

  /// Méthode utilitaire pour vérifier si un post peut être liké
  bool canLikePost(PostEntity post) {
    // Logique métier : par exemple, vérifier si le post n'est pas trop ancien
    final daysSinceCreation = DateTime.now()
        .difference(post.dateCreation)
        .inDays;
    return daysSinceCreation < 365; // Peut liker si moins d'un an
  }

  /// Méthode utilitaire pour vérifier si on peut commenter
  bool canCommentPost(PostEntity post) {
    final daysSinceCreation = DateTime.now()
        .difference(post.dateCreation)
        .inDays;
    return daysSinceCreation < 180; // Peut commenter si moins de 6 mois
  }
}
