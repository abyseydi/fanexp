// import 'package:flutter/material.dart';
// import 'package:fanexp/theme/gainde_theme.dart';
// import 'package:fanexp/widgets/glasscard.dart';

// class MatchHub extends StatelessWidget {
//   const MatchHub({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Match Center')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: const [
//           _ScoreHeader(),
//           SizedBox(height: 12),
//           _LiveFeed(),
//           SizedBox(height: 12),
//           _StatsGrid(),
//           SizedBox(height: 12),
//           _LineupsCard(),
//         ],
//       ),
//     );
//   }
// }

// class _ScoreHeader extends StatelessWidget {
//   const _ScoreHeader();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Row(
//         children: const [
//           _Team(name: 'SEN'),
//           Spacer(),
//           Text(
//             '1 - 0',
//             style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
//           ),
//           Spacer(),
//           _Team(name: 'MAR'),
//         ],
//       ),
//     );
//   }
// }

// class _Team extends StatelessWidget {
//   final String name;
//   const _Team({required this.name});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const CircleAvatar(radius: 16, backgroundColor: gaindeGreen),
//         const SizedBox(width: 8),
//         Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
//       ],
//     );
//   }
// }

// class _LiveFeed extends StatelessWidget {
//   const _LiveFeed();
//   @override
//   Widget build(BuildContext context) {
//     final events = const [
//       '43’ But Dia',
//       '52’ Jaune Hakimi',
//       '67’ Tactique : pressing haut',
//     ];
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Live', style: TextStyle(fontWeight: FontWeight.w800)),
//           const SizedBox(height: 8),
//           ...events.map(
//             (e) => Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.fiber_manual_record,
//                     size: 10,
//                     color: gaindeRed,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(child: Text(e)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatsGrid extends StatelessWidget {
//   const _StatsGrid();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: GridView.count(
//         crossAxisCount: 2,
//         shrinkWrap: true,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//         physics: const NeverScrollableScrollPhysics(),
//         children: const [
//           _StatTile(label: 'xG', valueLeft: '1.2', valueRight: '0.6'),
//           _StatTile(label: 'Tirs cadrés', valueLeft: '5', valueRight: '2'),
//           _StatTile(
//             label: 'Attaques côté droit',
//             valueLeft: '58%',
//             valueRight: '31%',
//           ),
//           _StatTile(label: 'PPDA', valueLeft: '7.5', valueRight: '10.2'),
//         ],
//       ),
//     );
//   }
// }

// class _StatTile extends StatelessWidget {
//   final String label, valueLeft, valueRight;
//   const _StatTile({
//     required this.label,
//     required this.valueLeft,
//     required this.valueRight,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: gaindeGreenSoft,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(color: Colors.black.withOpacity(.7))),
//           const Spacer(),
//           Row(
//             children: [
//               Text(
//                 valueLeft,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 18,
//                   color: gaindeGreen,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 valueRight,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 18,
//                   color: gaindeInk,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LineupsCard extends StatelessWidget {
//   const _LineupsCard();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Text(
//             'Compositions probables (IA)',
//             style: TextStyle(fontWeight: FontWeight.w800),
//           ),
//           SizedBox(height: 8),
//           Text('SEN: 4-3-3 • Sarr – Dia – Mané …'),
//           Text('MAR: 4-3-3 • Ziyech – En-Nesyri – Hakim …'),
//         ],
//       ),
//     );
//   }
// }

// lib/screens/match/match_hub.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';

class MatchHub extends StatelessWidget {
  const MatchHub({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Match Hub'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Match du jour'),
              Tab(text: 'Live'),
              Tab(text: 'Stats post-match'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_MatchOfTheDayTab(), _LiveTab(), _PostMatchStatsTab()],
        ),
      ),
    );
  }
}

//
// -------------------- Onglet 1 : Match du jour --------------------
//
class _MatchOfTheDayTab extends StatelessWidget {
  const _MatchOfTheDayTab();

  @override
  Widget build(BuildContext context) {
    final kickoff = DateTime.now().add(const Duration(hours: 2, minutes: 30));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const _MatchHeader(),
        const SizedBox(height: 12),
        _KickoffTile(kickoff: kickoff),
        const SizedBox(height: 12),
        const _ProbableXI(),
        const SizedBox(height: 12),
        const _CoachNotes(),
        const SizedBox(height: 12),
        const _QuickActionsRow(),
      ],
    );
  }
}

class _MatchHeader extends StatelessWidget {
  const _MatchHeader();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          _TeamBadge(name: 'Sénégal', flagAsset: 'assets/img/senegal.png'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: gaindeGold.withOpacity(.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: gaindeGold.withOpacity(.35)),
            ),
            child: const Text(
              'Amical',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const Spacer(),
          _TeamBadge(name: 'Maroc', flagAsset: 'assets/img/maroc.png'),
        ],
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String name;
  final String flagAsset;
  const _TeamBadge({required this.name, required this.flagAsset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundImage: AssetImage(flagAsset)),
        const SizedBox(width: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _KickoffTile extends StatelessWidget {
  final DateTime kickoff;
  const _KickoffTile({required this.kickoff});

  String _fmt(Duration d) {
    if (d.isNegative) return 'En approche';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final remain = kickoff.difference(DateTime.now());
    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Coup d’envoi dans ${_fmt(remain)} • ${kickoff.hour.toString().padLeft(2, '0')}:${kickoff.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Alerte'),
          ),
        ],
      ),
    );
  }
}

class _ProbableXI extends StatelessWidget {
  const _ProbableXI();

  @override
  Widget build(BuildContext context) {
    final xi = const [
      'Mendy (G)',
      'Sabaly',
      'Koulibaly',
      'Diallo',
      'Jakobs',
      'Gueye',
      'Mendy N.',
      'Ndiaye',
      'Sarr',
      'Dia',
      'Mané',
    ];
    final bench = const ['Dieng', 'Ciss', 'Sima', 'N. Jackson', 'L. Diatta'];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.list_alt_rounded,
            title: 'Compo probable (4-3-3)',
          ),
          const SizedBox(height: 8),
          _PitchGrid(names: xi),
          const SizedBox(height: 12),
          const Text('Banc', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: bench.map((p) => Chip(label: Text(p))).toList(),
          ),
        ],
      ),
    );
  }
}

// class _PitchGrid extends StatelessWidget {
//   final List<String> names;
//   const _PitchGrid({required this.names});

//   @override
//   Widget build(BuildContext context) {
//     // Mise en lignes simplifiée : 1-4-3-3
//     final rows = [
//       [names[0]], // G
//       [names[1], names[2], names[3], names[4]], // 4
//       [names[5], names[6], names[7]], // 3
//       [names[8], names[9], names[10]], // 3
//     ];
//     return AspectRatio(
//       aspectRatio: 3 / 4,
//       child: Container(
//         decoration: BoxDecoration(
//           color: gaindeGreen,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: gaindeGreen.withOpacity(.25)),
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: rows.map((line) {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: line.map((p) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(999),
//                     border: Border.all(color: Colors.black12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(.06),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     p,
//                     style: const TextStyle(fontWeight: FontWeight.w700),
//                   ),
//                 );
//               }).toList(),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
class _PitchGrid extends StatelessWidget {
  final List<String> names;
  const _PitchGrid({required this.names});

  @override
  Widget build(BuildContext context) {
    // 1-4-3-3
    final rows = [
      [names[0]], // G
      [names[1], names[2], names[3], names[4]], // 4
      [names[5], names[6], names[7]], // 3
      [names[8], names[9], names[10]], // 3
    ];
    // positions verticales (0..1)
    const rowY = [0.09, 0.32, 0.58, 0.83];

    // Construit toutes les pastilles joueurs
    final List<Widget> chips = [];
    for (int i = 0; i < rows.length; i++) {
      final line = rows[i];
      final y = rowY[i];
      for (int j = 0; j < line.length; j++) {
        final x = (j + 1) / (line.length + 1);
        chips.add(
          Align(
            alignment: Alignment(x * 2 - 1, y * 2 - 1),
            child: _PlayerChip(label: line[j]),
          ),
        );
      }
    }

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _PitchPainter()),
            ...chips, // ✅ on "spread" ici, pas dans un return
          ],
        ),
      ),
    );
  }
}

class _CoachNotes extends StatelessWidget {
  const _CoachNotes();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SectionTitle(icon: Icons.note_alt_outlined, title: 'Notes staff'),
          SizedBox(height: 8),
          _Bullet('Bloc médian compact, déclenchement pressing couloir droit.'),
          _Bullet('Transitions offensives rapides après récupération haute.'),
          _Bullet('CPA : variations 1er/2e poteau testées.'),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassCard(
      child: Row(
        children: [
          _QuickAction(
            icon: Icons.confirmation_num_outlined,
            label: 'Billetterie',
            color: cs.primary,
          ),
          const SizedBox(width: 12),
          _QuickAction(
            icon: Icons.bar_chart_rounded,
            label: 'Classement',
            color: gaindeInk,
          ),
          const SizedBox(width: 12),
          _QuickAction(
            icon: Icons.stacked_line_chart_rounded,
            label: 'Forme',
            color: gaindeRed,
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: color.withOpacity(.08),
            border: Border.all(color: color.withOpacity(.25)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: gaindeGreen),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.fiber_manual_record, size: 10, color: gaindeGreen),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

//
// -------------------- Onglet 2 : Live (événements, xG live, momentum) --------------------
//
class _LiveTab extends StatelessWidget {
  const _LiveTab();

  @override
  Widget build(BuildContext context) {
    final events = const [
      _LiveEvent(minute: 12, type: 'Occasion', text: 'Sarr frappe – arrêté'),
      _LiveEvent(minute: 31, type: 'But', text: 'Dia (SEN) 1–0'),
      _LiveEvent(minute: 54, type: 'Carton', text: 'Jaune pour Hakimi'),
      _LiveEvent(minute: 70, type: 'xG élevé', text: 'Mané face à face (0.35)'),
    ];

    // Mock xG cumulés minute par minute (0..1 par action)
    final xgSenegal = [0.05, 0.12, 0.20, 0.35, 0.40, 0.55, 0.65];
    final xgAdverse = [0.02, 0.06, 0.10, 0.12, 0.20, 0.27, 0.35];

    // Mock momentum (−1..+1)
    final momentum = [0.2, 0.4, 0.5, 0.7, 0.45, 0.2, -0.1, 0.1, 0.6, 0.8, 0.3];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.flash_on_rounded,
                title: 'Événements',
              ),
              const SizedBox(height: 8),
              for (final e in events) _EventTile(e: e),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.bar_chart,
                title: 'xG live (cumulé)',
              ),
              const SizedBox(height: 12),
              _XgBars(senegal: xgSenegal.last, opponent: xgAdverse.last),
              const SizedBox(height: 8),
              Text(
                'SEN ${xgSenegal.last.toStringAsFixed(2)} — ${xgAdverse.last.toStringAsFixed(2)} OPP',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: xgSenegal,
                    color: gaindeGreen,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 80,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: xgAdverse,
                    color: gaindeRed,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.stacked_line_chart,
                title: 'Momentum',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: CustomPaint(
                  painter: _MomentumPainter(values: momentum),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 6),
              const Text('>0 domination Sénégal • <0 domination adverse'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiveEvent {
  final int minute;
  final String type;
  final String text;
  const _LiveEvent({
    required this.minute,
    required this.type,
    required this.text,
  });
}

class _EventTile extends StatelessWidget {
  final _LiveEvent e;
  const _EventTile({required this.e});

  IconData _icon() {
    switch (e.type) {
      case 'But':
        return Icons.sports_soccer;
    }
    if (e.type.toLowerCase().contains('carton'))
      return Icons.warning_amber_rounded;
    if (e.type.toLowerCase().contains('xg')) return Icons.bolt_rounded;
    return Icons.event;
  }

  Color _color() {
    if (e.type == 'But') return gaindeGreen;
    if (e.type.toLowerCase().contains('carton')) return gaindeGold;
    if (e.type.toLowerCase().contains('xg')) return gaindeRed;
    return gaindeInk;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: _color().withOpacity(.12),
        child: Icon(_icon(), color: _color(), size: 18),
      ),
      title: Text(e.text, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text("${e.minute}'"),
    );
  }
}

class _XgBars extends StatelessWidget {
  final double senegal;
  final double opponent;
  const _XgBars({required this.senegal, required this.opponent});

  @override
  Widget build(BuildContext context) {
    final total = (senegal + opponent).clamp(0.0001, 999.0);
    final s = (senegal / total).clamp(.0, 1.0);
    final o = 1 - s;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 14,
        child: Row(
          children: [
            Expanded(
              flex: (s * 1000).round(),
              child: Container(color: gaindeGreen),
            ),
            Expanded(
              flex: (o * 1000).round(),
              child: Container(color: gaindeRed),
            ),
          ],
        ),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  const _PitchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Gazon (bandes)
    final grass1 = const Color(0xFF5BAF5C);
    final grass2 = const Color(0xFF4CA956);
    final stripeH = size.height / 10;
    for (int i = 0; i < 10; i++) {
      final p = Paint()..color = (i % 2 == 0) ? grass1 : grass2;
      canvas.drawRect(Rect.fromLTWH(0, i * stripeH, size.width, stripeH), p);
    }

    // Marges internes
    final line = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.012;

    final margin = size.width * 0.04;
    final field = Rect.fromLTWH(
      margin,
      margin,
      size.width - 2 * margin,
      size.height - 2 * margin,
    );

    // Bord du terrain
    canvas.drawRRect(
      RRect.fromRectAndRadius(field, const Radius.circular(12)),
      line,
    );

    // Ligne médiane + cercle
    final midX = field.left + field.width / 2;
    canvas.drawLine(Offset(midX, field.top), Offset(midX, field.bottom), line);

    final center = field.center;
    final centerRadius = field.width * 0.12;
    canvas.drawCircle(center, centerRadius, line);
    canvas.drawCircle(
      center,
      line.strokeWidth * 0.6,
      Paint()..color = Colors.white,
    );

    // Dimensions surfaces
    final areaW = field.width * 0.5;
    final areaH = field.height * 0.18;
    final smallAreaW = field.width * 0.3;
    final smallAreaH = field.height * 0.08;
    final goalDepth = field.height * 0.02;
    final arcR = field.width * 0.12;

    // Haut
    final topBig = Rect.fromLTWH(
      center.dx - areaW / 2,
      field.top,
      areaW,
      areaH,
    );
    final topSmall = Rect.fromLTWH(
      center.dx - smallAreaW / 2,
      field.top,
      smallAreaW,
      smallAreaH,
    );
    canvas.drawRect(topBig, line);
    canvas.drawRect(topSmall, line);
    final topPK = Offset(center.dx, field.top + areaH * 0.6);
    canvas.drawCircle(
      topPK,
      line.strokeWidth * 0.6,
      Paint()..color = Colors.white,
    );
    final topArcRect = Rect.fromCircle(
      center: Offset(center.dx, field.top + areaH),
      radius: arcR,
    );
    canvas.drawArc(topArcRect, 0.0, pi, false, line);
    final topGoal = Rect.fromLTWH(
      center.dx - field.width * 0.18 / 2,
      field.top - goalDepth,
      field.width * 0.18,
      goalDepth,
    );
    canvas.drawRect(topGoal, line);

    // Bas
    final bottomBig = Rect.fromLTWH(
      center.dx - areaW / 2,
      field.bottom - areaH,
      areaW,
      areaH,
    );
    final bottomSmall = Rect.fromLTWH(
      center.dx - smallAreaW / 2,
      field.bottom - smallAreaH,
      smallAreaW,
      smallAreaH,
    );
    canvas.drawRect(bottomBig, line);
    canvas.drawRect(bottomSmall, line);
    final botPK = Offset(center.dx, field.bottom - areaH * 0.6);
    canvas.drawCircle(
      botPK,
      line.strokeWidth * 0.6,
      Paint()..color = Colors.white,
    );
    final botArcRect = Rect.fromCircle(
      center: Offset(center.dx, field.bottom - areaH),
      radius: arcR,
    );
    canvas.drawArc(botArcRect, pi, pi, false, line);
    final bottomGoal = Rect.fromLTWH(
      center.dx - field.width * 0.18 / 2,
      field.bottom,
      field.width * 0.18,
      goalDepth,
    );
    canvas.drawRect(bottomGoal, line);

    // Corners
    final cornerR = field.width * 0.03;
    void cornerArc(Offset c, double startAngle) {
      final rr = Rect.fromCircle(center: c, radius: cornerR);
      canvas.drawArc(rr, startAngle, pi / 2, false, line);
    }

    cornerArc(Offset(field.left, field.top), 0); // HG
    cornerArc(Offset(field.right, field.top), pi / 2); // HD
    cornerArc(Offset(field.right, field.bottom), pi); // BD
    cornerArc(Offset(field.left, field.bottom), 3 * pi / 2); // BG
  }

  @override
  bool shouldRepaint(covariant _PitchPainter oldDelegate) => false;
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).abs() < 1e-6 ? 1.0 : (maxV - minV);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - (values[i] - minV) / range);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}

class _MomentumPainter extends CustomPainter {
  final List<double> values; // −1..+1
  _MomentumPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    // Axe 0
    final axis = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axis,
    );

    if (values.isEmpty) return;
    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (0.5 - 0.5 * values[i].clamp(-1, 1));
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    final paint = Paint()
      ..color = gaindeGreen
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final area = Path.from(path)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height / 2)
      ..close();
    final fill = Paint()
      ..shader = LinearGradient(
        colors: [gaindeGreen.withOpacity(.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(area, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MomentumPainter old) => old.values != values;
}

//
// -------------------- Onglet 3 : Stats post-match (heatmaps, passes clés, radars) --------------------
//
class _PostMatchStatsTab extends StatelessWidget {
  const _PostMatchStatsTab();

  @override
  Widget build(BuildContext context) {
    // Mock heatmap intensities 10x7
    final heat = List.generate(
      10,
      (x) => List.generate(7, (y) {
        final dx = (x - 7).abs().toDouble();
        final dy = (y - 3).abs().toDouble();
        return (1.2 - (dx + dy) / 12).clamp(0.0, 1.0);
      }),
    );

    // Radar SEN vs OPP (0..1)
    final sen = [
      0.72,
      0.64,
      0.58,
      0.80,
      0.66,
    ]; // xG, tirs, possession, PPDA inverse, duels
    final opp = [0.45, 0.40, 0.52, 0.35, 0.48];

    final keyPasses = const [
      ('Mané', 'Sarr', "Passe clé dans le demi-espace droit"),
      ('Ndiaye', 'Dia', "Remise et frappe en pivot"),
      ('Jakobs', 'Mané', "Centre tendu au second poteau"),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.local_fire_department_outlined,
                title: 'Heatmap (SEN)',
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 3 / 4,
                child: CustomPaint(
                  painter: _HeatmapPainter(heat),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.alt_route_rounded,
                title: 'Passes clés',
              ),
              const SizedBox(height: 8),
              for (final (from, to, desc) in keyPasses)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.arrow_right_alt_rounded,
                    color: gaindeGreen,
                  ),
                  title: Text(
                    '$from → $to',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(desc),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.pentagon_outlined,
                title: 'Radar comparatif',
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: _RadarPainter(sen: sen, opp: opp),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 6),
              const Wrap(
                spacing: 12,
                children: [
                  _LegendDot(color: gaindeGreen, label: 'SEN'),
                  _LegendDot(color: gaindeRed, label: 'OPP'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerChip extends StatelessWidget {
  final String label;
  const _PlayerChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  final List<List<double>> v; // 10x7
  _HeatmapPainter(this.v);

  @override
  void paint(Canvas canvas, Size size) {
    final cols = v.length;
    final rows = v[0].length;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    // terrain contour
    final border = Paint()
      ..color = gaindeInk.withOpacity(.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(14),
      ),
      border,
    );

    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        final val = v[x][y];
        final color = Color.lerp(Colors.white, gaindeRed, val)!.withOpacity(.9);
        final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(x * cellW + 1, y * cellH + 1, cellW - 2, cellH - 2),
          const Radius.circular(6),
        );
        final p = Paint()..color = color;
        canvas.drawRRect(r, p);
      }
    }
    // médiane
    final mid = Paint()
      ..color = gaindeInk.withOpacity(.15)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      mid,
    );
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter old) => true;
}

class _RadarPainter extends CustomPainter {
  final List<double> sen; // 5 dimensions
  final List<double> opp;
  _RadarPainter({required this.sen, required this.opp});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide * .38;
    final n = sen.length;
    final angles = List.generate(n, (i) => -90.0 + i * 360.0 / n); // en degrés

    // to point
    Offset pt(double radius, double deg) {
      final rad = deg * 3.14159265 / 180.0;
      return Offset(
        center.dx + radius * cos(rad),
        center.dy + radius * sin(rad),
      );
    }

    // grille
    final grid = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke;
    for (int k = 1; k <= 4; k++) {
      final rr = r * k / 4;
      final path = Path();
      for (int i = 0; i < n; i++) {
        final p = pt(rr, angles[i]);
        if (i == 0)
          path.moveTo(p.dx, p.dy);
        else
          path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, grid);
    }

    // axes
    final axis = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    for (int i = 0; i < n; i++) {
      canvas.drawLine(center, pt(r, angles[i]), axis);
    }

    // polygones
    Path poly(List<double> vals, Color c) {
      final path = Path();
      for (int i = 0; i < n; i++) {
        final p = pt(r * vals[i].clamp(0, 1), angles[i]);
        if (i == 0)
          path.moveTo(p.dx, p.dy);
        else
          path.lineTo(p.dx, p.dy);
      }
      path.close();
      final fill = Paint()..color = c.withOpacity(.22);
      final stroke = Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
      return path;
    }

    poly(sen, gaindeGreen);
    poly(opp, gaindeRed);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) => true;
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// import 'dart:math';
// import 'package:flutter/material.dart';

// /// Palette Go Gaïndé (Sénégal + neutres)
// const gaindeGreen = Color(0xFF007A33);
// const gaindeGold = Color(0xFFFFD100);
// const gaindeRed = Color(0xFFE31E24);
// const gaindeInk = Color(0xFF0F1D13);
// const gaindeBg = Color(0xFFF6F8FB);

// const gaindeGreenSoft = Color(0xFFE5F3EC);
// const gaindeGoldSoft = Color(0xFFFFF4C2);
// const gaindeRedSoft = Color(0xFFFCE1E3);

// class MatchHub extends StatefulWidget {
//   const MatchHub({super.key});
//   @override
//   State<MatchHub> createState() => _MatchHubState();
// }

// class _MatchHubState extends State<MatchHub> with TickerProviderStateMixin {
//   late final TabController _tab;
//   final kickoff = DateTime.now().add(const Duration(days: 2, hours: 1));

//   @override
//   void initState() {
//     super.initState();
//     _tab = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tab.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Scaffold(
//       backgroundColor: gaindeBg,
//       appBar: AppBar(
//         title: const Text(
//           'Match Hub',
//           style: TextStyle(fontWeight: FontWeight.w800),
//         ),
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         bottom: TabBar(
//           controller: _tab,
//           labelColor: gaindeInk,
//           indicatorColor: gaindeGreen,
//           tabs: const [
//             Tab(text: 'Feuille de match'),
//             Tab(text: 'Live'),
//             Tab(text: 'Stats'),
//           ],
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 12),
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color: gaindeGreenSoft,
//               borderRadius: BorderRadius.circular(999),
//               border: Border.all(color: gaindeGreen.withOpacity(.2)),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.schedule_rounded,
//                   size: 16,
//                   color: gaindeGreen,
//                 ),
//                 const SizedBox(width: 6),
//                 Text(
//                   _fmtKickoff(kickoff),
//                   style: const TextStyle(fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: TabBarView(
//         controller: _tab,
//         children: const [_SheetTab(), _LiveTab(), _StatsTab()],
//       ),
//     );
//   }

//   String _fmtKickoff(DateTime dt) {
//     final d =
//         '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
//     final h =
//         '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
//     return '$d • $h';
//   }
// }

// /// =============
// /// 1) FEUILLE
// /// =============
// class _SheetTab extends StatelessWidget {
//   const _SheetTab();

//   @override
//   Widget build(BuildContext context) {
//     final names = [
//       'Mendy', // G
//       'Jakobs', 'Koulibaly', 'Cissé', 'Sabaly', // 4
//       'M. Ndiaye', 'P. Mendy', 'G. Gueye', // 3
//       'Sarr', 'Jackson', 'Mané', // 3
//     ];

//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//       children: [
//         _InfoRow(
//           left: _TeamBadge(name: 'Sénégal', flag: 'assets/img/senegal.png'),
//           right: _TeamBadge(name: 'Maroc', flag: 'assets/img/maroc.png'),
//         ),
//         const SizedBox(height: 12),

//         // Terrain + compos
//         _Card(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const _SectionTitle('Compo probable'),
//               const SizedBox(height: 10),
//               _PitchGrid(names: names),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         // Liste remplaçants / arbitres / infos
//         _Card(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const _SectionTitle('Infos de match'),
//               const SizedBox(height: 10),
//               _Bullet('Stade Abdoulaye Wade, Diamniadio'),
//               _Bullet('Arbitre : B. Gassama'),
//               _Bullet('Compétition : Amical international'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// =============
// /// 2) LIVE
// /// =============
// class _LiveTab extends StatelessWidget {
//   const _LiveTab();

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//       children: [
//         // Bandeau LIVE
//         _Card(
//           color: gaindeRedSoft,
//           borderColor: gaindeRed.withOpacity(.2),
//           child: Row(
//             children: const [
//               _LiveDot(),
//               SizedBox(width: 8),
//               Text(
//                 'LIVE • 67’ – SEN 1–0 MAR',
//                 style: TextStyle(fontWeight: FontWeight.w800),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         // Evénements
//         _Card(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               _SectionTitle('Événements'),
//               SizedBox(height: 8),
//               _LiveEventRow(
//                 min: '43’',
//                 icon: Icons.sports_soccer,
//                 text: 'But — Boulaye Dia (SEN)',
//               ),
//               _LiveEventRow(
//                 min: '52’',
//                 icon: Icons.warning_amber_rounded,
//                 text: 'Jaune — Achraf Hakimi (MAR)',
//               ),
//               _LiveEventRow(
//                 min: '60’',
//                 icon: Icons.swap_horiz_rounded,
//                 text: 'Changement — Jackson ↔ Diallo (SEN)',
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),

//         // xG & Momentum (mock propres)
//         _Card(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               _SectionTitle('xG live'),
//               SizedBox(height: 8),
//               _XgBarRow(
//                 leftLabel: 'SEN',
//                 leftVal: .65,
//                 rightLabel: 'MAR',
//                 rightVal: .35,
//               ),
//               SizedBox(height: 16),
//               _SectionTitle('Momentum'),
//               SizedBox(height: 8),
//               _MomentumSparkline(
//                 values: [0.2, 0.25, 0.6, 0.8, 0.65, 0.55, 0.35, 0.45, 0.7, 0.6],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// =============
// /// 3) STATS
// /// =============
// class _StatsTab extends StatelessWidget {
//   const _StatsTab();

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//       children: const [
//         _Card(child: _SectionTitle('Heatmap équipe (mock)')),
//         SizedBox(height: 12),
//         _Card(child: _SectionTitle('Passes clés (mock)')),
//         SizedBox(height: 12),
//         _Card(child: _SectionTitle('Radar joueur (mock)')),
//       ],
//     );
//   }
// }

// /// ======= widgets communs =======
// class _Card extends StatelessWidget {
//   final Widget child;
//   final Color? color;
//   final Color? borderColor;
//   const _Card({required this.child, this.color, this.borderColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color ?? Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: (borderColor ?? Colors.black12)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 14,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(14),
//       child: child,
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String text;
//   const _SectionTitle(this.text);
//   @override
//   Widget build(BuildContext context) {
//     return Text(text, style: const TextStyle(fontWeight: FontWeight.w800));
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final Widget left;
//   final Widget right;
//   const _InfoRow({required this.left, required this.right});
//   @override
//   Widget build(BuildContext context) {
//     return _Card(
//       child: Row(
//         children: [
//           Expanded(child: left),
//           const Text('vs', style: TextStyle(fontWeight: FontWeight.w800)),
//           Expanded(
//             child: Align(alignment: Alignment.centerRight, child: right),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TeamBadge extends StatelessWidget {
//   final String name;
//   final String flag;
//   const _TeamBadge({required this.name, required this.flag});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         CircleAvatar(radius: 18, backgroundImage: AssetImage(flag)),
//         const SizedBox(width: 8),
//         Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
//       ],
//     );
//   }
// }

// class _Bullet extends StatelessWidget {
//   final String text;
//   const _Bullet(this.text);
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Icon(Icons.circle, size: 8, color: gaindeGreen),
//         const SizedBox(width: 8),
//         Expanded(child: Text(text)),
//       ],
//     );
//   }
// }

// class _LiveDot extends StatefulWidget {
//   const _LiveDot();
//   @override
//   State<_LiveDot> createState() => _LiveDotState();
// }

// class _LiveDotState extends State<_LiveDot>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;

//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: Tween(
//         begin: .8,
//         end: 1.2,
//       ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
//       child: Container(
//         width: 10,
//         height: 10,
//         decoration: const BoxDecoration(
//           color: gaindeRed,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }

// class _LiveEventRow extends StatelessWidget {
//   final String min;
//   final IconData icon;
//   final String text;
//   const _LiveEventRow({
//     required this.min,
//     required this.icon,
//     required this.text,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 40,
//             child: Text(
//               min,
//               style: const TextStyle(fontWeight: FontWeight.w700),
//             ),
//           ),
//           Icon(icon, size: 18, color: gaindeInk),
//           const SizedBox(width: 8),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }
// }

// class _XgBarRow extends StatelessWidget {
//   final String leftLabel;
//   final double leftVal; // 0..1
//   final String rightLabel;
//   final double rightVal; // 0..1
//   const _XgBarRow({
//     required this.leftLabel,
//     required this.leftVal,
//     required this.rightLabel,
//     required this.rightVal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _XgBar(label: leftLabel, value: leftVal, color: gaindeGreen),
//         const SizedBox(height: 8),
//         _XgBar(label: rightLabel, value: rightVal, color: gaindeInk),
//       ],
//     );
//   }
// }

// class _XgBar extends StatelessWidget {
//   final String label;
//   final double value; // 0..1
//   final Color color;
//   const _XgBar({required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     final v = value.clamp(0, 1);
//     return Row(
//       children: [
//         SizedBox(
//           width: 40,
//           child: Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.w700),
//           ),
//         ),
//         Expanded(
//           child: Stack(
//             children: [
//               Container(
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: Colors.black12,
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//               ),
//               FractionallySizedBox(
//                 widthFactor: v.toDouble(),
//                 child: Container(
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: color,
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           (v * 100).toStringAsFixed(0) + '%',
//           style: const TextStyle(fontWeight: FontWeight.w700),
//         ),
//       ],
//     );
//   }
// }

// class _MomentumSparkline extends StatelessWidget {
//   final List<double> values; // 0..1
//   const _MomentumSparkline({required this.values});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: CustomPaint(
//         painter: _SparklinePainter(values),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: gaindeGreenSoft,
//             border: Border.all(color: gaindeGreen.withOpacity(.2)),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SparklinePainter extends CustomPainter {
//   final List<double> vs;
//   _SparklinePainter(this.vs);

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (vs.isEmpty) return;
//     final path = Path();
//     final n = vs.length;
//     for (int i = 0; i < n; i++) {
//       final x = i / (n - 1) * size.width;
//       final y = size.height - vs[i].clamp(0, 1) * size.height;
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }

//     final stroke = Paint()
//       ..color = gaindeGreen
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;

//     final fill = Paint()
//       ..shader = const LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [gaindeGreen, Colors.transparent],
//         stops: [0.0, 1.0],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..style = PaintingStyle.fill
//       ..color = gaindeGreen.withOpacity(.18);

//     // Remplissage sous la courbe
//     final fillPath = Path.from(path)
//       ..lineTo(size.width, size.height)
//       ..lineTo(0, size.height)
//       ..close();

//     canvas.drawPath(fillPath, fill);
//     canvas.drawPath(path, stroke);
//   }

//   @override
//   bool shouldRepaint(covariant _SparklinePainter oldDelegate) => false;
// }

// /// ============
// /// TERRAIN
// /// ============
// class _PitchGrid extends StatelessWidget {
//   final List<String> names;
//   const _PitchGrid({required this.names});

//   @override
//   Widget build(BuildContext context) {
//     // 1-4-3-3
//     final rows = [
//       [names[0]], // G
//       [names[1], names[2], names[3], names[4]], // 4
//       [names[5], names[6], names[7]], // 3
//       [names[8], names[9], names[10]], // 3
//     ];
//     // positions verticales (0..1)
//     const rowY = [0.09, 0.32, 0.58, 0.83];

//     // Construit toutes les pastilles joueurs
//     final List<Widget> chips = [];
//     for (int i = 0; i < rows.length; i++) {
//       final line = rows[i];
//       final y = rowY[i];
//       for (int j = 0; j < line.length; j++) {
//         final x = (j + 1) / (line.length + 1);
//         chips.add(
//           Align(
//             alignment: Alignment(x * 2 - 1, y * 2 - 1),
//             child: _PlayerChip(label: line[j]),
//           ),
//         );
//       }
//     }

//     return AspectRatio(
//       aspectRatio: 3 / 4,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             const CustomPaint(painter: _PitchPainter()),
//             ...chips, // ✅ on "spread" ici, pas dans un return
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PlayerChip extends StatelessWidget {
//   final String label;
//   const _PlayerChip({required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: Colors.black12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//     );
//   }
// }

// class _PitchPainter extends CustomPainter {
//   const _PitchPainter();

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Gazon (bandes)
//     final grass1 = const Color(0xFF5BAF5C);
//     final grass2 = const Color(0xFF4CA956);
//     final stripeH = size.height / 10;
//     for (int i = 0; i < 10; i++) {
//       final p = Paint()..color = (i % 2 == 0) ? grass1 : grass2;
//       canvas.drawRect(Rect.fromLTWH(0, i * stripeH, size.width, stripeH), p);
//     }

//     // Marges internes
//     final line = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = size.shortestSide * 0.012;

//     final margin = size.width * 0.04;
//     final field = Rect.fromLTWH(
//       margin,
//       margin,
//       size.width - 2 * margin,
//       size.height - 2 * margin,
//     );

//     // Bord du terrain
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(field, const Radius.circular(12)),
//       line,
//     );

//     // Ligne médiane + cercle
//     final midX = field.left + field.width / 2;
//     canvas.drawLine(Offset(midX, field.top), Offset(midX, field.bottom), line);

//     final center = field.center;
//     final centerRadius = field.width * 0.12;
//     canvas.drawCircle(center, centerRadius, line);
//     canvas.drawCircle(
//       center,
//       line.strokeWidth * 0.6,
//       Paint()..color = Colors.white,
//     );

//     // Dimensions surfaces
//     final areaW = field.width * 0.5;
//     final areaH = field.height * 0.18;
//     final smallAreaW = field.width * 0.3;
//     final smallAreaH = field.height * 0.08;
//     final goalDepth = field.height * 0.02;
//     final arcR = field.width * 0.12;

//     // Haut
//     final topBig = Rect.fromLTWH(
//       center.dx - areaW / 2,
//       field.top,
//       areaW,
//       areaH,
//     );
//     final topSmall = Rect.fromLTWH(
//       center.dx - smallAreaW / 2,
//       field.top,
//       smallAreaW,
//       smallAreaH,
//     );
//     canvas.drawRect(topBig, line);
//     canvas.drawRect(topSmall, line);
//     final topPK = Offset(center.dx, field.top + areaH * 0.6);
//     canvas.drawCircle(
//       topPK,
//       line.strokeWidth * 0.6,
//       Paint()..color = Colors.white,
//     );
//     final topArcRect = Rect.fromCircle(
//       center: Offset(center.dx, field.top + areaH),
//       radius: arcR,
//     );
//     canvas.drawArc(topArcRect, 0.0, pi, false, line);
//     final topGoal = Rect.fromLTWH(
//       center.dx - field.width * 0.18 / 2,
//       field.top - goalDepth,
//       field.width * 0.18,
//       goalDepth,
//     );
//     canvas.drawRect(topGoal, line);

//     // Bas
//     final bottomBig = Rect.fromLTWH(
//       center.dx - areaW / 2,
//       field.bottom - areaH,
//       areaW,
//       areaH,
//     );
//     final bottomSmall = Rect.fromLTWH(
//       center.dx - smallAreaW / 2,
//       field.bottom - smallAreaH,
//       smallAreaW,
//       smallAreaH,
//     );
//     canvas.drawRect(bottomBig, line);
//     canvas.drawRect(bottomSmall, line);
//     final botPK = Offset(center.dx, field.bottom - areaH * 0.6);
//     canvas.drawCircle(
//       botPK,
//       line.strokeWidth * 0.6,
//       Paint()..color = Colors.white,
//     );
//     final botArcRect = Rect.fromCircle(
//       center: Offset(center.dx, field.bottom - areaH),
//       radius: arcR,
//     );
//     canvas.drawArc(botArcRect, pi, pi, false, line);
//     final bottomGoal = Rect.fromLTWH(
//       center.dx - field.width * 0.18 / 2,
//       field.bottom,
//       field.width * 0.18,
//       goalDepth,
//     );
//     canvas.drawRect(bottomGoal, line);

//     // Corners
//     final cornerR = field.width * 0.03;
//     void cornerArc(Offset c, double startAngle) {
//       final rr = Rect.fromCircle(center: c, radius: cornerR);
//       canvas.drawArc(rr, startAngle, pi / 2, false, line);
//     }

//     cornerArc(Offset(field.left, field.top), 0); // HG
//     cornerArc(Offset(field.right, field.top), pi / 2); // HD
//     cornerArc(Offset(field.right, field.bottom), pi); // BD
//     cornerArc(Offset(field.left, field.bottom), 3 * pi / 2); // BG
//   }

//   @override
//   bool shouldRepaint(covariant _PitchPainter oldDelegate) => false;
// }
