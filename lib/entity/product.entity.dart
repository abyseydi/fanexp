// lib/services/shop/product.entity.dart

class ProductInterface {
  final String id;
  final String nomProduit;
  final int prix;
  final String description;
  final String imageUrl;
  final String categorie;
  final int? newPrix;
  final List<String> taille;

  ProductInterface({
    required this.id,
    required this.nomProduit,
    required this.prix,
    required this.description,
    required this.imageUrl,
    required this.categorie,
    this.newPrix,
    required this.taille,
  });

  factory ProductInterface.fromJSON(Map<String, dynamic> json) {
    return ProductInterface(
      id: json['id']?.toString() ?? '',
      nomProduit: json['nomProduit']?.toString() ?? '',
      prix: (json['prix'] is int)
          ? json['prix'] as int
          : int.tryParse(json['prix']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      categorie: json['categorie']?.toString() ?? '',
      newPrix: json['newPrix'] == null
          ? null
          : ((json['newPrix'] is int)
                ? json['newPrix'] as int
                : int.tryParse(json['newPrix']?.toString() ?? '0') ?? 0),
      taille: (json['taille'] is List)
          ? (json['taille'] as List)
                .map((e) => e?.toString() ?? '')
                .where((e) => e.isNotEmpty)
                .toList()
          : <String>[],
    );
  }

  bool get hasDiscount =>
      newPrix != null && newPrix! > 0 && newPrix! < prix && newPrix != prix;
}

// class ProductInterface {
//   final String id;
//   final String nomProduit;
//   final int prix;
//   final int? newPrix;
//   final String description;
//   final String imageUrl;
//   final String categorie;
//   final List<String> taille;

//   // Champs optionnels pour l’UI (étoiles, badge promo)
//   final double rating;
//   final String? badge;

//   ProductInterface({
//     required this.id,
//     required this.nomProduit,
//     required this.prix,
//     required this.description,
//     required this.imageUrl,
//     required this.categorie,
//     required this.taille,
//     this.newPrix,
//     this.rating = 4.5,
//     this.badge,
//   });

//   factory ProductInterface.fromJSON(Map<String, dynamic> json) {
//     return ProductInterface(
//       id: json['id']?.toString() ?? '',
//       nomProduit: json['nomProduit']?.toString() ?? '',
//       prix: (json['prix'] is num) ? (json['prix'] as num).toInt() : 0,
//       newPrix: (json['newPrix'] is num)
//           ? (json['newPrix'] as num).toInt()
//           : null,
//       description: json['description']?.toString() ?? '',
//       imageUrl: json['imageUrl']?.toString() ?? '',
//       categorie: json['categorie']?.toString() ?? '',
//       taille: (json['taille'] is List)
//           ? List<String>.from((json['taille'] as List).map((e) => e.toString()))
//           : <String>[],
//       rating: (json['rating'] is num)
//           ? (json['rating'] as num).toDouble()
//           : 4.5, // défaut si pas renvoyé par l’API
//       badge: json['badge']?.toString(),
//     );
//   }
// }
