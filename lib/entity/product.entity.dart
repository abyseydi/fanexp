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
    // price / newPrice sont des double côté backend, on les cast proprement
    final num? priceNum = json['price'] as num?;
    final num? newPriceNum = json['newPrice'] as num?;

    return ProductInterface(
      id: json['id']?.toString() ?? '',
      // le backend renvoie "label" ➜ on le mappe sur nomProduit
      nomProduit: json['label']?.toString() ?? '',
      prix: priceNum?.round() ?? 0, // 89.99 ➜ 90 par ex.
      description: json['description']?.toString() ?? '',
      // le backend renvoie "image" ➜ on le mappe sur imageUrl
      imageUrl: json['image']?.toString() ?? '',
      // le backend renvoie "category" ➜ on le mappe sur categorie
      categorie: json['category']?.toString() ?? '',
      // si newPrice == 0 ou null ➜ pas de promo
      newPrix: (newPriceNum != null && newPriceNum > 0)
          ? newPriceNum.round()
          : null,
      // le backend renvoie "size" ➜ on le mappe sur taille
      taille:
          (json['size'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          <String>[],
    );
  }

  bool get hasDiscount => newPrix != null && newPrix! < prix;

  @override
  String toString() {
    return 'ProductInterface(id: $id, nom: $nomProduit, prix: $prix, newPrix: $newPrix, categorie: $categorie)';
  }
}
