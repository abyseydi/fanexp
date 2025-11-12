// lib/screens/shop/shop.dart
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  static const int kFcfaPerPoint = 100;
  int userPoints = 1480;

  String query = '';
  String activeFilter = 'Tous';
  final filters = const [
    'Tous',
    'Maillots',
    'Accessoires',
    'Enfant',
    'Collectors',
  ];

  int _pointsForPrice(int fcfa) => (fcfa / kFcfaPerPoint).ceil();
  bool _canBuyWithPoints(int priceFcfa) =>
      userPoints >= _pointsForPrice(priceFcfa);

  final items = <_Product>[
    _Product(
      title: 'Maillot 24/25 Domicile',
      image: 'assets/img/maillot.webp',
      price: 59000,
      oldPrice: 69000,
      rating: 4.7,
      badge: 'Nouveau',
      type: 'Maillots',
    ),
    _Product(
      title: 'Écharpe Gaïndé',
      image: 'assets/img/echarpe.jpg',
      price: 12000,
      rating: 4.6,
      type: 'Accessoires',
    ),
    _Product(
      title: 'Short Officiel',
      image: 'assets/img/short.png',
      price: 25000,
      rating: 4.4,
      type: 'Maillots',
    ),
    _Product(
      title: 'Casquette Lions',
      image: 'assets/img/cap.png',
      price: 15000,
      oldPrice: 18000,
      rating: 4.2,
      type: 'Accessoires',
      badge: '-15%',
    ),
    _Product(
      title: 'Mini-kit Enfant',
      image: 'assets/img/minikit.png',
      price: 39000,
      rating: 4.8,
      type: 'Enfant',
    ),
    _Product(
      title: 'Poster Collector Signé',
      image: 'assets/img/poster.png',
      price: 22000,
      rating: 4.9,
      type: 'Collectors',
    ),
    _Product(
      title: 'Sac de sport FFS',
      image: 'assets/img/bag.png',
      price: 28000,
      rating: 4.5,
      type: 'Accessoires',
    ),
    _Product(
      title: 'Maillot Extérieur 24/25',
      image: 'assets/img/maillot_ext.png',
      price: 59000,
      rating: 4.6,
      type: 'Maillots',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final filtered = items.where((p) {
      final okFilter = activeFilter == 'Tous' || p.type == activeFilter;
      final okQuery =
          query.trim().isEmpty ||
          p.title.toLowerCase().contains(query.trim().toLowerCase());
      return okFilter && okQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: gaindeGreenSoft,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: gaindeGreen.withOpacity(.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.loyalty_rounded,
                      size: 16,
                      color: gaindeGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_fmtPoints(userPoints)} pts',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Panier',
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _SearchField(
                      hint: 'Rechercher un produit…',
                      onChanged: (v) => setState(() => query = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Tooltip(
                    message: 'Trier',
                    child: _SoftIconButton(
                      icon: Icons.tune_rounded,
                      onTap: () => _snack(context, 'Tri (à implémenter)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final f = filters[i];
                  final selected = f == activeFilter;
                  return ChoiceChip(
                    label: Text(f),
                    selected: selected,
                    onSelected: (_) => setState(() => activeFilter = f),
                    selectedColor: gaindeGreenSoft,
                    side: BorderSide(
                      color: selected
                          ? gaindeGreen.withOpacity(.4)
                          : gaindeInk.withOpacity(.12),
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: selected ? gaindeGreen : gaindeInk,
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: filters.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.crossAxisExtent;
                const target = 180.0;
                int cols = (w / target).floor().clamp(2, 4);
                if (w > 950) cols = 5;

                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: .55,
                  ),
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final p = filtered[i];
                    final pts = _pointsForPrice(p.price);
                    final canBuy = _canBuyWithPoints(p.price);
                    return _ProductCard(
                      product: p,
                      points: pts,
                      canBuyWithPoints: canBuy,
                      onBuyPoints: () {
                        if (!canBuy) {
                          _snack(
                            context,
                            'Points insuffisants (${_fmtPoints(userPoints)} pts)',
                          );
                          return;
                        }
                        setState(() => userPoints -= pts);
                        _snack(context, 'Achat en points réussi (-$pts pts)');
                      },
                      onBuyCash: () => _snack(context, 'Ajouté au panier'),
                    );
                  }, childCount: filtered.length),
                );
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: _PromoStrip(
      //   text: 'Livraison OFFERTE dès 50.000 FCFA • Retours sous 30 jours',
      //   icon: Icons.local_shipping_outlined,
      //   color: cs.primary,
      // ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final int points;
  final bool canBuyWithPoints;
  final VoidCallback onBuyPoints;
  final VoidCallback onBuyCash;

  const _ProductCard({
    required this.product,
    required this.points,
    required this.canBuyWithPoints,
    required this.onBuyPoints,
    required this.onBuyCash,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _snack(context, 'Ouvrir ${product.title}'),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: gaindeGoldSoft,
                      child: (product.image != null)
                          ? Image.asset(
                              product.image!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 44,
                                  color: gaindeGold,
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 44,
                                color: gaindeGold,
                              ),
                            ),
                    ),
                  ),
                ),
                if (product.badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: gaindeRed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        product.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),

            LayoutBuilder(
              builder: (ctx, cons) {
                final narrow = cons.maxWidth < 170;

                final priceText = Text(
                  _fcfa(product.price),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                );

                final oldPriceText = product.hasDiscount
                    ? Opacity(
                        opacity: .7,
                        child: Text(
                          _fcfa(product.oldPrice!),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();

                final rating = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );

                final ptsChip = Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gaindeGreenSoft,
                    border: Border.all(color: gaindeGreen.withOpacity(.25)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_fmtPoints(points)} pts',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: gaindeGreen,
                    ),
                  ),
                );

                if (narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: priceText),
                          if (product.hasDiscount) const SizedBox(width: 6),
                          if (product.hasDiscount)
                            Flexible(child: oldPriceText),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(children: [rating, const Spacer(), ptsChip]),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: priceText),
                          if (product.hasDiscount) const SizedBox(width: 6),
                          if (product.hasDiscount)
                            Flexible(child: oldPriceText),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    rating,
                    const SizedBox(width: 8),
                    ptsChip,
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            // CTA cash
            SizedBox(
              height: 36,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: GlowButton(
                    label: 'Ajouter au panier',
                    onTap: onBuyCash,
                    glowColor: cs.primary,
                    bgColor: gaindeGreen,
                    textColor: Colors.white,
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

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _SoftIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SoftIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.primary.withOpacity(.20)),
        ),
        child: Icon(icon, color: cs.primary),
      ),
    );
  }
}

class _PromoStrip extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _PromoStrip({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Détails')),
          ],
        ),
      ),
    );
  }
}

class _Product {
  final String title;
  final String? image;
  final int price;
  final int? oldPrice;
  final double rating;
  final String? badge;
  final String type;

  const _Product({
    required this.title,
    required this.price,
    required this.rating,
    required this.type,
    this.image,
    this.oldPrice,
    this.badge,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
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

String _fmtPoints(int pts) {
  final s = pts.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final rev = s.length - i;
    b.write(s[i]);
    if (rev > 1 && rev % 3 == 1) b.write(' ');
  }
  return b.toString();
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
