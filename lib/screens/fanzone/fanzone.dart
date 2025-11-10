// import 'package:flutter/material.dart';
// import 'package:fanexp/theme/gainde_theme.dart';
// import 'package:fanexp/widgets/glasscard.dart';
// import 'package:fanexp/widgets/buttons.dart';

// class Fanzone extends StatelessWidget {
//   const Fanzone({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Fan Zone')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: const [
//           _VoteXI(),
//           SizedBox(height: 12),
//           _QuizOfDay(),
//           SizedBox(height: 12),
//           _Chants(),
//         ],
//       ),
//     );
//   }
// }

// class _VoteXI extends StatelessWidget {
//   const _VoteXI();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Vote ton 11',
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
//           const SizedBox(height: 10),
//           GlowButton(
//             label: 'Valider',
//             onTap: () {},
//             bgColor: gaindeGreen,
//             textColor: gaindeGreenSoft,
//             glowColor: gaindeGreenSoft,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _QuizOfDay extends StatelessWidget {
//   const _QuizOfDay();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Quiz du jour',
//             style: TextStyle(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 10),
//           ...List.generate(
//             3,
//             (i) => ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: const Icon(Icons.help_outline),
//               title: Text('Question ${i + 1} • …'),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () {},
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Chants extends StatelessWidget {
//   const _Chants();
//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Chants & Medleys',
//             style: TextStyle(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 10),
//           ListTile(
//             leading: const Icon(Icons.music_note),
//             title: const Text('On est les Gaïndés'),
//             trailing: IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.play_circle_outline),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.music_note),
//             title: const Text('Allez Sénégal'),
//             trailing: IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.play_circle_outline),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/screens/fanzone/fanzone.dart
import 'package:fanexp/screens/fanzone/fanprofile.dart'
    hide
        GlassCard,
        gaindeInk,
        gaindeGreenSoft,
        gaindeGold,
        gaindeGreen,
        gaindeRed;
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';

class Fanzone extends StatelessWidget {
  const Fanzone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FanZone')),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const SliverToBoxAdapter(child: _HeaderHero()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Pronostics (score + sliders + IA hint)
          const SliverToBoxAdapter(child: _ScorePredictorCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Vote Homme du match
          const SliverToBoxAdapter(child: _MotMVoteCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Quiz & mini-jeux
          const SliverToBoxAdapter(child: _GamesAndQuizCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Concours
          const SliverToBoxAdapter(child: _ContestCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Badges (mur) + progression
          const SliverToBoxAdapter(child: _BadgeWallCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Classement fans
          const SliverToBoxAdapter(child: _LeaderboardCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ---------------- Header “épuré & soft” ----------------
class _HeaderHero extends StatelessWidget {
  const _HeaderHero();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        background: Colors.white,
        borderColor: gaindeInk.withOpacity(.06),
        shadowColor: gaindeInk.withOpacity(.08),
        blur: 14,
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [gaindeGreen, gaindeGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gaindeGreen.withOpacity(.22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Fais vibrer la Tanière 🦁\nParticipe, gagne des points & débloque des badges.',
                style: TextStyle(
                  color: gaindeInk.withOpacity(.92),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            // FilledButton(
            //   onPressed: () {},
            //   style: FilledButton.styleFrom(
            //     backgroundColor: cs.primary,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 14,
            //       vertical: 10,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   child: const Text('Mon profil fan'),
            // ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Fanprofile()),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Mon profil fan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScorePredictorCard extends StatefulWidget {
  const _ScorePredictorCard();

  @override
  State<_ScorePredictorCard> createState() => _ScorePredictorCardState();
}

class _ScorePredictorCardState extends State<_ScorePredictorCard> {
  int sen = 1;
  int adv = 0;
  double conf = .72; // mock 0..1

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pronostics',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk.withOpacity(.95),
              ),
            ),
            const SizedBox(height: 8),

            // ✅ Responsive : passe en multi-lignes si l'espace est serré
            LayoutBuilder(
              builder: (context, c) {
                final narrow = c.maxWidth < 380; // seuil de wrap
                return Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    const _TeamPill(
                      flag: 'assets/img/senegal.png',
                      name: 'SEN',
                    ),

                    // Bloc score compact + auto-shrink
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        // largeur max ~ 60% si étroit, sinon 50%
                        maxWidth: narrow ? c.maxWidth * .6 : c.maxWidth * .5,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ScoreStepper(
                              value: sen,
                              onChanged: (v) => setState(() => sen = v),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(':', style: TextStyle(fontSize: 18)),
                            ),
                            _ScoreStepper(
                              value: adv,
                              onChanged: (v) => setState(() => adv = v),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const _TeamPill(flag: 'assets/img/bresil.png', name: 'BRE'),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            // Barre “proba” style split
            Row(
              children: [
                Expanded(
                  child: _SplitBar(
                    left: conf,
                    leftLabel: 'SEN',
                    rightLabel: 'MAR',
                    leftColor: cs.primary,
                    rightColor: gaindeInk,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: .8,
              child: Text(
                'Astuce IA : pressing haut & transitions rapides → avantage Sénégal.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () {
                  _snack(context, 'Pronostic enregistré: $sen – $adv ✅');
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Valider'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// (inchangés) _TeamPill / _ScoreStepper / _SplitBar / _snack

class _TeamPill extends StatelessWidget {
  final String flag;
  final String name;
  const _TeamPill({required this.flag, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: gaindeGreenSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: gaindeInk.withOpacity(.08)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 10, backgroundImage: AssetImage(flag)),
          const SizedBox(width: 6),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ScoreStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _ScoreStepper({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gaindeInk.withOpacity(.12)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => onChanged((value - 1).clamp(0, 20)),
            icon: const Icon(Icons.remove),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          ),
          SizedBox(
            width: 28,
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          IconButton(
            onPressed: () => onChanged((value + 1).clamp(0, 20)),
            icon: const Icon(Icons.add),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          ),
        ],
      ),
    );
  }
}

class _SplitBar extends StatelessWidget {
  final double left; // 0..1
  final String leftLabel;
  final String rightLabel;
  final Color leftColor;
  final Color rightColor;
  const _SplitBar({
    required this.left,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftColor,
    required this.rightColor,
  });

  @override
  Widget build(BuildContext context) {
    final v = left.clamp(0.0, 1.0);
    return Stack(
      children: [
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        FractionallySizedBox(
          widthFactor: v.toDouble(), // assure un double
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: leftColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tag(leftLabel, leftColor),
              _tag(rightLabel, rightColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tag(String t, Color c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(.25)),
      ),
      child: Text(
        t,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: c.withOpacity(.95),
        ),
      ),
    );
  }
}

// ---------------- Vote Homme du match ----------------
class _MotMVoteCard extends StatefulWidget {
  const _MotMVoteCard();

  @override
  State<_MotMVoteCard> createState() => _MotMVoteCardState();
}

class _MotMVoteCardState extends State<_MotMVoteCard> {
  final players = const [
    'Sadio Mané',
    'Ismaïla Sarr',
    'Kalidou Koulibaly',
    'Edouard Mendy',
  ];
  String? vote;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Homme du match',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk.withOpacity(.95),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: players.map((p) {
                final selected = vote == p;
                return ChoiceChip(
                  selected: selected,
                  label: Text(p),
                  onSelected: (_) => setState(() => vote = p),
                  selectedColor: cs.primary.withOpacity(.18),
                  side: BorderSide(
                    color: (selected ? cs.primary : gaindeInk.withOpacity(.18))
                        .withOpacity(.35),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: vote == null
                    ? null
                    : () => _snack(context, 'Vote enregistré : $vote ✅'),
                icon: const Icon(Icons.how_to_vote_rounded),
                label: const Text('Voter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Jeux & Quiz ----------------
class _GamesAndQuizCard extends StatelessWidget {
  const _GamesAndQuizCard();

  @override
  Widget build(BuildContext context) {
    final tiles = const [
      _GameTileData(
        icon: Icons.psychology_rounded,
        title: 'Quiz du jour',
        desc: '5 questions rapides • gagne des points',
      ),
      _GameTileData(
        icon: Icons.how_to_vote_rounded,
        title: 'Vote tactique',
        desc: '3-5-2 ou 4-3-3 ? Choisis ton schéma',
      ),
      _GameTileData(
        icon: Icons.emoji_events_rounded,
        title: 'Pronos express',
        desc: 'Score & buteur • bonus Gaïndé',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jeux & quiz',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk.withOpacity(.95),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: tiles
                  .map(
                    (t) => _GameTile(
                      data: t,
                      onTap: () => _openMiniGame(context, t.title),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _openMiniGame(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => _MiniGameSheet(title: title),
    );
  }
}

class _GameTileData {
  final IconData icon;
  final String title;
  final String desc;
  const _GameTileData({
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _GameTile extends StatelessWidget {
  final _GameTileData data;
  final VoidCallback onTap;
  const _GameTile({required this.data, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: gaindeInk.withOpacity(.08)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: cs.primary,
              child: const Icon(Icons.star, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Opacity(
                    opacity: .8,
                    child: Text(
                      data.desc,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _MiniGameSheet extends StatefulWidget {
  final String title;
  const _MiniGameSheet({required this.title});
  @override
  State<_MiniGameSheet> createState() => _MiniGameSheetState();
}

class _MiniGameSheetState extends State<_MiniGameSheet> {
  int step = 0;
  int score = 0;

  @override
  Widget build(BuildContext context) {
    final isQuiz = widget.title.contains('Quiz');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 12),
          if (isQuiz) _quizStep(context) else _voteTactic(context),

          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  if (isQuiz) {
                    setState(() {
                      score += 20; // mock points
                      step++;
                    });
                    if (step >= 3) {
                      _snack(context, 'Quiz terminé • +$score pts 🎉');
                      Navigator.pop(context);
                    }
                  } else {
                    _snack(context, 'Choix enregistré • +10 pts 🎯');
                    Navigator.pop(context);
                  }
                },
                child: Text(isQuiz ? 'Suivant' : 'Valider'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quizStep(BuildContext context) {
    final qs = [
      ('Combien de tirs cadrés au dernier match ?', ['2', '4', '7', '9']),
      ('Quel schéma utilisé en 2e mi-temps ?', ['4-3-3', '3-5-2', '4-2-3-1']),
      ('Qui a touché le plus de ballons ?', ['Mendy', 'Koulibaly', 'Sarr']),
    ];
    final (q, opts) = qs[step % qs.length];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: opts
              .map(
                (o) => ChoiceChip(
                  selected: false,
                  onSelected: (_) {},
                  label: Text(o),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _voteTactic(BuildContext context) {
    final tactics = ['4-3-3', '3-5-2', '4-2-3-1'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choisis le schéma préféré',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tactics
              .map(
                (t) => FilterChip(
                  selected: false,
                  onSelected: (_) {},
                  label: Text(t),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ---------------- Concours ----------------
class _ContestCard extends StatelessWidget {
  const _ContestCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Concours Gaïndé',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk.withOpacity(.95),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ContestTile(
                    title: 'Super Pronos',
                    desc: 'Classement hebdo • lots officiels',
                    icon: Icons.emoji_events_rounded,
                    color: gaindeGold,
                    onTap: () => _snack(context, 'Inscription au concours ✅'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ContestTile(
                    title: 'Fan Créatif',
                    desc: 'Meilleur chant / visuel du mois',
                    icon: Icons.color_lens_rounded,
                    color: gaindeGreen,
                    onTap: () => _snack(context, 'Participation envoyée ✅'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Règlement simplifié • 18+',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContestTile extends StatelessWidget {
  final String title, desc;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ContestTile({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(.12),
          border: Border.all(color: gaindeInk.withOpacity(.08)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color,
              child: const Icon(Icons.star, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Opacity(
                    opacity: .8,
                    child: Text(
                      desc,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

// ---------------- Badges & progression ----------------
class _BadgeWallCard extends StatelessWidget {
  const _BadgeWallCard();

  @override
  Widget build(BuildContext context) {
    final badges = const [
      _BadgeData('Rookie', Icons.whatshot_rounded, gaindeGreen),
      _BadgeData('Scout', Icons.visibility_rounded, gaindeGold),
      _BadgeData('Stratège', Icons.psychology_rounded, gaindeInk),
      _BadgeData('Légende', Icons.emoji_events_rounded, gaindeRed),
      _BadgeData('Ultra', Icons.bolt_rounded, gaindeGreen),
      _BadgeData('Créatif', Icons.brush_rounded, gaindeGold),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes badges',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk.withOpacity(.95),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: badges.map((b) => _BadgeChip(data: b)).toList(),
            ),
            const SizedBox(height: 12),
            const _ProgressLine(label: 'Niveau fan', value: .62),
          ],
        ),
      ),
    );
  }
}

class _BadgeData {
  final String label;
  final IconData icon;
  final Color color;
  const _BadgeData(this.label, this.icon, this.color);
}

class _BadgeChip extends StatelessWidget {
  final _BadgeData data;
  const _BadgeChip({required this.data});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: data.color,
        child: const Icon(Icons.star, color: Colors.white, size: 16),
      ),
      label: Text(data.label),
      side: BorderSide(color: gaindeInk.withOpacity(.12)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final String label;
  final double value; // 0..1
  const _ProgressLine({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label • ${(v * 100).round()}%',
          style: const TextStyle(fontWeight: FontWeight.w700),
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
              widthFactor: v.toDouble(),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [gaindeGreen, gaindeGold],
                  ),
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

// ---------------- Leaderboard fans ----------------
class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard();

  @override
  Widget build(BuildContext context) {
    final rows = const [
      _RankRow('#1', 'Moussa', 1240),
      _RankRow('#2', 'Aïda', 1190),
      _RankRow('#3', 'Ibrahima', 990),
      _RankRow('#4', 'Aminata', 930),
      _RankRow('#5', 'Fatou', 880),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Classement des fans',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk.withOpacity(.95),
              ),
            ),
            const SizedBox(height: 8),
            ...rows.map((r) => _RankTile(row: r)).toList(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.leaderboard_rounded),
                label: const Text('Voir tout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankRow {
  final String rank;
  final String name;
  final int points;
  const _RankRow(this.rank, this.name, this.points);
}

class _RankTile extends StatelessWidget {
  final _RankRow row;
  const _RankTile({required this.row});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Text(
        row.rank,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
      ),
      title: Text(
        row.name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flash_on_rounded, size: 16, color: gaindeGold),
          const SizedBox(width: 4),
          Text(
            '${row.points} pts',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ---------------- Utils ----------------
void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
