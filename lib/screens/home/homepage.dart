// lib/screens/home/homepage.dart
import 'dart:async';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/screens/archives/archives.dart';
import 'package:fanexp/screens/fanzone/fanprofile.dart'
    hide GlassCard, GlowButton;
import 'package:fanexp/screens/fanzone/fanzone.dart';
import 'package:fanexp/screens/match/matchHub.dart';
import 'package:fanexp/screens/player/playerAnalytics.dart';
import 'package:fanexp/screens/prediction/predictReco.dart';
import 'package:fanexp/screens/shop/shop.dart';
import 'package:fanexp/screens/ticket/ticketing.dart' hide GlassCard;
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

              // HERO “modules clés” + prochain match (avec Billetterie intégrée)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _MegaHero(
                    kickoff: kickoff,
                    onMatch: () => _open(context, /* const MatchHub() */ null),
                    onTimeline: () =>
                        _open(context, /* const TimelinePage() */ null),
                    onFanZone: () => _open(context, /* const Fanzone() */ null),
                    onTickets: () => _open(
                      context,
                      MatchHub(),
                    ), // ← remplace par ta page Billetterie
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              // Bandeau KPI “état du moment”
              SliverToBoxAdapter(child: _KpiStrip()),

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
                      ModuleTileData(
                        imageAsset: 'assets/img/archives.jpeg',
                        label: 'Archives',
                        onTap: () => _open(context, ArchivesEphemeridesPage()),
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

// Mega hero : prochain match + trois CTA modules + Billetterie
class _MegaHero extends StatefulWidget {
  final DateTime kickoff;
  final VoidCallback onMatch, onTimeline, onFanZone;
  final VoidCallback onTickets; // ← NEW

  const _MegaHero({
    required this.kickoff,
    required this.onMatch,
    required this.onTimeline,
    required this.onFanZone,
    required this.onTickets, // ← NEW
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

          // ===== Mini Billetterie intégré =====
          _TicketMiniLine(
            dateTime: widget.kickoff,
            stadium: 'Stade Me Abdoulaye Wade',
            city: 'Diamniadio',
            fromPriceFcfa: 5000,
            onOpenTickets: widget.onTickets,
          ),

          const SizedBox(height: 10),
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

// ===== Mini widget Billetterie (ligne compacte) =====
class _TicketMiniLine extends StatelessWidget {
  final DateTime dateTime;
  final String stadium;
  final String city;
  final int fromPriceFcfa;
  final VoidCallback onOpenTickets;

  const _TicketMiniLine({
    required this.dateTime,
    required this.stadium,
    required this.city,
    required this.fromPriceFcfa,
    required this.onOpenTickets,
  });

  String _fmtDate(DateTime d) {
    final wd = [
      'Lun.',
      'Mar.',
      'Mer.',
      'Jeu.',
      'Ven.',
      'Sam.',
      'Dim.',
    ][d.weekday - 1];
    final mo = [
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
    ][d.month - 1];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$wd ${d.day} $mo • $h:$m';
  }

  String _fcfa(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final revIdx = s.length - i;
      buf.write(s[i]);
      if (revIdx > 1 && revIdx % 3 == 1) buf.write(' ');
    }
    return '${buf.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, cons) {
        final narrow = cons.maxWidth < 360;

        final info = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.event_seat_rounded, size: 18, color: gaindeInk),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${_fmtDate(dateTime)} — $stadium, $city',
                maxLines: 3, // ← passe à 2 lignes
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11, // un peu plus lisible
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                  height: 1.3, // espacement léger entre les lignes
                ),
              ),
            ),
          ],
        );

        final price = RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'À partir de ',
                style: TextStyle(color: Colors.black54, fontSize: 10),
              ),
              TextSpan(
                text: _fcfa(fromPriceFcfa),
                style: const TextStyle(
                  fontSize: 10,
                  color: gaindeRed,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );

        final cta = SizedBox(
          height: 38,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: gaindeGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // onPressed: onOpenTickets,
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const TicketingPage())),
              icon: const Icon(Icons.confirmation_num_outlined),
              label: const Text(
                'Billetterie',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        );

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              info,
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: price),
                  const SizedBox(width: 10),
                  cta,
                ],
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            info,
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(child: price),
                const SizedBox(width: 10),
                cta,
              ],
            ),
          ],
        );
      },
    );
  }
}

// KPI strip (ex: fans en ligne, nouveaux posts, promos shop)
class _KpiStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16),
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
        // largeur cible par carte ~ 138 px
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

// (Option) Live compact — laisse si besoin
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
