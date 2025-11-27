import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';

class PostDetailEntity extends PostEntity {
  final List<CommentEntity> commentaires;

  PostDetailEntity({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.category,
    required super.dateCreation,
    required super.nbrLikes,
    required super.video,
    required super.nbrComments,
    super.nbrShares,
    required super.auteurUsername,
    super.utilisateurADejalike,
    required this.commentaires,
  });

  factory PostDetailEntity.fromJson(Map<String, dynamic> json) {
    return PostDetailEntity(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      video: json['video'] ?? '',
      category: json['category'] ?? '',
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'])
          : DateTime.now(),
      nbrLikes: json['nbrLikes'] ?? 0,
      nbrComments: json['nbrComments'] ?? 0,
      nbrShares: json['nbrShares'] ?? 0,
      auteurUsername: json['auteurUsername'] ?? '',
      utilisateurADejalike: json['utilisateurADejalike'] ?? false,
      commentaires:
          (json['commentaires'] as List<dynamic>?)
              ?.map((c) => CommentEntity.fromJson(c))
              .toList() ??
          [],
    );
  }
}
