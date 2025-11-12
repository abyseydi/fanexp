// lib/screens/tickets/ticketing_page.dart
import 'package:flutter/material.dart';

// ========= Palette Go Gaïndé =========
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

// ========= Fallback UI (si tu as déjà GlassCard/GlowButton, importe-les et supprime ceci) =========
class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? background, borderColor, shadowColor;
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
          color: (borderColor ?? Colors.black12).withOpacity(.08),
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
  final Color glowColor, bgColor, textColor;
  final EdgeInsets padding;
  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.glowColor,
    required this.bgColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(.45),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

// ========= Modèles =========
class MatchInfo {
  final String home, away, stadium, city, imageAsset;
  final DateTime date;
  MatchInfo({
    required this.home,
    required this.away,
    required this.date,
    required this.stadium,
    required this.city,
    required this.imageAsset,
  });
}

class SeatCategory {
  final String name;
  final int price; // FCFA
  final int available;
  final Color color;
  final List<String> sectors; // IDs de tribunes associées

  SeatCategory({
    required this.name,
    required this.price,
    required this.available,
    required this.color,
    required this.sectors,
  });
}

enum PaymentMethod { momo, card, pickup }

// ========= Page =========
class TicketingPage extends StatefulWidget {
  const TicketingPage({super.key});
  @override
  State<TicketingPage> createState() => _TicketingPageState();
}

class _TicketingPageState extends State<TicketingPage>
    with SingleTickerProviderStateMixin {
  // Données mock (remplace par ton backend plus tard)
  final matches = <MatchInfo>[
    MatchInfo(
      home: 'Sénégal',
      away: 'Maroc',
      date: DateTime.now().add(const Duration(days: 8, hours: 1)),
      stadium: 'Stade Me Abdoulaye Wade',
      city: 'Diamniadio',
      imageAsset: 'assets/img/matchhub.jpg',
    ),
    MatchInfo(
      home: 'Sénégal',
      away: 'Égypte',
      date: DateTime.now().add(const Duration(days: 21, hours: 3)),
      stadium: 'Lat Dior',
      city: 'Thiès',
      imageAsset: 'assets/img/yallapitie.jpeg',
    ),
  ];

  late final List<SeatCategory> categories;

  late MatchInfo selectedMatch;
  late SeatCategory selectedCategory;

  int qty = 1;
  final promoCtrl = TextEditingController();
  bool usingPoints = false;
  int fanPoints = 1240; // mock
  int promoValue = 0;
  PaymentMethod method = PaymentMethod.momo;

  @override
  void initState() {
    super.initState();

    // Mapping cat → tribunes (IDs: VN, VS, LE, LO, C, VIP)
    categories = <SeatCategory>[
      SeatCategory(
        name: 'Virage',
        price: 5000,
        available: 1200,
        color: gaindeGreen,
        sectors: const ['VN', 'VS'],
      ),
      SeatCategory(
        name: 'Latéral',
        price: 10000,
        available: 680,
        color: gaindeGold,
        sectors: const ['LE', 'LO'],
      ),
      SeatCategory(
        name: 'Central',
        price: 15000,
        available: 420,
        color: gaindeInk,
        sectors: const ['C'],
      ),
      SeatCategory(
        name: 'VIP',
        price: 35000,
        available: 95,
        color: gaindeRed,
        sectors: const ['VIP'],
      ),
    ];

    selectedMatch = matches.first;
    selectedCategory = categories.first;
  }

  @override
  void dispose() {
    promoCtrl.dispose();
    super.dispose();
  }

  // ========= Helpers financiers =========
  int get subtotal => selectedCategory.price * qty;
  int get discountFromPromo => promoValue;
  int get discountFromPoints {
    if (!usingPoints) return 0;
    final maxRedeem = fanPoints * 10; // 1 point = 10 FCFA (mock)
    final cap = (subtotal * 0.30).floor(); // limite 30%
    return maxRedeem.clamp(0, cap);
  }

  int get totalDue =>
      (subtotal - discountFromPromo - discountFromPoints).clamp(0, 1 << 31);

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

  void _applyPromo() {
    final code = promoCtrl.text.trim().toUpperCase();
    int val = 0;
    if (code == 'LIONS10') {
      val = (subtotal * 0.10).floor();
    } else if (code == 'VIP5K') {
      val = 5000;
    } else if (code.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Code promo invalide.')));
    }
    setState(() => promoValue = val);
  }

  // Sélection par tribune (clic sur la carte)
  void _selectCategoryBySector(String sectorId) {
    // Trouve la 1ère catégorie qui couvre ce secteur
    final match = categories.firstWhere(
      (c) => c.sectors.contains(sectorId),
      orElse: () => selectedCategory,
    );
    setState(() {
      selectedCategory = match;
      qty = 1;
      promoValue = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tribune sélectionnée → ${match.name}')),
    );
  }

  Future<void> _confirmPayment() async {
    if (qty <= 0 || selectedCategory.available <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sélection non valide.')));
      return;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Billets confirmés 🎉'),
        content: Text(
          '${selectedMatch.home} vs ${selectedMatch.away}\n'
          '${selectedMatch.stadium}, ${selectedMatch.city}\n'
          'Catégorie: ${selectedCategory.name} • Qté: $qty\n'
          'Total payé: ${_fcfa(totalDue)}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ========= UI =========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gaindeBg,
      appBar: AppBar(
        title: const Text('Billetterie'),
        backgroundColor: gaindeBg,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, cons) {
            final wide = cons.maxWidth >= 920;
            final content = wide ? _buildWideLayout() : _buildMobileLayout();
            return content;
          },
        ),
      ),
      bottomNavigationBar: _PayBar(
        total: _fcfa(totalDue),
        onPay: _confirmPayment,
      ),
    );
  }

  // ---- Mobile: une seule colonne défilante
  Widget _buildMobileLayout() {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          sliver: SliverList.list(
            children: [
              _sectionTitle('Match'),
              const SizedBox(height: 8),
              _MatchCard(
                matches: matches,
                selected: selectedMatch,
                onChanged: (m) => setState(() => selectedMatch = m),
                fmtDate: _fmtDate,
              ),
              const SizedBox(height: 16),

              _sectionTitle('Tribunes'),
              const SizedBox(height: 8),
              _StadiumMapCard(
                selectedCategory: selectedCategory,
                onTapSector: _selectCategoryBySector,
              ),
              const SizedBox(height: 16),

              _sectionTitle('Catégories'),
              const SizedBox(height: 8),
              _CategoriesCard(
                categories: categories,
                selected: selectedCategory,
                onSelect: (c) => setState(
                  () => {selectedCategory = c, qty = 1, promoValue = 0},
                ),
                fcfa: _fcfa,
              ),
              const SizedBox(height: 16),

              _sectionTitle('Quantité'),
              const SizedBox(height: 8),
              _QuantityCard(
                qty: qty,
                onMinus: () => setState(() => qty = (qty - 1).clamp(1, 10)),
                onPlus: () => setState(() => qty = (qty + 1).clamp(1, 10)),
                subtotalText: _fcfa(subtotal),
              ),
              const SizedBox(height: 16),

              _sectionTitle('Code promo'),
              const SizedBox(height: 8),
              _PromoCard(
                controller: promoCtrl,
                onApply: _applyPromo,
                discountFCFA: discountFromPromo > 0
                    ? _fcfa(discountFromPromo)
                    : null,
              ),
              const SizedBox(height: 16),

              _sectionTitle('Points fans'),
              const SizedBox(height: 8),
              _PointsCard(
                usingPoints: usingPoints,
                onToggle: (v) => setState(() => usingPoints = v),
                fanPointsText: '$fanPoints pts ≈ ${_fcfa(fanPoints * 10)}',
                discountFCFA: discountFromPoints > 0
                    ? _fcfa(discountFromPoints)
                    : null,
              ),
              const SizedBox(height: 16),

              _sectionTitle('Moyen de paiement'),
              const SizedBox(height: 8),
              _PaymentCard(
                method: method,
                onChanged: (m) => setState(() => method = m),
              ),
              const SizedBox(height: 16),

              _sectionTitle('Récapitulatif'),
              const SizedBox(height: 8),
              _ResumeCard(
                lines: [
                  _KV(
                    'Match',
                    '${selectedMatch.home} vs ${selectedMatch.away}',
                  ),
                  _KV('Date', _fmtDate(selectedMatch.date)),
                  _KV(
                    'Lieu',
                    '${selectedMatch.stadium}, ${selectedMatch.city}',
                  ),
                ],
                details: [
                  _KV('Catégorie', selectedCategory.name),
                  _KV('Prix unitaire', _fcfa(selectedCategory.price)),
                  _KV('Quantité', '$qty'),
                ],
                finance: [
                  _KV('Sous-total', _fcfa(subtotal), bold: true),
                  if (discountFromPromo > 0)
                    _KV(
                      'Promo',
                      '- ${_fcfa(discountFromPromo)}',
                      accent: Colors.orange,
                    ),
                  if (discountFromPoints > 0)
                    _KV(
                      'Points',
                      '- ${_fcfa(discountFromPoints)}',
                      accent: gaindeGreen,
                    ),
                ],
                total: _fcfa(totalDue),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  // ---- Large: deux colonnes, scroll unique
  Widget _buildWideLayout() {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colonne gauche
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Match'),
                      const SizedBox(height: 8),
                      _MatchCard(
                        matches: matches,
                        selected: selectedMatch,
                        onChanged: (m) => setState(() => selectedMatch = m),
                        fmtDate: _fmtDate,
                      ),
                      const SizedBox(height: 16),

                      _sectionTitle('Tribunes'),
                      const SizedBox(height: 8),
                      _StadiumMapCard(
                        selectedCategory: selectedCategory,
                        onTapSector: _selectCategoryBySector,
                      ),
                      const SizedBox(height: 16),

                      _sectionTitle('Catégories'),
                      const SizedBox(height: 8),
                      _CategoriesCard(
                        categories: categories,
                        selected: selectedCategory,
                        onSelect: (c) => setState(
                          () => {selectedCategory = c, qty = 1, promoValue = 0},
                        ),
                        fcfa: _fcfa,
                      ),
                      const SizedBox(height: 16),

                      _sectionTitle('Quantité'),
                      const SizedBox(height: 8),
                      _QuantityCard(
                        qty: qty,
                        onMinus: () =>
                            setState(() => qty = (qty - 1).clamp(1, 10)),
                        onPlus: () =>
                            setState(() => qty = (qty + 1).clamp(1, 10)),
                        subtotalText: _fcfa(subtotal),
                      ),
                      const SizedBox(height: 16),

                      _sectionTitle('Code promo'),
                      const SizedBox(height: 8),
                      _PromoCard(
                        controller: promoCtrl,
                        onApply: _applyPromo,
                        discountFCFA: discountFromPromo > 0
                            ? _fcfa(discountFromPromo)
                            : null,
                      ),
                      const SizedBox(height: 16),

                      _sectionTitle('Points fans'),
                      const SizedBox(height: 8),
                      _PointsCard(
                        usingPoints: usingPoints,
                        onToggle: (v) => setState(() => usingPoints = v),
                        fanPointsText:
                            '$fanPoints pts ≈ ${_fcfa(fanPoints * 10)}',
                        discountFCFA: discountFromPoints > 0
                            ? _fcfa(discountFromPoints)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Colonne droite
                SizedBox(
                  width: 380,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Moyen de paiement'),
                      const SizedBox(height: 8),
                      _PaymentCard(
                        method: method,
                        onChanged: (m) => setState(() => method = m),
                      ),
                      const SizedBox(height: 16),

                      _sectionTitle('Récapitulatif'),
                      const SizedBox(height: 8),
                      _ResumeCard(
                        lines: [
                          _KV(
                            'Match',
                            '${selectedMatch.home} vs ${selectedMatch.away}',
                          ),
                          _KV('Date', _fmtDate(selectedMatch.date)),
                          _KV(
                            'Lieu',
                            '${selectedMatch.stadium}, ${selectedMatch.city}',
                          ),
                        ],
                        details: [
                          _KV('Catégorie', selectedCategory.name),
                          _KV('Prix unitaire', _fcfa(selectedCategory.price)),
                          _KV('Quantité', '$qty'),
                        ],
                        finance: [
                          _KV('Sous-total', _fcfa(subtotal), bold: true),
                          if (discountFromPromo > 0)
                            _KV(
                              'Promo',
                              '- ${_fcfa(discountFromPromo)}',
                              accent: Colors.orange,
                            ),
                          if (discountFromPoints > 0)
                            _KV(
                              'Points',
                              '- ${_fcfa(discountFromPoints)}',
                              accent: gaindeGreen,
                            ),
                        ],
                        total: _fcfa(totalDue),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---- Sous-composants communs ----
  Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(
      fontWeight: FontWeight.w800,
      color: gaindeInk,
      fontSize: 16,
    ),
  );
}

// ========= Cartes / Widgets =========

class _MatchCard extends StatelessWidget {
  final List<MatchInfo> matches;
  final MatchInfo selected;
  final void Function(MatchInfo) onChanged;
  final String Function(DateTime) fmtDate;

  const _MatchCard({
    required this.matches,
    required this.selected,
    required this.onChanged,
    required this.fmtDate,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<MatchInfo>(
            isExpanded: true,
            value: selected,
            decoration: _inputDeco('Choisir le match'),
            items: matches
                .map(
                  (m) => DropdownMenuItem(
                    value: m,
                    child: Text('${m.home} vs ${m.away} • ${fmtDate(m.date)}'),
                  ),
                )
                .toList(),
            onChanged: (m) => onChanged(m!),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 16 / 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                selected.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: gaindeLine,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined, color: gaindeInk),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _IconText(
                Icons.location_on_outlined,
                '${selected.stadium}, ${selected.city}',
              ),
              _IconText(Icons.schedule_rounded, fmtDate(selected.date)),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: gaindeGreen.withOpacity(.6), width: 1.2),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconText(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: gaindeInk),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ====== NOUVEAU : Carte des tribunes dynamique ======

class _StadiumMapCard extends StatelessWidget {
  final SeatCategory selectedCategory;
  final ValueChanged<String> onTapSector;
  const _StadiumMapCard({
    required this.selectedCategory,
    required this.onTapSector,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan du stade',
            style: TextStyle(fontWeight: FontWeight.w800, color: gaindeInk),
          ),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 10,
            child: _StadiumMap(
              highlightedSectors: selectedCategory.sectors.toSet(),
              accent: selectedCategory.color,
              onTapSector: onTapSector,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: const [
              _LegendDot(color: gaindeGreen, label: 'Virage (VN/VS)'),
              _LegendDot(color: gaindeGold, label: 'Latéral (LE/LO)'),
              _LegendDot(color: gaindeInk, label: 'Central (C)'),
              _LegendDot(color: gaindeRed, label: 'VIP'),
            ],
          ),
        ],
      ),
    );
  }
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
        Text(label),
      ],
    );
  }
}

/// Représentation stylisée en *Stack* (sans CustomPaint pour rester simple et responsive).
/// Sectors:
/// - 'VN': Virage Nord   (haut)
/// - 'VS': Virage Sud    (bas)
//  - 'LE': Latéral Est   (droite)
//  - 'LO': Latéral Ouest (gauche)
//  - 'C' : Central       (centre)
//  - 'VIP': zone VIP     (bande centrale inférieure)
class _StadiumMap extends StatefulWidget {
  final Set<String> highlightedSectors;
  final Color accent;
  final ValueChanged<String> onTapSector;
  const _StadiumMap({
    required this.highlightedSectors,
    required this.accent,
    required this.onTapSector,
  });

  @override
  State<_StadiumMap> createState() => _StadiumMapState();
}

class _StadiumMapState extends State<_StadiumMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  bool _isHighlighted(String id) => widget.highlightedSectors.contains(id);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, cons) {
        final w = cons.maxWidth;
        final h = cons.maxHeight;

        // Zones avec positions relatives (pour s’adapter à tous les écrans)
        Widget sectorBox({
          required String id,
          required Alignment alignment,
          required Size relSize,
          required Color baseColor,
          double border = 2,
          double radius = 16,
        }) {
          final highlighted = _isHighlighted(id);
          return Align(
            alignment: alignment,
            child: AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) {
                final pulse = highlighted
                    ? (1 + 0.06 * (1 - (2 * (_pulseCtrl.value - .5)).abs()))
                    : 1.0;
                return GestureDetector(
                  onTap: () => widget.onTapSector(id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: w * relSize.width * pulse,
                    height: h * relSize.height * pulse,
                    decoration: BoxDecoration(
                      color: highlighted
                          ? baseColor.withOpacity(.25)
                          : baseColor.withOpacity(.10),
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: highlighted
                            ? widget.accent
                            : baseColor.withOpacity(.35),
                        width: highlighted ? border + 1.2 : border,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      id,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: highlighted
                            ? gaindeInk
                            : gaindeInk.withOpacity(.75),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Stack(
          children: [
            // Pelouse centrale
            Align(
              alignment: Alignment.center,
              child: Container(
                width: w * .55,
                height: h * .48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(.18),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: gaindeGreen.withOpacity(.35)),
                ),
              ),
            ),
            // Central (C)
            sectorBox(
              id: 'C',
              alignment: Alignment.center,
              relSize: const Size(.28, .22),
              baseColor: gaindeInk,
              border: 2,
              radius: 18,
            ),
            // VIP (bande au bas du central)
            sectorBox(
              id: 'VIP',
              alignment: const Alignment(0, .60),
              relSize: const Size(.50, .10),
              baseColor: gaindeRed,
              border: 2,
              radius: 14,
            ),
            // Virage Nord (haut)
            sectorBox(
              id: 'VN',
              alignment: const Alignment(0, -0.92),
              relSize: const Size(.70, .16),
              baseColor: gaindeGreen,
            ),
            // Virage Sud (bas)
            sectorBox(
              id: 'VS',
              alignment: const Alignment(0, 0.92),
              relSize: const Size(.70, .16),
              baseColor: gaindeGreen,
            ),
            // Latéral Ouest (gauche)
            sectorBox(
              id: 'LO',
              alignment: const Alignment(-0.95, 0),
              relSize: const Size(.16, .55),
              baseColor: gaindeGold,
            ),
            // Latéral Est (droite)
            sectorBox(
              id: 'LE',
              alignment: const Alignment(0.95, 0),
              relSize: const Size(.16, .55),
              baseColor: gaindeGold,
            ),
            // Contours doux
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gaindeLine),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ====== Fin nouvelle carte tribunes ======

class _CategoriesCard extends StatelessWidget {
  final List<SeatCategory> categories;
  final SeatCategory selected;
  final void Function(SeatCategory) onSelect;
  final String Function(int) fcfa;

  const _CategoriesCard({
    required this.categories,
    required this.selected,
    required this.onSelect,
    required this.fcfa,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: LayoutBuilder(
        builder: (_, cons) {
          final isNarrow = cons.maxWidth < 480;
          final children = categories.map((c) {
            final isSel = identical(c, selected);
            return ChoiceChip(
              selected: isSel,
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(fcfa(c.price), style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 2),
                  Opacity(
                    opacity: .7,
                    child: Text(
                      'Dispo: ${c.available}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              selectedColor: c.color.withOpacity(.12),
              side: BorderSide(
                color: (isSel ? c.color : gaindeLine).withOpacity(.8),
              ),
              onSelected: (_) => onSelect(c),
            );
          }).toList();

          return isNarrow
              ? Wrap(spacing: 10, runSpacing: 10, children: children)
              : Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: children,
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _QuantityCard extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus, onPlus;
  final String subtotalText;
  const _QuantityCard({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    required this.subtotalText,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          _QtyBtn(icon: Icons.remove_rounded, onTap: onMinus),
          const SizedBox(width: 8),
          Text(
            '$qty',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(width: 8),
          _QtyBtn(icon: Icons.add_rounded, onTap: onPlus),
          const Spacer(),
          Text(
            'Sous-total: $subtotalText',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: gaindeGreenSoft,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: gaindeGreen.withOpacity(.4)),
          ),
          child: Icon(icon, color: gaindeGreen),
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;
  final String? discountFCFA;
  const _PromoCard({
    required this.controller,
    required this.onApply,
    this.discountFCFA,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: _inputDeco('Ex: LIONS10 / VIP5K'),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: gaindeGreen,
                  foregroundColor: gaindeWhite,
                ),
                onPressed: onApply,
                child: const Text('Appliquer'),
              ),
            ],
          ),
          if (discountFCFA != null) ...[
            const SizedBox(height: 10),
            _InfoPill(
              icon: Icons.local_offer_rounded,
              text: 'Réduction promo: $discountFCFA',
              bg: gaindeGoldSoft,
              fg: gaindeInk,
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: gaindeGreen.withOpacity(.6), width: 1.2),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

class _PointsCard extends StatelessWidget {
  final bool usingPoints;
  final ValueChanged<bool> onToggle;
  final String fanPointsText;
  final String? discountFCFA;
  const _PointsCard({
    required this.usingPoints,
    required this.onToggle,
    required this.fanPointsText,
    this.discountFCFA,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Switch(
                value: usingPoints,
                onChanged: onToggle,
                activeColor: gaindeGreen,
              ),
              const SizedBox(width: 6),
              Expanded(child: Text('Utiliser mes points ($fanPointsText)')),
            ],
          ),
          if (discountFCFA != null) ...[
            const SizedBox(height: 8),
            _InfoPill(
              icon: Icons.stars_rounded,
              text: 'Réduction points: $discountFCFA',
              bg: gaindeGreenSoft,
              fg: gaindeInk,
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PaymentMethod method;
  final ValueChanged<PaymentMethod> onChanged;
  const _PaymentCard({required this.method, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _PayRadioTile(
            value: PaymentMethod.momo,
            group: method,
            onChanged: onChanged,
            icon: Icons.phone_iphone_rounded,
            label: 'Mobile Money',
            hint: 'Orange Money, Wave…',
          ),
          const Divider(height: 16),
          _PayRadioTile(
            value: PaymentMethod.card,
            group: method,
            onChanged: onChanged,
            icon: Icons.credit_card_rounded,
            label: 'Carte bancaire',
            hint: 'Visa, Mastercard',
          ),
          const Divider(height: 16),
          _PayRadioTile(
            value: PaymentMethod.pickup,
            group: method,
            onChanged: onChanged,
            icon: Icons.store_mall_directory_rounded,
            label: 'Retrait guichet',
            hint: 'Paiement sur place',
          ),
        ],
      ),
    );
  }
}

class _PayRadioTile extends StatelessWidget {
  final PaymentMethod value, group;
  final ValueChanged<PaymentMethod> onChanged;
  final IconData icon;
  final String label, hint;
  const _PayRadioTile({
    required this.value,
    required this.group,
    required this.onChanged,
    required this.icon,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<PaymentMethod>(
      value: value,
      groupValue: group,
      onChanged: (v) => onChanged(v!),
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: gaindeGreen.withOpacity(.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: gaindeGreen.withOpacity(.2)),
            ),
            child: Icon(icon, color: gaindeGreen),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
      subtitle: Text(hint),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  final List<_KV> lines;
  final List<_KV> details;
  final List<_KV> finance;
  final String total;
  const _ResumeCard({
    required this.lines,
    required this.details,
    required this.finance,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          ...lines.map((e) => _RowKV(e)),
          const Divider(),
          ...details.map((e) => _RowKV(e)),
          const Divider(),
          ...finance.map((e) => _RowKV(e)),
          const SizedBox(height: 6),
          _RowKV(_KV('À payer', total, bold: true, bigger: true)),
        ],
      ),
    );
  }
}

class _KV {
  final String k, v;
  final bool bold, bigger;
  final Color? accent;
  _KV(this.k, this.v, {this.bold = false, this.bigger = false, this.accent});
}

class _RowKV extends StatelessWidget {
  final _KV kv;
  const _RowKV(this.kv);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: kv.bold ? FontWeight.w800 : FontWeight.w600,
      fontSize: kv.bigger ? 16 : 14,
      color: kv.accent ?? gaindeInk,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Opacity(opacity: .7, child: Text(kv.k))),
          Text(kv.v, style: style),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color bg, fg;
  const _InfoPill({
    required this.icon,
    required this.text,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: fg, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayBar extends StatelessWidget {
  final String total;
  final VoidCallback onPay;
  const _PayBar({required this.total, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: gaindeWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Opacity(
                    opacity: .7,
                    child: Text(
                      'Total à payer',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    total,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 180,
              child: GlowButton(
                label: 'Payer maintenant',
                onTap: onPay,
                glowColor: gaindeGreen,
                bgColor: gaindeGreen,
                textColor: gaindeWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
