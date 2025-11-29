import 'package:fanexp/entity/player.entity.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

class PlayerDetail extends StatelessWidget {
  final PlayerEntity player;

  const PlayerDetail({super.key, required this.player});

  String _buildAiSummary(PlayerEntity p) {
    final buffer = StringBuffer();

    buffer.write(
      '${p.fullName} affiche une forme de ${p.formRating.toStringAsFixed(1)}/10 ',
    );
    buffer.write('en tant que ${p.primaryPosition} ');
    buffer.write('(${p.positionCategory.toLowerCase()}). ');

    if (p.strength != null && p.strength!.trim().isNotEmpty) {
      buffer.write('💪 Point fort : ${p.strength}. ');
    }
    if (p.weakness != null && p.weakness!.trim().isNotEmpty) {
      buffer.write('⚠️ À surveiller : ${p.weakness}. ');
    }

    buffer.write(
      'Avec ${p.goals} buts en ${p.matchesPlayed} matchs, il reste un élément clé du collectif.',
    );

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final aiText = _buildAiSummary(player);

    // Radar data : on mappe quelques attributs principaux
    final attrs = player.attributes;
    final radarValues = <double>[
      attrs.vit.toDouble(), // Vitesse
      attrs.dri.toDouble(), // Dribble
      attrs.pas.toDouble(), // Passe
      attrs.tir.toDouble(), // Tir
      attrs.def.toDouble(), // Défense
    ];
    final radarLabels = ['VIT', 'DRI', 'PAS', 'TIR', 'DEF'];

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Ligne stats rapides
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _QuickStatsRow(player: player),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // // Résumé IA
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: _AiSummaryCard(text: aiText),
          //   ),
          // ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Bloc attributs : radar + barres
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AttributesSection(
                player: player,
                radarValues: radarValues,
                radarLabels: radarLabels,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Historique des transferts en timeline
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _TransferHistorySection(player: player),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      backgroundColor: gaindeGreen,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        player.fullName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 72, bottom: 12),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Dégradé de fond
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B5F34), Color(0xFF122027)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Photo du joueur en fond floutée
            if (player.photoUrl.isNotEmpty)
              Opacity(
                opacity: 0.22,
                child: Image.network(player.photoUrl, fit: BoxFit.cover),
              ),

            // Overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xCC000000), Colors.transparent],
                ),
              ),
            ),

            // Contenu bas : avatar + infos principales
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Hero(
                      tag: 'player_photo_${player.id}',
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.white,
                        backgroundImage: player.photoUrl.isNotEmpty
                            ? NetworkImage(player.photoUrl)
                            : null,
                        child: player.photoUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                color: gaindeGreen,
                                size: 48,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _HeaderInfos(player: player)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- HEADER INFOS ----------

class _HeaderInfos extends StatelessWidget {
  final PlayerEntity player;
  const _HeaderInfos({required this.player});

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _headerChip(
        label: '#${player.jerseyNumber} · ${player.primaryPosition}',
        icon: Icons.shield_moon_outlined,
      ),
      _headerChip(
        label: '${player.age} ans · ${player.heightCm} cm',
        icon: Icons.height_rounded,
      ),
      _headerChip(label: player.preferredFoot, icon: Icons.forest_rounded),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (player.clubLogoUrl.isNotEmpty || player.club.isNotEmpty)
          Row(
            children: [
              if (player.clubLogoUrl.isNotEmpty)
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(player.clubLogoUrl),
                ),
              if (player.clubLogoUrl.isNotEmpty) const SizedBox(width: 6),
              Flexible(
                child: Text(
                  player.club,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: chips),
        const SizedBox(height: 8),
        Row(
          children: [
            _formBadge(player.formRating),
            const SizedBox(width: 8),
            if (player.marketValueMillions > 0)
              _headerChip(
                label: '€${player.marketValueMillions.toStringAsFixed(1)}M',
                icon: Icons.euro_symbol_rounded,
                dense: true,
              ),
          ],
        ),
      ],
    );
  }

  Widget _headerChip({
    required String label,
    IconData? icon,
    bool dense = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formBadge(double rating) {
    Color c;
    if (rating >= 8) {
      c = gaindeGreen;
    } else if (rating >= 7) {
      c = gaindeGold;
    } else {
      c = gaindeRedSoft;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Résumé IA ----------

class _AiSummaryCard extends StatelessWidget {
  final String text;
  const _AiSummaryCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gaindeGreenSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gaindeGreen.withOpacity(.18)),
        boxShadow: [
          BoxShadow(
            color: gaindeInk.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: gaindeGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: gaindeInk.withOpacity(.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Quick Stats ----------

class _QuickStatsRow extends StatelessWidget {
  final PlayerEntity player;
  const _QuickStatsRow({required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            label: 'Matchs',
            value: player.matchesPlayed.toString(),
            subtitle: 'Sélections: ${player.selections}',
            icon: Icons.sports_soccer_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            label: 'Buts',
            value: player.goals.toString(),
            subtitle: 'Trophées: ${player.trophiesWon}',
            icon: Icons.emoji_events_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            label: 'Forme IA',
            value: player.formRating.toStringAsFixed(1),
            subtitle: 'sur 10',
            icon: Icons.bolt_rounded,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gaindeInk.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: gaindeGreen),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: gaindeInk.withOpacity(.7)),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: gaindeInk.withOpacity(.5)),
          ),
        ],
      ),
    );
  }
}

// ---------- Attributs : Radar + Barres ----------

class _AttributesSection extends StatelessWidget {
  final PlayerEntity player;
  final List<double> radarValues;
  final List<String> radarLabels;

  const _AttributesSection({
    required this.player,
    required this.radarValues,
    required this.radarLabels,
  });

  @override
  Widget build(BuildContext context) {
    final attrs = player.attributes;

    final bars = [
      _AttrRow(label: 'Vitesse', value: attrs.vit),
      _AttrRow(label: 'Tir', value: attrs.tir),
      _AttrRow(label: 'Passe', value: attrs.pas),
      _AttrRow(label: 'Dribble', value: attrs.dri),
      _AttrRow(label: 'Physique', value: attrs.phy),
      _AttrRow(label: 'Défense', value: attrs.def),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gaindeInk.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil technique IA',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'Visualisation radar + intensité par attribut.',
            style: TextStyle(fontSize: 12, color: gaindeInk.withOpacity(.6)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Radar chart
              Expanded(
                flex: 5,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _RadarChart(values: radarValues, labels: radarLabels),
                ),
              ),
              const SizedBox(width: 12),
              // Barres
              Expanded(
                flex: 6,
                child: Column(
                  children: bars
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: _AttributeBar(label: e.label, value: e.value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttrRow {
  final String label;
  final int value;
  _AttrRow({required this.label, required this.value});
}

class _AttributeBar extends StatelessWidget {
  final String label;
  final int value;

  const _AttributeBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 100); // num
    final percent = clamped.toDouble() / 100.0; // double

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, cons) {
              return Stack(
                children: [
                  Container(
                    height: 9,
                    width: cons.maxWidth,
                    decoration: BoxDecoration(
                      color: gaindeGreenSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    height: 9,
                    width: cons.maxWidth * percent,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [gaindeGreen, gaindeGold],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            clamped.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _RadarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const _RadarChart({required this.values, required this.labels});

  @override
  Widget build(BuildContext context) {
    final normalized = values.map((v) {
      final c = v.clamp(0.0, 100.0);
      return (c / 100.0).toDouble();
    }).toList();

    return CustomPaint(
      painter: _RadarPainter(values: normalized, labels: labels),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<double> values; // 0..1
  final List<String> labels;

  _RadarPainter({required this.values, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.42;
    final n = values.length;
    if (n == 0) return;

    final gridPaint = Paint()
      ..color = gaindeGreenSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final valuePaint = Paint()
      ..color = gaindeGreen.withOpacity(.55)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = gaindeGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Cercles concentriques
    for (int i = 1; i <= 3; i++) {
      final r = radius * i / 3;
      canvas.drawCircle(center, r, gridPaint);
    }

    final angleStep = 2 * 3.141592653589793 / n;
    final points = <Offset>[];

    // Points & axes
    for (int i = 0; i < n; i++) {
      final angle = -3.141592653589793 / 2 + i * angleStep;
      final valueRadius = radius * values[i];
      final x = center.dx + valueRadius * MathCos(angle);
      final y = center.dy + valueRadius * MathSin(angle);
      points.add(Offset(x, y));

      // Ligne axe
      final ax = center.dx + radius * MathCos(angle);
      final ay = center.dy + radius * MathSin(angle);
      canvas.drawLine(center, Offset(ax, ay), gridPaint);

      // Label
      final lx = center.dx + (radius + 14) * MathCos(angle);
      final ly = center.dy + (radius + 14) * MathSin(angle);
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            fontSize: 10,
            color: gaindeInk,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(lx - tp.width / 2, ly - tp.height / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Polygone rempli
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    canvas.drawPath(path, valuePaint);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels;
  }

  double MathCos(double x) => Math.cos(x);
  double MathSin(double x) => Math.sin(x);
}

class _TransferHistorySection extends StatelessWidget {
  final PlayerEntity player;
  const _TransferHistorySection({required this.player});

  @override
  Widget build(BuildContext context) {
    final history = player.transferHistory;
    if (history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Aucun mouvement de transfert enregistré.',
          style: TextStyle(fontSize: 13),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gaindeInk.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historique des transferts',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final h = history[index];
              final isLast = index == history.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline
                  Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: gaindeGreen,
                        ),
                      ),
                      if (!isLast)
                        Container(width: 2, height: 32, color: gaindeGreenSoft),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Card transfert
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: gaindeBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: gaindeGreen.withOpacity(.12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            h.date,
                            style: TextStyle(
                              fontSize: 11,
                              color: gaindeInk.withOpacity(.6),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: gaindeGreen,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${h.fromClub} → ${h.toClub}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${h.transferType} · ${h.fee}',
                            style: TextStyle(
                              fontSize: 12,
                              color: gaindeInk.withOpacity(.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
