import 'package:fanexp/screens/timeline/entity/post_entity.dart';
import 'package:fanexp/screens/timeline/service/timeline_service.dart';
import 'package:flutter/material.dart';

class TimelineController extends ChangeNotifier {
  final TimelineService _service;

  TimelineController(this._service);

  List<PostEntity> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<PostEntity> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Charge tous les posts
  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _posts = await _service.getAllPosts();
      _error = null;
    } catch (e) {
      _error = 'Erreur de chargement: $e';
      _posts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle le like d'un post avec mise à jour optimiste
  Future<void> toggleLike(int postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final oldPost = _posts[index];
    final wasLiked = oldPost.utilisateurADejalike;

    // Mise à jour optimiste (UI réactive immédiatement)
    _posts[index] = oldPost.copyWith(
      utilisateurADejalike: !wasLiked,
      nbrLikes: wasLiked ? oldPost.nbrLikes - 1 : oldPost.nbrLikes + 1,
    );
    notifyListeners();

    try {
      final isNowLiked = await _service.toggleLike(postId);

      // Vérification que l'état correspond (sécurité)
      if (isNowLiked != _posts[index].utilisateurADejalike) {
        _posts[index] = oldPost.copyWith(
          utilisateurADejalike: isNowLiked,
          nbrLikes: isNowLiked ? oldPost.nbrLikes + 1 : oldPost.nbrLikes - 1,
        );
        notifyListeners();
      }
    } catch (e) {
      // Rollback en cas d'erreur
      _posts[index] = oldPost;
      notifyListeners();
      rethrow;
    }
  }

  /// Incrémente le compteur de commentaires (appelé depuis PostDetailPage)
  void incrementCommentCount(int postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        nbrComments: _posts[index].nbrComments + 1,
      );
      notifyListeners();
    }
  }

  /// Vérifie si on peut liker un post
  bool canLikePost(int postId) {
    final post = _posts.firstWhere(
      (p) => p.id == postId,
      orElse: () => _posts.first,
    );
    return _service.canLikePost(post);
  }
}
