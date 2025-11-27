class CommentEntity {
  final int id;
  final String content;
  final DateTime dateCommentaire;
  final int auteurId;
  final String auteurUsername;

  CommentEntity({
    required this.id,
    required this.content,
    required this.dateCommentaire,
    required this.auteurId,
    required this.auteurUsername,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    return CommentEntity(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      dateCommentaire: json['dateCommentaire'] != null
          ? DateTime.parse(json['dateCommentaire'])
          : DateTime.now(),
      auteurId: json['auteurId'] ?? 0,
      auteurUsername: json['auteurUsername'] ?? '',
    );
  }
}
