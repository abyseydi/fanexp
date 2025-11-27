import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_detail_entity.dart';
import 'package:fanexp/screens/timeline/service/timeline_service.dart';
import 'package:flutter/material.dart';

class PostDetailController extends ChangeNotifier {
  final TimelineService _service;
  final int postId;

  PostDetailController(this._service, this.postId);

  PostDetailEntity? _post;
  bool _isLoading = false;
  bool _isAddingComment = false;
  String? _error;

  PostDetailEntity? get post => _post;
  bool get isLoading => _isLoading;
  bool get isAddingComment => _isAddingComment;
  String? get error => _error;

  /// Charge les détails du post
  Future<void> loadPostDetail() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _post = await _service.getPostDetail(postId);
      _error = null;
    } catch (e) {
      _error = 'Erreur: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle le like avec mise à jour optimiste
  Future<void> toggleLike() async {
    if (_post == null) return;

    final wasLiked = _post!.utilisateurADejalike;

    // Mise à jour optimiste
    _post = PostDetailEntity(
      id: _post!.id,
      title: _post!.title,
      description: _post!.description,
      imageUrl: _post!.imageUrl,
      category: _post!.category,
      dateCreation: _post!.dateCreation,
      nbrLikes: wasLiked ? _post!.nbrLikes - 1 : _post!.nbrLikes + 1,
      nbrComments: _post!.nbrComments,
      nbrShares: _post!.nbrShares,
      auteurUsername: _post!.auteurUsername,
      utilisateurADejalike: !wasLiked,
      commentaires: _post!.commentaires,
    );
    notifyListeners();

    try {
      await _service.toggleLike(postId);
    } catch (e) {
      // Rollback
      _post = PostDetailEntity(
        id: _post!.id,
        title: _post!.title,
        description: _post!.description,
        imageUrl: _post!.imageUrl,
        category: _post!.category,
        dateCreation: _post!.dateCreation,
        nbrLikes: wasLiked ? _post!.nbrLikes + 1 : _post!.nbrLikes - 1,
        nbrComments: _post!.nbrComments,
        nbrShares: _post!.nbrShares,
        auteurUsername: _post!.auteurUsername,
        utilisateurADejalike: wasLiked,
        commentaires: _post!.commentaires,
      );
      notifyListeners();
      rethrow;
    }
  }

  /// Ajoute un commentaire avec mise à jour en temps réel
  Future<CommentEntity> addComment(String content) async {
    if (_post == null) throw Exception('Post non chargé');

    // Vérification via service
    if (!_service.canCommentPost(_post!)) {
      throw Exception('Les commentaires sont désactivés pour ce post');
    }

    _isAddingComment = true;
    notifyListeners();

    try {
      final newComment = await _service.addComment(postId, content);

      // Mise à jour immédiate de l'UI
      _post = PostDetailEntity(
        id: _post!.id,
        title: _post!.title,
        description: _post!.description,
        imageUrl: _post!.imageUrl,
        category: _post!.category,
        dateCreation: _post!.dateCreation,
        nbrLikes: _post!.nbrLikes,
        nbrComments: _post!.nbrComments + 1,
        nbrShares: _post!.nbrShares,
        auteurUsername: _post!.auteurUsername,
        utilisateurADejalike: _post!.utilisateurADejalike,
        commentaires: [..._post!.commentaires, newComment],
      );

      return newComment;
    } finally {
      _isAddingComment = false;
      notifyListeners();
    }
  }
}
