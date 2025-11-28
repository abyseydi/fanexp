// lib/screens/players/player_detail_screen.dart

import 'package:fanexp/entity/player.entity.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:flutter/material.dart';

class PlayerDetail extends StatelessWidget {
  final PlayerEntity player;

  const PlayerDetail({super.key, required this.player});

  String _buildAiSummary(PlayerEntity p) {
    final buffer = StringBuffer();

    buffer.write(
      'Selon notre moteur IA, ${p.fullName} affiche une forme de ${p.formRating.toStringAsFixed(1)}/10 ',
    );
    buffer.write('avec un profil ${p.primaryPosition} ');
    buffer.write('dans un registre ${p.positionCategory.toLowerCase()}. ');

    if (p.strength != null && p.strength!.trim().isNotEmpty) {
      buffer.write('Point fort : ${p.strength}. ');
    }
    if (p.weakness != null && p.weakness!.trim().isNotEmpty) {
      buffer.write('Point à surveiller : ${p.weakness}. ');
    }

    buffer.write(
      'Avec ${p.goals} buts et ${p.matchesPlayed} matchs, il reste un élément clé du collectif.',
    );

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            backgroundColor: gaindeGreen,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(
                start: 56,
                bottom: 12,
              ),
              title: Text(
                player.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0B5F34), Color(0xFF0E2E24)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  if (player.photoUrl.isNotEmpty)
                    Opacity(
                      opacity: 0.25,
                      child: Image.network(player.photoUrl, fit: BoxFit.cover),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(width: 24),
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
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (player.clubLogoUrl.isNotEmpty)
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                          player.clubLogoUrl,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          player.club,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    _headerChip(
                                      label:
                                          '#${player.jerseyNumber} · ${player.primaryPosition}',
                                    ),
                                    const SizedBox(width: 6),
                                    _headerChip(
                                      label:
                                          '${player.age} ans · ${player.heightCm} cm',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _AiSummaryCard(text: _buildAiSummary(player)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _QuickStatsRow(player: player),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AttributesSection(player: player),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

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

  Widget _headerChip({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gaindeGreen.withOpacity(.2)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: gaindeGreen, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: gaindeInk.withOpacity(.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Stats rapides ----------

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

// ---------- Attributs ----------

class _AttributesSection extends StatelessWidget {
  final PlayerEntity player;
  const _AttributesSection({required this.player});

  @override
  Widget build(BuildContext context) {
    final attrs = player.attributes;

    final data = [
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
            'Attributs normalisés par notre moteur d’analyse.',
            style: TextStyle(fontSize: 12, color: gaindeInk.withOpacity(.6)),
          ),
          const SizedBox(height: 10),
          ...data.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _AttributeBar(label: e.label, value: e.value),
            ),
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
    final v = value.clamp(0, 100);
    final percent = v / 100.0;

    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: gaindeGreenSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              LayoutBuilder(
                builder: (ctx, cons) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: 10,
                    width: cons.maxWidth * percent,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: [gaindeGreen, gaindeGold],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            v.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

// ---------- Historique transferts ----------

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
          ...history.map((h) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    Container(width: 2, height: 26, color: gaindeGreenSoft),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
                        Text(
                          '${h.fromClub} → ${h.toClub}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
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
          }).toList(),
        ],
      ),
    );
  }
}
