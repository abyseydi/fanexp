// lib/entity/female_player.entity.dart

class FemalePlayerEntity {
  final int id;
  final String nom;
  final String club;
  final String paysClub;
  final String paysClubPhotoUrl;
  final String position; // ex: "Gardienne", "Défenseure"
  final String
  positionCategory; // ex: "GARDIEN", "DEFENSEUR", "MILIEU", "ATTAQUANT"
  final int numero;
  final int age;
  final int? tailleCm; // null si "-"

  FemalePlayerEntity({
    required this.id,
    required this.nom,
    required this.club,
    required this.paysClub,
    required this.paysClubPhotoUrl,
    required this.position,
    required this.positionCategory,
    required this.numero,
    required this.age,
    required this.tailleCm,
  });

  factory FemalePlayerEntity.fromJson(Map<String, dynamic> json) {
    int asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    int? heightFromJson(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) {
        final trimmed = v.trim();
        if (trimmed.isEmpty || trimmed == '-') return null;
        return int.tryParse(trimmed);
      }
      return null;
    }

    String mapPositionToCategory(String pos) {
      final lower = pos.toLowerCase();
      if (lower.contains('gardien')) {
        return 'GARDIEN';
      } else if (lower.contains('défenseur') || lower.contains('defenseur')) {
        return 'DEFENSEUR';
      } else if (lower.contains('milieu')) {
        return 'MILIEU';
      } else if (lower.contains('attaquant')) {
        return 'ATTAQUANT';
      }
      return 'AUTRE';
    }

    final rawPosition = (json['position'] ?? '').toString();
    final posCategory = mapPositionToCategory(rawPosition);

    return FemalePlayerEntity(
      id: asInt(json['id']),
      nom: json['nom']?.toString() ?? '',
      club: json['club']?.toString() ?? '',
      paysClub: json['paysClub']?.toString() ?? '',
      paysClubPhotoUrl: json['paysClubPhotoUrl']?.toString() ?? '',
      position: rawPosition,
      positionCategory: posCategory,
      numero: asInt(json['numero']),
      age: asInt(json['age']),
      tailleCm: heightFromJson(json['tailleCm']),
    );
  }

  /// Optionnel : pratique si tu fais `list.map(FemalePlayerEntity.fromJson).toList()`
  static List<FemalePlayerEntity> listFromJson(List<dynamic> data) {
    return data
        .map((e) => FemalePlayerEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
