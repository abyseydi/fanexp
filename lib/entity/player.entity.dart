// lib/entity/player.entity.dart

class PlayerAttributes {
  final int vit;
  final int tir;
  final int pas;
  final int dri;
  final int def;
  final int phy;
  final int pl;
  final int rel;
  final int deg;
  final int ref;
  final int pos;

  PlayerAttributes({
    required this.vit,
    required this.tir,
    required this.pas,
    required this.dri,
    required this.def,
    required this.phy,
    required this.pl,
    required this.rel,
    required this.deg,
    required this.ref,
    required this.pos,
  });

  factory PlayerAttributes.fromJson(Map<String, dynamic> json) {
    int _asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return PlayerAttributes(
      vit: _asInt(json['vit']),
      tir: _asInt(json['tir']),
      pas: _asInt(json['pas']),
      dri: _asInt(json['dri']),
      def: _asInt(json['def']),
      phy: _asInt(json['phy']),
      pl: _asInt(json['pl']),
      rel: _asInt(json['rel']),
      deg: _asInt(json['deg']),
      ref: _asInt(json['ref']),
      pos: _asInt(json['pos']),
    );
  }
}

class TransferHistoryItem {
  final String date;
  final String fromClub;
  final String toClub;
  final String transferType;
  final String fee;

  TransferHistoryItem({
    required this.date,
    required this.fromClub,
    required this.toClub,
    required this.transferType,
    required this.fee,
  });

  factory TransferHistoryItem.fromJson(Map<String, dynamic> json) {
    return TransferHistoryItem(
      date: json['date'] ?? '',
      fromClub: json['fromClub'] ?? '',
      toClub: json['toClub'] ?? '',
      transferType: json['transferType'] ?? '',
      fee: json['fee'] ?? '',
    );
  }
}

class PlayerEntity {
  final int id;
  final String fullName;
  final String birthDate;
  final int age;
  final int heightCm;
  final String club;
  final String clubLogoUrl;
  final String loanStatus;
  final String? loanEndDate;
  final int jerseyNumber;
  final double marketValueMillions;
  final List<String> positions;
  final String primaryPosition;
  final String positionCategory;
  final String photoUrl;
  final int startDate;
  final int selections;
  final int matchesPlayed;
  final int goals;
  final int trophiesWon;
  final double formRating;
  final String preferredFoot;
  final String? strength;
  final String? weakness;
  final PlayerAttributes attributes;
  final List<TransferHistoryItem> transferHistory;

  PlayerEntity({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.age,
    required this.heightCm,
    required this.club,
    required this.clubLogoUrl,
    required this.loanStatus,
    required this.loanEndDate,
    required this.jerseyNumber,
    required this.marketValueMillions,
    required this.positions,
    required this.primaryPosition,
    required this.positionCategory,
    required this.photoUrl,
    required this.startDate,
    required this.selections,
    required this.matchesPlayed,
    required this.goals,
    required this.trophiesWon,
    required this.formRating,
    required this.preferredFoot,
    required this.strength,
    required this.weakness,
    required this.attributes,
    required this.transferHistory,
  });

  factory PlayerEntity.fromJson(Map<String, dynamic> json) {
    double _asDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    int _asInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    final attrs = PlayerAttributes.fromJson(json['attributes'] ?? {});
    final historyJson = (json['transferHistory'] as List<dynamic>? ?? []);
    final history = historyJson
        .map((e) => TransferHistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return PlayerEntity(
      id: _asInt(json['id']),
      fullName: json['fullName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      age: _asInt(json['age']),
      heightCm: _asInt(json['heightCm']),
      club: json['club'] ?? '',
      clubLogoUrl: json['clubLogoUrl'] ?? '',
      loanStatus: json['loanStatus'] ?? '',
      loanEndDate: json['loanEndDate'],
      jerseyNumber: _asInt(json['jerseyNumber']),
      marketValueMillions: _asDouble(json['marketValueMillions']),
      positions:
          (json['positions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      primaryPosition: json['primaryPosition'] ?? '',
      positionCategory: json['positionCategory'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      startDate: _asInt(json['startDate']),
      selections: _asInt(json['selections']),
      matchesPlayed: _asInt(json['matchesPlayed']),
      goals: _asInt(json['goals']),
      trophiesWon: _asInt(json['trophiesWon']),
      formRating: _asDouble(json['formRating']),
      preferredFoot: json['preferredFoot'] ?? '',
      strength: json['strength'],
      weakness: json['weakness'],
      attributes: attrs,
      transferHistory: history,
    );
  }
}
