// class StaffEntity {
//   final int id;
//   final String nomComplet;
//   final String postOccupe;
//   final String age;
//   final String nationalite;
//   final String nomme;
//   final String finDeContrat;
//   final String? photoUrl;

//   StaffEntity({
//     required this.id,
//     required this.nomComplet,
//     required this.postOccupe,
//     required this.age,
//     required this.nationalite,
//     required this.nomme,
//     required this.finDeContrat,
//     this.photoUrl,
//   });

//   factory StaffEntity.fromJson(Map<String, dynamic> json) {
//     return StaffEntity(
//       id: json['id'] is int
//           ? json['id'] as int
//           : int.tryParse(json['id'].toString()) ?? 0,
//       nomComplet: json['nomComplet'] ?? '',
//       postOccupe: json['postOccupe'] ?? '',
//       age: json['age']?.toString() ?? '-', // garde "-" si fourni
//       nationalite: json['nationalite'] ?? '',
//       nomme: json['nomme'] ?? '',
//       finDeContrat: json['finDeContrat'] ?? '',
//       photoUrl: json['photoUrl'], // peut être null
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'nomComplet': nomComplet,
//       'postOccupe': postOccupe,
//       'age': age,
//       'nationalite': nationalite,
//       'nomme': nomme,
//       'finDeContrat': finDeContrat,
//       'photoUrl': photoUrl,
//     };
//   }

//   @override
//   String toString() {
//     return 'StaffEntity(id: $id, nomComplet: $nomComplet, poste: $postOccupe, age: $age)';
//   }
// }

// lib/entity/staff.entity.dart
class StaffEntity {
  final int id;
  final String nomComplet;
  final String postOccupe;
  final String? age;
  final String nationalite;
  final String nomme;
  final String finDeContrat;
  final String? photoUrl;

  StaffEntity({
    required this.id,
    required this.nomComplet,
    required this.postOccupe,
    required this.age,
    required this.nationalite,
    required this.nomme,
    required this.finDeContrat,
    required this.photoUrl,
  });

  factory StaffEntity.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return StaffEntity(
      id: asInt(json['id']),
      nomComplet: json['nomComplet'] ?? '',
      postOccupe: json['postOccupe'] ?? '',
      age: json['age']?.toString(),
      nationalite: json['nationalite'] ?? '',
      nomme: json['nomme'] ?? '',
      finDeContrat: json['finDeContrat'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }
}
