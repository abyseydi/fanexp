// import 'package:fanexp/constants/colors/main_color.dart'
//     hide gaindeGreen, gaindeGold, gaindeRed;
// import 'package:flutter/material.dart';
// import 'package:fanexp/theme/gainde_theme.dart';
// import 'package:fanexp/widgets/glasscard.dart';
// import 'package:fanexp/widgets/buttons.dart';

// class PredictionReco extends StatelessWidget {
//   const PredictionReco({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Prédictions & Recos')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: const [
//           _WinProba(),
//           SizedBox(height: 12),
//           _XIReco(),
//           SizedBox(height: 12),
//           _CoachingTips(),
//         ],
//       ),
//     );
//   }
// }

// class _WinProba extends StatelessWidget {
//   const _WinProba();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Probabilités de résultat',
//             style: TextStyle(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: const [
//               _ProbPill(color: gaindeGreen, label: 'Victoire', value: '54%'),
//               SizedBox(width: 8),
//               _ProbPill(color: gaindeGold, label: 'Nul', value: '28%'),
//               SizedBox(width: 8),
//               _ProbPill(color: gaindeRed, label: 'Défaite', value: '18%'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProbPill extends StatelessWidget {
//   final Color color;
//   final String label;
//   final String value;
//   const _ProbPill({
//     required this.color,
//     required this.label,
//     required this.value,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: color.withOpacity(.12),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontWeight: FontWeight.w900,
//                 color: color,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(label, style: TextStyle(color: Colors.black.withOpacity(.7))),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _XIReco extends StatelessWidget {
//   const _XIReco();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'XI recommandé (IA)',
//             style: TextStyle(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             height: 140,
//             decoration: BoxDecoration(
//               color: gaindeGreenSoft,
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           const SizedBox(height: 8),
//           GlowButton(
//             label: 'Voir détails',
//             onTap: () {},
//             glowColor: gaindeGreen,
//             bgColor: gaindeGreen,
//             textColor: gaindeWhite,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CoachingTips extends StatelessWidget {
//   const _CoachingTips();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Text(
//             'Recommandations IA',
//             style: TextStyle(fontWeight: FontWeight.w800),
//           ),
//           SizedBox(height: 8),
//           _Bullet(text: 'Pressing haut 15–30’ (faiblesse relance G.).'),
//           _Bullet(text: 'Surveiller couloir droit (surnombre adverse).'),
//           _Bullet(text: 'Changements min 60–70 pour impact maximal.'),
//         ],
//       ),
//     );
//   }
// }

// class _Bullet extends StatelessWidget {
//   final String text;
//   const _Bullet({required this.text});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Icon(Icons.auto_awesome_rounded, size: 16, color: gaindeGreen),
//         const SizedBox(width: 6),
//         Expanded(child: Text(text)),
//       ],
//     );
//   }
// }

// lib/screens/prediction/predictReco.dart
import 'package:flutter/material.dart';

// Si tu as déjà un thème qui expose ces couleurs, importe-le et supprime ce bloc.
const gaindeGreen = Color(0xFF007A33);
const gaindeGold = Color(0xFFFFD100);
const gaindeRed = Color(0xFFE31E24);
const gaindeInk = Color(0xFF0F1D13);
const gaindeBg = Color(0xFFF6F8FB);

const gaindeGreenSoft = Color(0xFFE5F3EC);
const gaindeGoldSoft = Color(0xFFFFF4C2);
const gaindeRedSoft = Color(0xFFFCE1E3);
const gaindeWhite = Colors.white;

/// --------- PAGE ---------
class PredictionReco extends StatefulWidget {
  const PredictionReco({super.key});

  @override
  State<PredictionReco> createState() => _PredictionRecoState();
}

class _PredictionRecoState extends State<PredictionReco> {
  String _formation = '4-3-3';
  late List<String> _names;

  // Score/xG (mock contrôlés par sliders)
  double _homeG = 1.6;
  double _awayG = 0.8;
  double _homeXg = 1.85;
  double _awayXg = 0.95;

  @override
  void initState() {
    super.initState();
    _names = _predictNames(_formation);
  }

  List<String> _predictNames(String formation) {
    // TODO: Brancher ton backend ML ici
    if (formation == '4-2-3-1') {
      return const [
        'Mendy',
        'Jakobs', 'Koulibaly', 'Niakaté', 'Sabaly',
        'Gana', 'Pape Sarr', // 2
        'Diatta', 'Diallo', 'Sarr', // 3
        'Mané', // 1
      ];
    }
    // 4-3-3 par défaut
    return const [
      'Mendy',
      'Jakobs',
      'Koulibaly',
      'Niakaté',
      'Sabaly',
      'Gana',
      'Pape Sarr',
      'Diatta',
      'Sarr',
      'Diallo',
      'Mané',
    ];
  }

  void _onFormationChanged(String? f) {
    if (f == null) return;
    setState(() {
      _formation = f;
      _names = _predictNames(_formation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: gaindeBg,
      appBar: AppBar(
        title: const Text(
          'Prédictions & Recos',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SectionTitle(
            title: 'Compo & terrain',
            subtitle: 'Compo probable (IA) selon la forme & l’adversaire',
          ),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ToolbarRow(
                  left: _FormationPicker(
                    value: _formation,
                    onChanged: _onFormationChanged,
                  ),
                  right: FilledButton.icon(
                    onPressed: () {
                      // TODO: appeler ton endpoint ML
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Relancer la prédiction IA…'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text('Prédire'),
                  ),
                ),
                const SizedBox(height: 12),
                _MiniPitch(names: _names),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _Tag(icon: Icons.shield_outlined, label: 'Solidité déf.'),
                    _Tag(icon: Icons.flash_on_outlined, label: 'Transitions'),
                    _Tag(icon: Icons.cyclone_outlined, label: 'Pressing haut'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _SectionTitle(
            title: 'Score & xG (IA)',
            subtitle: 'Projection de score et expected goals',
          ),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ScoreHeader(
                  home: 'SEN',
                  away: 'MAR',
                  homeG: _homeG,
                  awayG: _awayG,
                ),
                const SizedBox(height: 10),
                _XgBars(homeXg: _homeXg, awayXg: _awayXg),
                const Divider(height: 24),
                const Text(
                  'Ajuster les paramètres',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                _LabeledSlider(
                  label: 'Buts SEN',
                  value: _homeG,
                  min: 0,
                  max: 4,
                  step: .1,
                  onChanged: (v) => setState(
                    () => _homeG = double.parse(v.toStringAsFixed(1)),
                  ),
                ),
                _LabeledSlider(
                  label: 'Buts MAR',
                  value: _awayG,
                  min: 0,
                  max: 4,
                  step: .1,
                  onChanged: (v) => setState(
                    () => _awayG = double.parse(v.toStringAsFixed(1)),
                  ),
                ),
                _LabeledSlider(
                  label: 'xG SEN',
                  value: _homeXg,
                  min: 0,
                  max: 4,
                  step: .05,
                  onChanged: (v) => setState(
                    () => _homeXg = double.parse(v.toStringAsFixed(2)),
                  ),
                ),
                _LabeledSlider(
                  label: 'xG MAR',
                  value: _awayXg,
                  min: 0,
                  max: 4,
                  step: .05,
                  onChanged: (v) => setState(
                    () => _awayXg = double.parse(v.toStringAsFixed(2)),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () {
                    // TODO: envoyer features -> endpoint pour recalcul
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Soumettre aux modèles (mock)…'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.insights_rounded),
                  label: const Text('Recalculer IA'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _SectionTitle(
            title: 'Risque blessure & fatigue',
            subtitle: 'Monitoring charge de travail (mock)',
          ),
          _Card(
            child: Column(
              children: const [
                _RiskRow(name: 'Ismaïla Sarr', risk: .18, load: .42),
                SizedBox(height: 10),
                _RiskRow(name: 'Sadio Mané', risk: .12, load: .36),
                SizedBox(height: 10),
                _RiskRow(name: 'Gana Gueye', risk: .26, load: .58),
                SizedBox(height: 10),
                _RiskRow(name: 'Kalidou Koulibaly', risk: .09, load: .31),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _SectionTitle(
            title: 'Recommandations pour toi',
            subtitle: 'Matchs, contenus, et shop qui pourraient te plaire',
          ),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RecoList(
                  title: 'Matchs à suivre',
                  items: [
                    'SEN – CIV (amical, jeudi 20:00)',
                    'SEN – EGY (qualifs, dim 18:00)',
                  ],
                  icon: Icons.sports_soccer_outlined,
                ),
                const SizedBox(height: 10),
                const _RecoList(
                  title: 'Contenus Inside',
                  items: [
                    'Séance pressing à Diamniadio',
                    'Brief vidéo : axe droit en feu',
                  ],
                  icon: Icons.play_circle_outline,
                ),
                const SizedBox(height: 10),
                const _RecoList(
                  title: 'Boutique – pour le match',
                  items: ['Maillot Home 24/25', 'Écharpe Go Gaïndé'],
                  icon: Icons.shopping_bag_outlined,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.tune_rounded),
                        label: const Text('Personnaliser'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_active_outlined),
                        label: const Text('Activer alertes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// --------- Petits composants UI ---------
class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: gaindeInk,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Opacity(
              opacity: .75,
              child: Text(
                subtitle!,
                style: const TextStyle(fontSize: 12, color: gaindeInk),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gaindeWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

class _ToolbarRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _ToolbarRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 10),
        right,
      ],
    );
  }
}

class _FormationPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const _FormationPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Formation',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '4-3-3', child: Text('4-3-3')),
            DropdownMenuItem(value: '4-2-3-1', child: Text('4-2-3-1')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: gaindeGreen),
      label: Text(label),
      backgroundColor: gaindeGreenSoft,
      side: BorderSide(color: gaindeInk.withOpacity(.12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  final String home, away;
  final double homeG, awayG;

  const _ScoreHeader({
    required this.home,
    required this.away,
    required this.homeG,
    required this.awayG,
  });

  @override
  Widget build(BuildContext context) {
    final score = '${homeG.toStringAsFixed(1)} – ${awayG.toStringAsFixed(1)}';
    return Row(
      children: [
        _Badge(team: home, color: gaindeGreen),
        const Spacer(),
        Text(
          score,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        _Badge(team: away, color: Colors.black87),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String team;
  final Color color;
  const _Badge({required this.team, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      child: Text(
        team,
        style: TextStyle(fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}

class _XgBars extends StatelessWidget {
  final double homeXg, awayXg;
  const _XgBars({required this.homeXg, required this.awayXg});

  @override
  Widget build(BuildContext context) {
    final total = (homeXg + awayXg).clamp(0.001, 999.0);
    final h = (homeXg / total).clamp(0.0, 1.0);
    final a = (awayXg / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'xG répartitions',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            FractionallySizedBox(
              widthFactor: h,
              alignment: Alignment.centerLeft,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: gaindeGreen,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text('SEN: ${homeXg.toStringAsFixed(2)}'),
            const Spacer(),
            Text('MAR: ${awayXg.toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min, max, step;
  final ValueChanged<double> onChanged;

  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(value.toStringAsFixed(2)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) / step).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _RiskRow extends StatelessWidget {
  final String name;
  final double risk; // 0..1
  final double load; // 0..1
  const _RiskRow({required this.name, required this.risk, required this.load});

  @override
  Widget build(BuildContext context) {
    final riskColor = risk >= .25
        ? gaindeRed
        : (risk >= .15 ? gaindeGold : gaindeGreen);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: riskColor.withOpacity(.15),
            child: Icon(Icons.monitor_heart_outlined, color: riskColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                _GaugeLine(label: 'Risque', value: risk, color: riskColor),
                const SizedBox(height: 4),
                _GaugeLine(label: 'Charge', value: load, color: Colors.black87),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _Pill(text: '${(risk * 100).round()} %'),
        ],
      ),
    );
  }
}

class _GaugeLine extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _GaugeLine({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: .7,
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 3),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            FractionallySizedBox(
              widthFactor: v,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: gaindeInk.withOpacity(.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _RecoList extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;
  const _RecoList({
    required this.title,
    required this.items,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.primary.withOpacity(.18)),
            ),
            child: Row(
              children: [
                Icon(icon, color: cs.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    items[i],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// --------- Mini terrain (CustomPainter + chips) ---------
class _MiniPitch extends StatelessWidget {
  final List<String> names;
  const _MiniPitch({required this.names});

  @override
  Widget build(BuildContext context) {
    assert(names.length == 11, 'Il faut exactement 11 noms.');
    // Map lignes par formation (on calcule via _names directement)
    // Déduire 4-2-3-1 vs 4-3-3 par longueur de lignes mid/attack.
    final is4231 =
        names[5] != '' &&
        names[6] != '' &&
        names[7] == 'Diatta' &&
        names[10] == 'Mané';
    // En pratique, on s’appuie sur _formation côté page.

    // 4-3-3:
    var rows = [
      [names[0]], // GK
      [names[1], names[2], names[3], names[4]], // back 4
      [names[5], names[6], names[7]], // mid 3
      [names[8], names[9], names[10]], // front 3
    ];
    if (is4231) {
      rows = [
        [names[0]],
        [names[1], names[2], names[3], names[4]],
        [names[5], names[6]], // double pivot
        [names[7], names[8], names[9]], // 3 offensifs
        [names[10]], // 1 pointe
      ];
    }

    final chips = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      final y = (i + 1) / (rows.length + 1);
      final line = rows[i];
      for (var j = 0; j < line.length; j++) {
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
        child: CustomPaint(
          painter: _PitchPainter(),
          child: Stack(children: chips),
        ),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grass = Paint()..color = gaindeGreen.withOpacity(.15);
    final line = Paint()
      ..color = Colors.white.withOpacity(.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fieldRect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    canvas.drawRect(Offset.zero & size, grass);
    canvas.drawRect(fieldRect, line);

    // Rond central
    final center = fieldRect.center;
    canvas.drawCircle(center, 28, line);
    canvas.drawCircle(center, 2.2, line);

    // Surfaces
    final boxW = fieldRect.width * .6;
    final smallW = fieldRect.width * .3;

    final topBox = Rect.fromLTWH(
      fieldRect.center.dx - boxW / 2,
      fieldRect.top,
      boxW,
      fieldRect.height * .22,
    );
    final topSix = Rect.fromLTWH(
      fieldRect.center.dx - smallW / 2,
      fieldRect.top,
      smallW,
      fieldRect.height * .12,
    );
    canvas.drawRect(topBox, line);
    canvas.drawRect(topSix, line);

    final bottomBox = Rect.fromLTWH(
      fieldRect.center.dx - boxW / 2,
      fieldRect.bottom - fieldRect.height * .22,
      boxW,
      fieldRect.height * .22,
    );
    final bottomSix = Rect.fromLTWH(
      fieldRect.center.dx - smallW / 2,
      fieldRect.bottom - fieldRect.height * .12,
      smallW,
      fieldRect.height * .12,
    );
    canvas.drawRect(bottomBox, line);
    canvas.drawRect(bottomSix, line);

    final topPenalty = Offset(
      fieldRect.center.dx,
      fieldRect.top + topBox.height * .66,
    );
    final bottomPenalty = Offset(
      fieldRect.center.dx,
      fieldRect.bottom - bottomBox.height * .66,
    );
    canvas.drawCircle(topPenalty, 2.2, line);
    canvas.drawCircle(bottomPenalty, 2.2, line);

    final arcRadius = 24.0;
    final topArc = Rect.fromCircle(
      center: Offset(fieldRect.center.dx, topBox.bottom),
      radius: arcRadius,
    );
    final bottomArc = Rect.fromCircle(
      center: Offset(fieldRect.center.dx, bottomBox.top),
      radius: arcRadius,
    );
    canvas.drawArc(topArc, 0, 3.14159, false, line);
    canvas.drawArc(bottomArc, 3.14159, 3.14159, false, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
