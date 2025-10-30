// lib/screens/home/homepage.dart
import 'dart:async';
import 'package:flutter/material.dart';

// Tes widgets réutilisables
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart'; // GlowButton / OutlineSoftButton etc.

// ===============================
// 🎨 Palette Go Gaïndé (Sénégal)
// ===============================
const gaindeGreen = Color(0xFF007A33); // Vert
const gaindeRed = Color(0xFFE31E24); // Rouge
const gaindeGold = Color(0xFFFFD100); // Or
const gaindeWhite = Color(0xFFFFFFFF); // Blanc
const gaindeInk = Color(0xFF0F0F0F); // Noir profond
const gaindeBg = Color(0xFFF6F8FB); // Fond doux

// Déclinaisons douces (fonds badges / chips)
const gaindeGreenSoft = Color(0xFFE6F4EE);
const gaindeGoldSoft = Color(0xFFFFF4CC);
const gaindeRedSoft = Color(0xFFFFE8E8);
const gaindeLine = Color(0xFFE8ECF3);

// ---------- Page d’accueil ----------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;

  // Fake “prochain match”
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
          // Dégradé animé très subtil
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (context, _) {
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

          // Contenu scrollable
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
                    Image.asset('assets/img/federation.png', height: 28),
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
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(child: NextMatchHeroCard(kickoff: kickoff)),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(
                child: LiveCompactCard(isLive: false),
              ), // passe à true si live
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: NewsHighlightsStrip()),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: PlayerSpotlightCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: FanZoneBlock()),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: AiSummaryAndAlerts()),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: ShopMiniCarousel()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Modules ----------

// 1) Next match hero + countdown
class NextMatchHeroCard extends StatefulWidget {
  final DateTime kickoff;
  const NextMatchHeroCard({super.key, required this.kickoff});

  @override
  State<NextMatchHeroCard> createState() => _NextMatchHeroCardState();
}

class _NextMatchHeroCardState extends State<NextMatchHeroCard> {
  late Timer _timer;
  late Duration _remain;

  @override
  void initState() {
    super.initState();
    _remain = widget.kickoff.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _remain = widget.kickoff.difference(DateTime.now()));
    });
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        background: gaindeWhite,
        borderColor: Colors.black.withOpacity(.06),
        shadowColor: Colors.black.withOpacity(.08),
        blur: 14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Prochain match'),
            const SizedBox(height: 10),
            Row(
              children: const [
                _TeamBadge(
                  name: 'Sénégal',
                  flagAsset: 'assets/img/senegal.png',
                ),
                Spacer(),
                Text(
                  'vs',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Spacer(),
                _TeamBadge(name: 'Maroc', flagAsset: 'assets/img/maroc.png'),
              ],
            ),
            const SizedBox(height: 12),
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
                const Spacer(),
                GlowButton(
                  label: 'Activer alertes',
                  onTap: () {},
                  glowColor: gaindeGreen,
                  bgColor: gaindeGreen,
                  textColor: gaindeWhite,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                _QuickChip(icon: Icons.list_alt_rounded, label: 'Compos'),
                _QuickChip(
                  icon: Icons.confirmation_num_outlined,
                  label: 'Billets',
                ),
                _QuickChip(icon: Icons.bar_chart_rounded, label: 'Classement'),
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
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: gaindeInk.withOpacity(.9),
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
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700, color: gaindeInk),
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Chip(
      // avatar: const Icon(icon, size: 16, color: gaindeGreen),
      label: Text(label),
      backgroundColor: gaindeGreenSoft,
      side: const BorderSide(color: gaindeGreen, width: .3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

// 2) Live compact (placeholder)
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
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gaindeRedSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: gaindeRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '67’ – Sénégal 1–0 Maroc',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: gaindeInk,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: Colors.black54),
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

class _LiveEvent extends StatelessWidget {
  final IconData icon;
  final String label;
  const _LiveEvent({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: gaindeInk),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: gaindeInk)),
      ],
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
          widthFactor: value.clamp(0, 1),
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

// 3) News / Highlights
class NewsHighlightsStrip extends StatelessWidget {
  const NewsHighlightsStrip({super.key});
  @override
  Widget build(BuildContext context) {
    final cards = const [
      _NewsCard(
        title: "Inside • Entraînement à Diamniadio",
        tag: "Inside",
        image: 'assets/img/train.avif',
      ),
      _NewsCard(
        title: "Conf’ de presse : 5 points clés",
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
      height: 180,
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
  final String title;
  final String tag;
  final String image;
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
                child: Image.asset(image, fit: BoxFit.cover),
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

// 4) Spotlight joueur
class PlayerSpotlightCard extends StatelessWidget {
  const PlayerSpotlightCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/img/iso.jpeg',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
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
            Chip(
              label: const Text(
                'Titulaire ?',
                style: TextStyle(fontWeight: FontWeight.w700, color: gaindeInk),
              ),
              backgroundColor: gaindeGoldSoft,
              side: const BorderSide(color: gaindeGold, width: .3),
            ),
          ],
        ),
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
        Text(
          'Joueur à suivre',
          style: TextStyle(color: gaindeInk.withOpacity(.6)),
        ),
        const SizedBox(height: 4),
        Text(
          name,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: gaindeInk.withOpacity(.6)),
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
              widthFactor: value.clamp(0, 1),
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

// 5) Fan Zone
class FanZoneBlock extends StatelessWidget {
  const FanZoneBlock({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Fan Zone'),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(
                  child: _FanActionTile(
                    icon: Icons.how_to_vote_rounded,
                    label: 'Vote ton 11',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _FanActionTile(
                    icon: Icons.quiz_rounded,
                    label: 'Quiz du jour',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _FanActionTile(
                    icon: Icons.music_note_rounded,
                    label: 'Chants',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Partage ta voix, fais vibrer la tanière !',
              style: TextStyle(color: gaindeInk.withOpacity(.6)),
            ),
            const SizedBox(height: 2),
            GlowButton(
              label: 'Participer',
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

class _FanActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _FanActionTile({required this.icon, required this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: gaindeGreenSoft,
          border: Border.all(color: gaindeGreen, width: .3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: gaindeGreen),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: gaindeInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6) IA Résumé + Alertes
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
            const _SectionTitle('Résumé IA du dernier match'),
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

// 7) Boutique mini carousel (anti-overflow)
class ShopMiniCarousel extends StatelessWidget {
  const ShopMiniCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      _ShopItem(title: 'Maillot 24/25', image: 'assets/img/maillot.webp'),
      _ShopItem(title: 'Écharpe Gaïndé', image: 'assets/img/echarpe.jpg'),
    ];

    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => SizedBox(width: 150, child: items[i]),
      ),
    );
  }
}

class _ShopItem extends StatelessWidget {
  final String title;
  final String image;
  const _ShopItem({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: Center(child: _ShopImage())),
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
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: GlowButton(
                    label: 'Découvrir',
                    onTap: () {},
                    glowColor: gaindeGreen,
                    bgColor: gaindeGreen,
                    textColor: gaindeWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopImage extends StatelessWidget {
  const _ShopImage();
  @override
  Widget build(BuildContext context) {
    // astuce: placeholder neutre si image absente (évite layout shift)
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: gaindeLine.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: gaindeInk),
    );
  }
}
