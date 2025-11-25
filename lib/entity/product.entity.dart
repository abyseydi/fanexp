class ProductInterface {
  var id;

  var imageUrl;
  var libelle;
  var prix;
  var newPrix;
  var taille;

  ProductInterface({id, imageUrl, libelle, prix, newPrix, taille});
  factory ProductInterface.fromJSON(Map<String, dynamic> json) {
    return ProductInterface(
      id: json['_id'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      libelle: json['libelle'] ?? "",
      prix: json['prix'] ?? "",
      newPrix: json['newPrix'] ?? "",
      taille: json['taille'] ?? "",
    );
  }
}
