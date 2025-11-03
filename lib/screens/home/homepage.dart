// lib/screens/home/homepage.dart
import 'dart:async';
import 'package:fanexp/screens/fanzone/fanprofile.dart'
    hide GlassCard, GlowButton;
import 'package:fanexp/screens/fanzone/fanzone.dart';
import 'package:fanexp/screens/match/matchHub.dart';
import 'package:fanexp/screens/player/playerAnalytics.dart';
import 'package:fanexp/screens/prediction/predictReco.dart';
import 'package:fanexp/screens/shop/shop.dart';
import 'package:fanexp/screens/timeline/timelinePage.dart';
import 'package:flutter/material.dart';

// UI réutilisables
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';

// ===============================
// 🎨 Palette Go Gaïndé (Sénégal)
// ===============================
const gaindeGreen = Color(0xFF007A33);
const gaindeRed = Color(0xFFE31E24);
const gaindeGold = Color(0xFFFFD100);
const gaindeWhite = Color(0xFFFFFFFF);
const gaindeInk = Color(0xFF0F0F0F);
const gaindeBg = Color(0xFFF6F8FB);

const gaindeGreenSoft = Color(0xFFE6F4EE);
const gaindeGoldSoft = Color(0xFFFFF4CC);
const gaindeRedSoft = Color(0xFFFFE8E8);
const gaindeLine = Color(0xFFE8ECF3);

// ---------- Page d’accueil “Hub” ----------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;

  // Prochain match (mock)
  final DateTime kickoff = DateTime.now().add(
    const Duration(days: 3, hours: 2),
  );

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: gaindeBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dégradé animé subtil
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (_, __) {
              final t = Curves.easeInOut.transform(_bgCtrl.value);
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + t * .2, -1),
                    end: Alignment(1 - t * .2, 1),
                    colors: const [gaindeBg, gaindeWhite, gaindeBg],
                  ),
                ),
              );
            },
          ),
          // Halo vert doux
          Align(
            alignment: const Alignment(0.85, -0.95),
            child: Container(
              width: size.width * .65,
              height: size.width * .65,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  stops: [0, .6, 1],
                  colors: [
                    Color(0x29007A33),
                    Color(0x14007A33),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Contenu
          CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
                    // Logo Fédé (fallback si asset absent)
                    SizedBox(
                      height: 28,
                      width: 28,
                      child: Image.asset(
                        'assets/img/federation.png',
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.sports_soccer_outlined,
                          color: gaindeGreen,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'GoGaïndé',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: gaindeInk,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: gaindeInk,
                    ),
                  ),
                ],
              ),

              // HERO “modules clés” + prochain match
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _MegaHero(
                    kickoff: kickoff,
                    onMatch: () => _open(context, /*const MatchHub()*/ null),
                    onTimeline: () =>
                        _open(context, /*const TimelinePage()*/ null),
                    onFanZone: () => _open(context, /*const Fanzone()*/ null),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              // Bandeau KPI “état du moment”
              SliverToBoxAdapter(child: _KpiStrip()),

              // const SliverToBoxAdapter(child: SizedBox(height: 8)),
              // Modules Grid — met en scène tous les grands modules
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ModulesGrid(
                    tiles: [
                      ModuleTileData(
                        imageAsset: 'assets/img/matchhub.jpg',
                        label: 'Match Hub',
                        onTap: () => _open(context, MatchHub()),
                        accent: gaindeGreen,
                      ),
                      ModuleTileData(
                        imageAsset: 'assets/img/yallapitie.jpeg',
                        label: 'Timeline',
                        onTap: () => _open(context, TimelinePage()),
                        accent: gaindeGold,
                      ),
                      ModuleTileData(
                        imageAsset: 'assets/img/fanzone.jpeg',
                        label: 'Fan Zone',
                        onTap: () => _open(context, Fanzone()),
                        accent: gaindeRed,
                      ),
                      ModuleTileData(
                        imageAsset: 'assets/img/analyticsjoueur.jpg',
                        label: 'Stats',
                        onTap: () => _open(context, PlayerAnalytics()),
                        accent: gaindeGreen,
                      ),
                      ModuleTileData(
                        imageAsset: 'assets/img/boutique.webp',
                        label: 'Boutique',
                        onTap: () => _open(context, const Shop()),
                        accent: gaindeInk,
                      ),

                      ModuleTileData(
                        imageAsset: 'assets/img/predictor.webp',
                        label: 'Prédictions & Recos',
                        onTap: () => _open(context, PredictionReco()),
                        accent: gaindeGold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget? page) {
    if (page == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Branche l’import de la page cible.')),
      );
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

// ===================== Sections / Widgets =====================

// Mega hero : prochain match + trois CTA modules
class _MegaHero extends StatefulWidget {
  final DateTime kickoff;
  final VoidCallback onMatch, onTimeline, onFanZone;
  const _MegaHero({
    required this.kickoff,
    required this.onMatch,
    required this.onTimeline,
    required this.onFanZone,
  });

  @override
  State<_MegaHero> createState() => _MegaHeroState();
}

class _MegaHeroState extends State<_MegaHero> {
  late Timer _timer;
  late Duration _remain;

  @override
  void initState() {
    super.initState();
    _remain = widget.kickoff.difference(DateTime.now());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) =>
          setState(() => _remain = widget.kickoff.difference(DateTime.now())),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    if (d.isNegative) return 'En approche';
    final days = d.inDays;
    final h = d.inHours % 24;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return 'J-$days ${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      background: gaindeWhite,
      borderColor: Colors.black.withOpacity(.06),
      shadowColor: Colors.black.withOpacity(.08),
      blur: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre + timer
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Prochain match',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: gaindeInk,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 18,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _fmt(_remain),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: gaindeInk,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Duel
          Row(
            children: const [
              _TeamBadge(name: 'Sénégal', flagAsset: 'assets/img/senegal.png'),
              Spacer(),
              Text('vs', style: TextStyle(fontSize: 16, color: Colors.black54)),
              Spacer(),
              _TeamBadge(name: 'Maroc', flagAsset: 'assets/img/maroc.png'),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String name, flagAsset;
  const _TeamBadge({required this.name, required this.flagAsset});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(flagAsset),
          onBackgroundImageError: (_, __) {},
          backgroundColor: gaindeGreenSoft,
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700, color: gaindeInk),
        ),
      ],
    );
  }
}

// KPI strip (ex: fans en ligne, nouveaux posts, promos shop)
class _KpiStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: EdgeInsets.only(left: 16, right: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _KpiPill(
            icon: Icons.wifi_tethering,
            label: 'Fans en ligne',
            value: '1.2k',
          ),
          SizedBox(width: 8),
          _KpiPill(
            icon: Icons.dynamic_feed_rounded,
            label: 'Nouveaux posts',
            value: '87',
          ),
          SizedBox(width: 8),
          _KpiPill(
            icon: Icons.local_offer_rounded,
            label: 'Promo Shop',
            value: '-15%',
          ),
        ],
      ),
    );
  }
}

class _KpiPill extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _KpiPill({
    required this.icon,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: gaindeGreen.withOpacity(.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: gaindeGreen.withOpacity(.2)),
            ),
            padding: const EdgeInsets.all(0),
            child: Icon(icon, color: gaindeGreen),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: gaindeInk,
                  ),
                ),
                Opacity(
                  opacity: .7,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== MODULES GRID (IMAGE VERSION) ====================

class ModuleTileData {
  final String imageAsset; // ex: 'assets/img/modules/matchhub.jpg'
  final String label; // ex: 'Match Hub'
  final VoidCallback onTap; // navigation
  final Color? accent; // optionnel: couleur de survol/contour

  ModuleTileData({
    required this.imageAsset,
    required this.label,
    required this.onTap,
    this.accent,
  });
}

class _ModulesGrid extends StatelessWidget {
  final List<ModuleTileData> tiles;
  const _ModulesGrid({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, cons) {
        // largeur cible par carte ~ 138 px (ajuste si besoin)
        const target = 138.0;
        int cols = (cons.maxWidth / target).floor().clamp(2, 4);
        if (cons.maxWidth > 950) cols = 5;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (_, i) => _ModuleTile(data: tiles[i]),
        );
      },
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final ModuleTileData data;
  const _ModuleTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.accent ?? Colors.black.withOpacity(.28);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: data.onTap,
      child: GlassCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image plein cadre
              Image.asset(
                data.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: gaindeLine,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined, color: gaindeInk),
                ),
              ),
              // Voile dégradé pour lisibilité du label
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x40000000),
                      Color(0x66000000),
                    ],
                  ),
                ),
              ),
              // Contour léger à la couleur d’accent (optionnel)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: accent.withOpacity(.35)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              // Label en bas
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Text(
                  data.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
                  ),
                ),
              ),
              // Ripple propre
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(onTap: data.onTap),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Live compact (placeholder)
class LiveCompactCard extends StatelessWidget {
  final bool isLive;
  const LiveCompactCard({super.key, required this.isLive});

  @override
  Widget build(BuildContext context) {
    if (!isLive) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                _LiveTag(),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '67’ – Sénégal 1–0 Maroc',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: gaindeInk,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                _LiveEvent(icon: Icons.sports_soccer, label: 'But Dia 43’'),
                SizedBox(width: 16),
                _LiveEvent(
                  icon: Icons.warning_amber_rounded,
                  label: 'Jaune Hakimi 52’',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(
                  child: _XgBar(value: .65, team: 'SEN', color: gaindeGreen),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _XgBar(value: .35, team: 'MAR', color: gaindeInk),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveTag extends StatelessWidget {
  const _LiveTag();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: gaindeRedSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'LIVE',
        style: TextStyle(color: gaindeRed, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _LiveEvent extends StatelessWidget {
  final IconData icon;
  final String label;
  const _LiveEvent({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: gaindeInk),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
        ],
      ),
    );
  }
}

class _XgBar extends StatelessWidget {
  final double value; // 0..1
  final String team;
  final Color color;
  const _XgBar({required this.value, required this.team, required this.color});
  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Stack(
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
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              team,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: gaindeInk,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Teasers actualités / inside / conférence
class _InsideTeasers extends StatelessWidget {
  const _InsideTeasers();
  @override
  Widget build(BuildContext context) {
    const cards = [
      _NewsCard(
        title: "Inside • Diamniadio",
        tag: "Inside",
        image: 'assets/img/train.avif',
      ),
      _NewsCard(
        title: "Conf’ de presse : 5 points",
        tag: "Officiel",
        image: 'assets/img/conference.jpeg',
      ),
      _NewsCard(
        title: "Top 5 actions vs Égypte (90s)",
        tag: "Highlights",
        image: 'assets/img/team.jpeg',
      ),
    ];
    return SizedBox(
      height: 182,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => cards[i],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title, tag, image;
  const _NewsCard({
    required this.title,
    required this.tag,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final Color tagBg = switch (tag) {
      'Inside' => gaindeGreen,
      'Officiel' => gaindeGold,
      'Highlights' => gaindeRed,
      _ => gaindeInk,
    };
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GlassCard(
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: gaindeLine,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_outlined, color: gaindeInk),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tagBg.withOpacity(.9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  shadows: [Shadow(blurRadius: 14, color: Colors.black54)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Spotlight joueur avec CTA vers analytics
class _PlayerSpotlight extends StatelessWidget {
  final VoidCallback onTapAnalytics;
  const _PlayerSpotlight({required this.onTapAnalytics});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/img/iso.jpeg',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90,
                height: 90,
                color: gaindeLine,
                alignment: Alignment.center,
                child: const Icon(Icons.person_outline, color: gaindeInk),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: _PlayerMeta(
              name: 'Ismaïla Sarr',
              stat1Label: 'Forme',
              stat1Value: .8,
              stat1Color: gaindeGreen,
              stat2Label: 'Vitesse',
              stat2Value: .7,
              stat2Color: gaindeInk,
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: onTapAnalytics,
            icon: const Icon(Icons.analytics_rounded, size: 18),
            label: const Text('Analytics'),
          ),
        ],
      ),
    );
  }
}

class _PlayerMeta extends StatelessWidget {
  final String name;
  final String stat1Label;
  final double stat1Value;
  final Color stat1Color;
  final String stat2Label;
  final double stat2Value;
  final Color stat2Color;
  const _PlayerMeta({
    required this.name,
    required this.stat1Label,
    required this.stat1Value,
    required this.stat1Color,
    required this.stat2Label,
    required this.stat2Value,
    required this.stat2Color,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(opacity: .7, child: Text('Joueur à suivre')),
        const SizedBox(height: 4),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: gaindeInk,
          ),
        ),
        const SizedBox(height: 8),
        _StatLine(label: stat1Label, value: stat1Value, color: stat1Color),
        const SizedBox(height: 4),
        _StatLine(label: stat2Label, value: stat2Value, color: stat2Color),
      ],
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _StatLine({
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
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            FractionallySizedBox(
              widthFactor: v,
              child: Container(
                height: 6,
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

// IA Résumé + Alertes
class AiSummaryAndAlerts extends StatelessWidget {
  const AiSummaryAndAlerts({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Résumé IA du dernier match',
              style: TextStyle(fontWeight: FontWeight.w700, color: gaindeInk),
            ),
            const SizedBox(height: 8),
            const _Bullet(
              text:
                  'Pressing haut efficace, récupération dans le dernier tiers.',
            ),
            const _Bullet(
              text: 'Côté droit en surperformance (progression + xThreat).',
            ),
            const _Bullet(text: 'Entrées décisives à la 60–75e.'),
            const SizedBox(height: 12),
            const Text(
              'Alertes intelligentes',
              style: TextStyle(fontWeight: FontWeight.w700, color: gaindeInk),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _AlertToggle(label: 'Buts'),
                _AlertToggle(label: 'Cartons'),
                _AlertToggle(label: 'Entrée joueur favori'),
                _AlertToggle(label: 'Breaking'),
              ],
            ),
            const SizedBox(height: 8),
            GlowButton(
              label: 'Personnaliser',
              onTap: () {},
              glowColor: gaindeGreen,
              bgColor: gaindeGreen,
              textColor: gaindeWhite,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.auto_awesome_rounded, size: 16, color: gaindeGold),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text, style: const TextStyle(color: gaindeInk)),
        ),
      ],
    );
  }
}

class _AlertToggle extends StatefulWidget {
  final String label;
  const _AlertToggle({required this.label});
  @override
  State<_AlertToggle> createState() => _AlertToggleState();
}

class _AlertToggleState extends State<_AlertToggle> {
  bool v = true;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: v,
      label: Text(widget.label, style: const TextStyle(color: gaindeInk)),
      onSelected: (nv) => setState(() => v = nv),
      selectedColor: gaindeGoldSoft,
      side: const BorderSide(color: gaindeGold, width: .3),
      showCheckmark: false,
    );
  }
}

// Shop mini + CTA
class _ShopMiniCarousel extends StatelessWidget {
  final VoidCallback onOpenShop;
  const _ShopMiniCarousel({required this.onOpenShop});

  @override
  Widget build(BuildContext context) {
    const items = [
      _ShopItem(title: 'Maillot 24/25', image: 'assets/img/maillot.webp'),
      _ShopItem(title: 'Écharpe Gaïndé', image: 'assets/img/echarpe.jpg'),
      _ShopItem(title: 'Casquette Lions', image: 'assets/img/cap.png'),
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => SizedBox(width: 150, child: items[i]),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GlowButton(
            label: 'Voir la boutique',
            onTap: onOpenShop,
            glowColor: gaindeGreen,
            bgColor: gaindeGreen,
            textColor: gaindeWhite,
          ),
        ),
      ],
    );
  }
}

class _ShopItem extends StatelessWidget {
  final String title, image;
  const _ShopItem({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: gaindeLine.withOpacity(.35),
                  alignment: Alignment.center,
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_outlined, color: gaindeInk),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: gaindeInk,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
