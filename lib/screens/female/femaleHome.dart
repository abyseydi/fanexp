import 'package:flutter/material.dart';

const gaindeGreen = Color(0xFF007A33);
const gaindeRed = Color(0xFFE31E24);
const gaindeGold = Color(0xFFFFD100);
const gaindeWhite = Color(0xFFFFFFFF);
const gaindeInk = Color(0xFF0F0F0F);
const gaindeBg = Color(0xFFF6F8FB);
const gaindeLine = Color(0xFFE8ECF3);
const gaindeGreenSoft = Color(0xFFE6F4EE);

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? background;
  final Color? borderColor;
  final Color? shadowColor;
  final double blur;
  final EdgeInsets padding;

  const GlassCard({
    super.key,
    required this.child,
    this.background,
    this.borderColor,
    this.shadowColor,
    this.blur = 12,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: (background ?? Colors.white).withOpacity(.96),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (borderColor ?? Colors.black12).withOpacity(.06),
        ),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? Colors.black12).withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color glowColor;
  final Color bgColor;
  final Color textColor;

  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.glowColor,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(.45),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}

class FemFootballHub extends StatelessWidget {
  const FemFootballHub({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: gaindeBg,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: gaindeBg,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: gaindeGreen.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.female, color: gaindeGreen, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Foot féminin',
                style: TextStyle(fontWeight: FontWeight.w900, color: gaindeInk),
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: gaindeGreen,
            indicatorWeight: 3,
            labelColor: gaindeGreen,
            unselectedLabelColor: Colors.black54,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Matchs'),
              Tab(text: 'Joueuses'),
              Tab(text: 'Compétitions'),
              Tab(text: 'Fan zone'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FemMatchesTab(),
            FemPlayersTab(),
            FemCompetitionsTab(),
            FemFanZoneTab(),
          ],
        ),
      ),
    );
  }
}

class FemMatchesTab extends StatelessWidget {
  const FemMatchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final upcoming = [
      _FemMatch(
        opponent: 'Maroc',
        competition: 'Amical international',
        date: DateTime.now().add(const Duration(days: 5)),
        city: 'Dakar',
        stadium: 'Stade Lat Dior',
        isHome: true,
      ),
      _FemMatch(
        opponent: 'Nigeria',
        competition: 'Élim. CAN Féminine',
        date: DateTime.now().add(const Duration(days: 18)),
        city: 'Abuja',
        stadium: 'Moshood Abiola Stadium',
        isHome: false,
      ),
    ];

    final lastResults = [
      _FemMatch(
        opponent: 'Côte d’Ivoire',
        competition: 'Amical',
        date: DateTime.now().subtract(const Duration(days: 7)),
        city: 'Dakar',
        stadium: 'Me Abdoulaye Wade',
        isHome: true,
        score: '2 - 1',
      ),
      _FemMatch(
        opponent: 'Ghana',
        competition: 'Tournoi UFA',
        date: DateTime.now().subtract(const Duration(days: 21)),
        city: 'Accra',
        stadium: 'Accra Sports Stadium',
        isHome: false,
        score: '0 - 0',
      ),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          GlassCard(
            background: gaindeGreenSoft,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Prochain match des Lionnes',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: gaindeInk,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Suis en temps réel le calendrier, les groupes et les temps forts de l’équipe féminine A.',
                        style: TextStyle(color: Colors.black87, height: 1.35),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.sports_soccer_rounded,
                  color: gaindeGreen.withOpacity(.9),
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle('À venir'),
          const SizedBox(height: 8),
          ...upcoming.map((m) => _FemMatchCard(match: m)),
          const SizedBox(height: 20),
          const _SectionTitle('Derniers résultats'),
          const SizedBox(height: 8),
          ...lastResults.map((m) => _FemMatchCard(match: m)),
        ],
      ),
    );
  }
}

class _FemMatch {
  final String opponent;
  final String competition;
  final DateTime date;
  final String city;
  final String stadium;
  final bool isHome;
  final String? score;

  _FemMatch({
    required this.opponent,
    required this.competition,
    required this.date,
    required this.city,
    required this.stadium,
    required this.isHome,
    this.score,
  });
}

class _FemMatchCard extends StatelessWidget {
  final _FemMatch match;
  const _FemMatchCard({required this.match});

  String _fmtDate(DateTime d) {
    const wd = ['Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.', 'Dim.'];
    const mo = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${wd[d.weekday - 1]} ${d.day} ${mo[d.month - 1]} • $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final homeLabel = match.isHome ? 'Sénégal (F)' : match.opponent;
    final awayLabel = match.isHome ? match.opponent : 'Sénégal (F)';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.competition,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TeamRow(name: homeLabel, isSenegal: match.isHome),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'vs',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Expanded(
                  child: _TeamRow(
                    name: awayLabel,
                    isSenegal: !match.isHome,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  _fmtDate(match.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.black45,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${match.stadium}, ${match.city}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              ],
            ),
            if (match.score != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: gaindeGreen.withOpacity(.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Score final : ${match.score}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: gaindeInk,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  final String name;
  final bool isSenegal;
  final bool alignEnd;

  const _TeamRow({
    required this.name,
    this.isSenegal = false,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final flag = isSenegal
        ? Container(
            width: 28,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF00853F), // vert
                  Color(0xFFFFD100), // jaune
                  Color(0xFFDA1212), // rouge
                ],
              ),
            ),
          )
        : Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: gaindeLine,
            ),
            child: const Icon(Icons.flag_outlined, size: 12, color: gaindeInk),
          );

    final text = Text(
      name,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: isSenegal ? gaindeInk : Colors.black87,
      ),
      textAlign: alignEnd ? TextAlign.right : TextAlign.left,
    );

    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: alignEnd
          ? [text, const SizedBox(width: 6), flag]
          : [flag, const SizedBox(width: 6), Expanded(child: text)],
    );
  }
}

class FemPlayersTab extends StatelessWidget {
  const FemPlayersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final topPlayers = [
      _FemPlayer(
        name: 'Awa Diop',
        position: 'Attaquante',
        club: 'OL Féminin',
        goals: 7,
        assists: 3,
        minutes: 540,
        rating: 7.6,
      ),
      _FemPlayer(
        name: 'Fatou Sarr',
        position: 'Milieu défensive',
        club: 'Jaraaf Féminin',
        goals: 1,
        assists: 2,
        minutes: 720,
        rating: 7.4,
      ),
      _FemPlayer(
        name: 'Khadija Faye',
        position: 'Gardienne',
        club: 'Casa Sports Féminin',
        goals: 0,
        assists: 0,
        minutes: 630,
        rating: 7.8,
      ),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const _SectionTitle('Vue d’ensemble'),
          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(
                child: _KpiCard(
                  label: 'Joueuses sélectionnées',
                  value: '23',
                  subtitle: '+3 vs. dernier rassemblement',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _KpiCard(
                  label: 'Âge moyen',
                  value: '24,7 ans',
                  subtitle: 'Profil jeune & compétitif',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _KpiCard(
                  label: 'Buts / 90 min',
                  value: '1,8',
                  subtitle: 'Derniers 10 matchs',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _KpiCard(
                  label: 'xG créés / match',
                  value: '1,3',
                  subtitle: 'Données analytiques',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Joueuses clés'),
          const SizedBox(height: 8),
          ...topPlayers.map((p) => _FemPlayerCard(player: p)),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: gaindeInk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _FemPlayer {
  final String name;
  final String position;
  final String club;
  final int goals;
  final int assists;
  final int minutes;
  final double rating;

  _FemPlayer({
    required this.name,
    required this.position,
    required this.club,
    required this.goals,
    required this.assists,
    required this.minutes,
    required this.rating,
  });
}

class _FemPlayerCard extends StatelessWidget {
  final _FemPlayer player;
  const _FemPlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    gaindeGreen.withOpacity(.9),
                    gaindeGreen.withOpacity(.6),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.person_rounded, color: gaindeWhite),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: gaindeInk,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${player.position} • ${player.club}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.sports_soccer_rounded,
                        label: '${player.goals} buts',
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.assistant_rounded,
                        label: '${player.assists} passes',
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.timer_rounded,
                        label: '${player.minutes} min',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                const Text(
                  'Note',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gaindeGreen.withOpacity(.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    player.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: gaindeGreen,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: gaindeGreen.withOpacity(.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: gaindeGreen.withOpacity(.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: gaindeGreen),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class FemCompetitionsTab extends StatelessWidget {
  const FemCompetitionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final competitions = [
      _FemCompetition(
        name: 'CAN Féminine',
        season: '2024',
        stage: 'Qualifications – Groupe B',
        nextFixture: 'SEN (F) vs NIG (F)',
        progress: 0.6,
      ),
      _FemCompetition(
        name: 'Mondial Féminin',
        season: '2027',
        stage: 'Préparation / matches amicaux',
        nextFixture: 'SEN (F) vs MAR (F)',
        progress: 0.2,
      ),
      _FemCompetition(
        name: 'Championnat local féminin',
        season: '2024-2025',
        stage: 'Suivi des performances locales',
        nextFixture: 'Suivi des clubs (Jaraaf, Casa, etc.)',
        progress: 0.35,
      ),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const _SectionTitle('Compétitions suivies'),
          const SizedBox(height: 8),
          ...competitions.map((c) => _FemCompetitionCard(comp: c)),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vision analytique',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: gaindeInk,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Connecte cette section à ton backend pour suivre automatiquement :\n'
                  '• Classements\n'
                  '• Probabilité de qualification\n'
                  '• Série de victoires / défaites\n'
                  '• Charge de match (minutes jouées par joueuse)',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                GlowButton(
                  label: 'Configurer les compétitions',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Brancher plus tard sur un écran de paramètres.',
                        ),
                      ),
                    );
                  },
                  glowColor: gaindeGreen,
                  bgColor: gaindeGreen,
                  textColor: gaindeWhite,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FemCompetition {
  final String name;
  final String season;
  final String stage;
  final String nextFixture;
  final double progress;

  _FemCompetition({
    required this.name,
    required this.season,
    required this.stage,
    required this.nextFixture,
    required this.progress,
  });
}

class _FemCompetitionCard extends StatelessWidget {
  final _FemCompetition comp;
  const _FemCompetitionCard({required this.comp});

  @override
  Widget build(BuildContext context) {
    final pct = (comp.progress * 100).clamp(0, 100).toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comp.name,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Saison ${comp.season}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              comp.stage,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: gaindeGreen,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Prochaine échéance : ${comp.nextFixture}',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: comp.progress.clamp(0.0, 1.0),
                minHeight: 7,
                backgroundColor: gaindeLine,
                valueColor: const AlwaysStoppedAnimation<Color>(gaindeGreen),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$pct % du parcours',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FemFanZoneTab extends StatelessWidget {
  const FemFanZoneTab({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      _FemFanPost(
        author: 'Ndeye - Dakar',
        title: 'Tifo spécial pour le prochain match des Lionnes',
        content:
            'On prépare une animation en vert-jaune-rouge uniquement pour l’équipe féminine. '
            'Partage tes idées de messages pour la bâche principale !',
        likes: 128,
        comments: 23,
      ),
      _FemFanPost(
        author: 'Fatou - Saint-Louis',
        title: 'Album chants des Lionnes',
        content:
            'On recense les chants dédiés à l’équipe féminine pour les diffuser sur GoGaïndé. '
            'Ajoute les tiens pour qu’ils soient repris au stade.',
        likes: 87,
        comments: 14,
      ),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          GlassCard(
            background: gaindeWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Communauté des Lionnes',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: gaindeInk,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Un espace dédié aux supporters de l’équipe féminine : idées de tifos, chants, messages de soutien et votes pour la joueuse du match.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                GlowButton(
                  label: 'Proposer un contenu',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Plus tard: rediriger vers un écran de création de post.',
                        ),
                      ),
                    );
                  },
                  glowColor: gaindeGreen,
                  bgColor: gaindeGreen,
                  textColor: gaindeWhite,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _SectionTitle('Derniers posts'),
          const SizedBox(height: 8),
          ...posts.map((p) => _FemFanPostCard(post: p)),
        ],
      ),
    );
  }
}

class _FemFanPost {
  final String author;
  final String title;
  final String content;
  final int likes;
  final int comments;

  _FemFanPost({
    required this.author,
    required this.title,
    required this.content,
    required this.likes,
    required this.comments,
  });
}

class _FemFanPostCard extends StatelessWidget {
  final _FemFanPost post;
  const _FemFanPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gaindeGreen.withOpacity(.15),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: gaindeGreen,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.author,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: gaindeInk,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: gaindeGreen.withOpacity(.06),
                  ),
                  child: const Text(
                    'Lionnes',
                    style: TextStyle(
                      fontSize: 11,
                      color: gaindeGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: gaindeInk,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 18,
                  color: Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.likes}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.comments}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
        color: gaindeInk,
      ),
    );
  }
}
