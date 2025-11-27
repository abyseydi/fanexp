class PostEntity {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final DateTime dateCreation;
  final int nbrLikes;
  final int nbrComments;
  final int nbrShares;
  final String auteurUsername;
  final bool utilisateurADejalike;

  PostEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.dateCreation,
    required this.nbrLikes,
    required this.nbrComments,
    this.nbrShares = 0,
    required this.auteurUsername,
    this.utilisateurADejalike = false,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      dateCreation: json['dateCreation'] != null
          ? DateTime.parse(json['dateCreation'])
          : DateTime.now(),
      nbrLikes: json['nbrLikes'] ?? 0,
      nbrComments: json['nbrComments'] ?? 0,
      nbrShares: json['nbrShares'] ?? 0,
      auteurUsername: json['auteurUsername'] ?? '',
      utilisateurADejalike: json['utilisateurADejalike'] ?? false,
    );
  }

  PostEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    DateTime? dateCreation,
    int? nbrLikes,
    int? nbrComments,
    int? nbrShares,
    String? auteurUsername,
    bool? utilisateurADejalike,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      dateCreation: dateCreation ?? this.dateCreation,
      nbrLikes: nbrLikes ?? this.nbrLikes,
      nbrComments: nbrComments ?? this.nbrComments,
      nbrShares: nbrShares ?? this.nbrShares,
      auteurUsername: auteurUsername ?? this.auteurUsername,
      utilisateurADejalike: utilisateurADejalike ?? this.utilisateurADejalike,
    );
  }
}
