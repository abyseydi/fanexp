// lib/screens/timeline/timeline_page.dart
import 'package:fanexp/widgets/gaindeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';

// class TimelinePage extends StatelessWidget {
//   const TimelinePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Timeline'),
//           bottom: const TabBar(
//             isScrollable: true,
//             tabs: [
//               Tab(text: 'Fil Gaïndé'),
//               Tab(text: 'Inside Training'),
//               Tab(text: 'Auto-résumés IA'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [_GaindeFeedTab(), _InsideTrainingTab(), _AISummariesTab()],
//         ),
//       ),
//     );
//   }
// }
class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: gaindeBg,
        appBar: const GaindeAppBar(title: 'Timeline'),
        body: const TabBarView(
          children: [_GaindeFeedTab(), _InsideTrainingTab(), _AISummariesTab()],
        ),
      ),
    );
  }
}

//
// -------------------- Onglet 1 : Fil Gaïndé (stories + posts + inside clips) --------------------
//
class _GaindeFeedTab extends StatelessWidget {
  const _GaindeFeedTab();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => i);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: items.length + 2, // + stories + composer
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        if (i == 0) return const _StoriesStrip();
        if (i == 1) return const _Composer();
        // un mix de posts et clips “inside”
        final isClip = i % 3 == 0;
        return isClip ? const _InsideClipCardFeed() : const _PostCard();
      },
    );
  }
}

class _StoriesStrip extends StatelessWidget {
  const _StoriesStrip();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = [
      ('Toi', 'assets/img/senegal.png'),
      ('Sadio', 'assets/img/sadio.jpeg'),
      ('Ismaïla', 'assets/img/iso.jpeg'),
      ('Kalidou', 'assets/img/kalidou.jpeg'),
      ('Staff', 'assets/img/thiaw.jpeg'),
    ];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final (name, img) = items[i];
          return Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [gaindeGreen, cs.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      img,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: gaindeGreen,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Text("Partage… #GoGaïndé")),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.image_outlined),
            label: const Text('Photo'),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 16, backgroundColor: gaindeGold),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'OFFICIEL • Entraînement',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: gaindeGreenSoft,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/img/team.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: cs.onSurface.withOpacity(.8),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: cs.onSurface.withOpacity(.8),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share_outlined,
                  color: cs.onSurface.withOpacity(.8),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark_border,
                  color: cs.onSurface.withOpacity(.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsideClipCardFeed extends StatelessWidget {
  const _InsideClipCardFeed();
  @override
  Widget build(BuildContext context) {
    return _InsideClipCard(
      title: "Inside • Séquence pressing",
      subtitle: "Transitions rapides depuis la médiane",
      thumbnail: 'assets/img/train.avif',
      onPlay: () => _showMockPlayer(context, "train.avif"),
    );
  }
}

class _InsideTrainingTab extends StatelessWidget {
  const _InsideTrainingTab();

  @override
  Widget build(BuildContext context) {
    final clips = [
      (
        "Entraînement à Diamniadio",
        "Séquence pressing + transitions",
        'assets/img/train.avif',
      ),
      (
        "Jeu de position 7v7",
        "Focus couloir droit / circuits",
        'assets/img/conference.jpeg',
      ),
      (
        "Travail des CPA",
        "Corners rentrants • variations",
        'assets/img/team.jpeg',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: clips.length + 1,
      itemBuilder: (ctx, i) {
        if (i == clips.length) return const _StaffNotesCard();
        final (title, subtitle, thumb) = clips[i];
        return _InsideClipCard(
          title: "Inside • $title",
          subtitle: subtitle,
          thumbnail: thumb,
          onPlay: () => _showMockPlayer(ctx, thumb),
        );
      },
    );
  }
}

class _InsideClipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String thumbnail;
  final VoidCallback onPlay;
  const _InsideClipCard({
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: gaindeGreen,
                child: Icon(Icons.videocam, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(thumbnail, fit: BoxFit.cover),
                ),
                // Bouton play
                InkWell(
                  onTap: onPlay,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: cs.onSurface.withOpacity(.7))),
        ],
      ),
    );
  }
}

class _StaffNotesCard extends StatefulWidget {
  const _StaffNotesCard();

  @override
  State<_StaffNotesCard> createState() => _StaffNotesCardState();
}

class _StaffNotesCardState extends State<_StaffNotesCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.note_alt_outlined),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Notes du staff',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Switch(
                value: _open,
                onChanged: (v) => setState(() => _open = v),
                activeColor: gaindeGreen,
              ),
            ],
          ),
          AnimatedCrossFade(
            crossFadeState: _open
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 220),
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _NoteBullet(
                  "Pressing coordonné OK, bloc plus compact demandé à la perte.",
                ),
                _NoteBullet("Couloir droit en sur-performance (xThreat↑)."),
                _NoteBullet(
                  "Réduire espaces entre lignes sur transitions défensives.",
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _NoteBullet extends StatelessWidget {
  final String text;
  const _NoteBullet(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, size: 10, color: gaindeGreen),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

void _showMockPlayer(BuildContext context, String thumb) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(thumb, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(.15)),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                children: [
                  const Text(
                    'Lecture simulée',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AISummariesTab extends StatelessWidget {
  const _AISummariesTab();

  @override
  Widget build(BuildContext context) {
    final sessions = [
      _AISession(
        title: "Séance A • Pressing + sorties",
        date: "Hier • Diamniadio",
        bullets: const [
          "Récupérations hautes ↑, efficacité transition +15%.",
          "Couloir droit xThreat 0.32 (vs avg 0.18).",
          "Charge optimale (RPE moyen 6/10).",
        ],
        tags: const ["Pressing", "Transition", "Charge OK"],
        score: 86,
      ),
      _AISession(
        title: "Séance B • CPA offensifs",
        date: "Lun • Terrain 2",
        bullets: const [
          "Variations de corners efficaces (xG corners 0.28).",
          "Timing 2e poteau perfectible.",
        ],
        tags: const ["CPA", "Variations"],
        score: 74,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _AISummaryCard(session: sessions[i]),
    );
  }
}

class _AISession {
  final String title;
  final String date;
  final List<String> bullets;
  final List<String> tags;
  final int score; // 0..100 “Qualité séance” (exemple)

  const _AISession({
    required this.title,
    required this.date,
    required this.bullets,
    required this.tags,
    required this.score,
  });
}

class _AISummaryCard extends StatefulWidget {
  final _AISession session;
  const _AISummaryCard({required this.session});

  @override
  State<_AISummaryCard> createState() => _AISummaryCardState();
}

class _AISummaryCardState extends State<_AISummaryCard> {
  bool open = true;

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final cs = Theme.of(context).colorScheme;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ScoreBadge(score: s.score),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      s.date,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => open = !open),
                icon: Icon(open ? Icons.expand_less : Icons.expand_more),
              ),
            ],
          ),
          AnimatedCrossFade(
            crossFadeState: open
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                for (final b in s.bullets) _NoteBullet(b),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: s.tags
                      .map(
                        (t) => Chip(
                          label: Text(t),
                          backgroundColor: gaindeGreenSoft,
                          side: BorderSide(
                            color: cs.onSurface.withOpacity(.12),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.summarize_outlined),
                      label: const Text('Résumé complet'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Partager'),
                    ),
                  ],
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  const _ScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 80
        ? gaindeGreen
        : (score >= 60 ? gaindeGold : gaindeRed);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '$score/100',
            style: TextStyle(fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}
