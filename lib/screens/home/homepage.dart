import 'dart:async';
import 'package:fanexp/screens/auth/register.dart';
import 'package:fanexp/screens/female/femaleHome.dart' hide GlassCard;
import 'package:fanexp/screens/settings/settings.dart';
import 'package:fanexp/screens/timeline/view/timeline_page.dart';
import 'package:fanexp/services/match/match.service.dart';
import 'package:fanexp/widgets/matchCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/screens/fanzone/fanprofile.dart'
    hide GlassCard, GlowButton;
import 'package:fanexp/screens/fanzone/fanzone.dart';
import 'package:fanexp/screens/match/matchHub.dart';
import 'package:fanexp/screens/player/playerAnalytics.dart';
import 'package:fanexp/screens/prediction/predictReco.dart';
import 'package:fanexp/screens/shop/shop.dart';
import 'package:fanexp/screens/ticket/ticketing.dart' hide GlassCard;
import 'package:fanexp/screens/archives/archives.dart';
import 'package:fanexp/widgets/reordonnablegrid.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';

const gaindeGreen = Color(0xFF007A33);
const gaindeRed = Color(0xFFE31E24);
const gaindeGold = Color(0xFFFFD100);
const gaindeWhite = Color(0xFFFFFFFF);
const gaindeInk = Color(0xFF0F0F0F);
const gaindeBg = Color(0xFFF6F8FB);
const gaindeGray = Color(0xFFF0F3F7);

const gaindeGreenSoft = Color(0xFFE6F4EE);
const gaindeGoldSoft = Color(0xFFFFF4CC);
const gaindeRedSoft = Color(0xFFFFE8E8);
const gaindeLine = Color(0xFFE8ECF3);

const kFocusPopupPrefsKey = 'seen_focus12_v1';
const kFocusPopupNeverKey = 'never_focus12_v1';

class HomePage extends StatefulWidget {
  final bool forceFocusOnEnter;
  const HomePage({super.key, this.forceFocusOnEnter = true});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _maybeShowFocusPopup(context, force: widget.forceFocusOnEnter);
      });
    });
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

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(context, const Shop()),
        backgroundColor: gaindeGray,
        foregroundColor: gaindeInk,
        icon: const Icon(Icons.storefront_rounded),
        label: const Text(
          'Boutique',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
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

          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
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
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).push(_fade(const Settings())),
                    icon: const Icon(Icons.settings, color: gaindeInk),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: _MegaHero(
                    kickoff: kickoff,
                    onMatch: () => _open(context, MatchHub()),
                    onTimeline: () => _open(context, TimelinePage()),
                    onFanZone: () => _open(context, Fanzone()),
                    onTickets: () => _open(context, MatchHub()),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              const SliverToBoxAdapter(child: _KpiStrip()),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 0,
                  ),
                  child: ModulesGridReorderable(
                    prefsKey: 'modules_order_v1',
                    tiles: [
                      ModuleTileData(
                        id: 'match_hub',
                        imageAsset: 'assets/img/matchhub.jpg',
                        label: 'Match',
                        onTap: () => _open(context, MatchHub()),
                        accent: gaindeGreen,
                      ),
                      ModuleTileData(
                        id: 'timeline',
                        imageAsset: 'assets/img/yallapitie.jpeg',
                        label: 'Timeline',
                        onTap: () => _open(context, TimelinePage()),
                        accent: gaindeGold,
                      ),
                      ModuleTileData(
                        id: 'fanzone',
                        imageAsset: 'assets/img/fanzone.jpeg',
                        label: 'Fan Zone',
                        onTap: () => _open(context, Fanzone()),
                        accent: gaindeRed,
                      ),
                      ModuleTileData(
                        id: 'stats',
                        imageAsset: 'assets/img/analyticsjoueur.jpg',
                        label: 'Stats',
                        onTap: () => _open(context, PlayerAnalytics()),
                        accent: gaindeGreen,
                      ),
                      ModuleTileData(
                        id: 'predict_reco',
                        imageAsset: 'assets/img/predictor.webp',
                        label: 'Prédictions & Recos',
                        onTap: () => _open(context, PredictionReco()),
                        accent: gaindeGold,
                      ),
                      ModuleTileData(
                        id: 'footfemale',
                        imageAsset: 'assets/img/female.webp',
                        label: 'Foot féminin',
                        onTap: () => _open(context, FemFootballHub()),
                        accent: gaindeGold,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 84)),
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

class _MegaHero extends StatefulWidget {
  final DateTime kickoff;
  final VoidCallback onMatch, onTimeline, onFanZone;
  final VoidCallback onTickets;

  const _MegaHero({
    required this.kickoff,
    required this.onMatch,
    required this.onTimeline,
    required this.onFanZone,
    required this.onTickets,
  });

  @override
  State<_MegaHero> createState() => _MegaHeroState();
}
class _MegaHeroState extends State<_MegaHero> {
  late Future<Map<String, dynamic>> _futureNextMatch;

 

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      background: gaindeGray,
      borderColor: Colors.black.withOpacity(.06),
      shadowColor: Colors.black.withOpacity(.08),
      blur: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Prochain match',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: gaindeInk,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// ⚡ FutureBuilder mais avec un future MEMORISÉ
          FutureBuilder<Map<String, dynamic>>(
            future: MatchService().getNextMatchSenegal(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('Aucun match disponible'));
              }

              final nextMatchSenegal = snapshot.data!;
         

              return Row(
                children: [
                  _TeamBadge(name: nextMatchSenegal["equipe1"]),
                  const Spacer(),
                  const Text('vs', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  const Spacer(),
                  _TeamBadge(name: nextMatchSenegal["equipe2"]),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          _TicketMiniLine(
            dateTime: widget.kickoff,
            stadium: 'Stade Me Abdoulaye Wade',
            city: 'Diamniadio',
            fromPriceFcfa: 5000,
            onOpenTickets: widget.onTickets,
          ),
        ],
      ),
    );
  }
}


class _TeamBadge extends StatelessWidget {
  final String name;
   const  _TeamBadge({required this.name});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(MatchCard.getImgFlag(name)),
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
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                  height: 1.3,
                ),
              ),
            ),
          ],
        );

        return Column();
      },
    );
  }
}

class _KpiStrip extends StatelessWidget {
  const _KpiStrip();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _KpiPill(
            icon: Icons.local_offer_rounded,
            label: 'Promo en boutique',
            value: '-15%',
          ),
          SizedBox(width: 8),
          _KpiPill(
            icon: Icons.dynamic_feed_rounded,
            label: 'Nouveaux posts',
            value: '87',
          ),
          SizedBox(width: 8),
          _KpiPill(
            icon: Icons.wifi_tethering,
            label: 'Fans en ligne',
            value: '1.2k',
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
                const SizedBox(height: 2),
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

Future<void> _maybeShowFocusPopup(
  BuildContext context, {
  bool force = false,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final never = prefs.getBool(kFocusPopupNeverKey) ?? false;
  final seen = prefs.getBool(kFocusPopupPrefsKey) ?? false;

  if (never) return;

  if (!force && seen) return;

  final action = await showGeneralDialog<_FocusAction>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'focus12',
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, _, __) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return Opacity(
        opacity: curved.value,
        child: Transform.scale(
          scale: 0.94 + 0.06 * curved.value,
          child: Center(
            child: _FocusDialog(
              onRead: () => Navigator.of(ctx).pop(_FocusAction.read),
              onLater: () => Navigator.of(ctx).pop(_FocusAction.later),
              onNever: () => Navigator.of(ctx).pop(_FocusAction.never),
            ),
          ),
        ),
      );
    },
  );

  if (action == _FocusAction.never) {
    await prefs.setBool(kFocusPopupNeverKey, true);
  } else if (action == _FocusAction.read) {
    if (!force) await prefs.setBool(kFocusPopupPrefsKey, true);
  }
}

enum _FocusAction { read, later, never }

class _FocusDialog extends StatelessWidget {
  final VoidCallback onRead;
  final VoidCallback onLater;
  final VoidCallback onNever;
  const _FocusDialog({
    required this.onRead,
    required this.onLater,
    required this.onNever,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxW = (size.width * 0.88).clamp(320.0, 520.0);
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: GlassCard(
          background: Colors.white.withOpacity(.90),
          blur: 18,
          borderColor: Colors.black.withOpacity(.06),
          shadowColor: Colors.black.withOpacity(.12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Illustration
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    'assets/img/12egainde.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: gaindeGreenSoft,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.groups_2_rounded,
                        size: 48,
                        color: gaindeGreen,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: const [
                  Icon(Icons.star_rounded, color: gaindeGold),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Focus sur le 12e Gaïndé',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: gaindeInk,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Plonge dans la ferveur des supporters : chants, tifos, traditions et chiffres clés.',
                  style: TextStyle(color: Colors.black87, height: 1.35),
                ),
              ),
              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _Tag(icon: Icons.graphic_eq_rounded, text: 'Ambiance'),
                  _Tag(icon: Icons.timeline_rounded, text: 'Culture'),
                  _Tag(icon: Icons.insights_rounded, text: 'Chiffres'),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: gaindeGreen.withOpacity(.35)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onLater,
                      child: const Text('Plus tard'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: gaindeGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onRead,
                      icon: const Icon(Icons.auto_stories_rounded),
                      label: const Text(
                        'Lire l’article',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              TextButton.icon(
                onPressed: onNever,
                icon: const Icon(
                  Icons.hide_source_rounded,
                  size: 18,
                  color: Colors.black54,
                ),
                label: const Text(
                  'Ne plus afficher',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Tag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: gaindeGreen.withOpacity(.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: gaindeGreen.withOpacity(.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: gaindeGreen),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: gaindeInk,
            ),
          ),
        ],
      ),
    );
  }
}

class ModuleTileData {
  final String id;
  final String imageAsset;
  final String label;
  final VoidCallback onTap;
  final Color? accent;

  ModuleTileData({
    required this.id,
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
        const target = 138.0;
        int cols = (cons.maxWidth / target).floor().clamp(2, 4);
        if (cons.maxWidth > 950) cols = 5;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 2,
            crossAxisSpacing: 10,
            childAspectRatio: 0.05,
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
              Image.asset(
                data.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: gaindeLine,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined, color: gaindeInk),
                ),
              ),
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

PageRouteBuilder<T> _fade<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
      child: child,
    ),
  );
}
