import 'package:fanexp/constants/size.dart';
import 'package:fanexp/entity/product.entity.dart';
import 'package:fanexp/screens/payment/payment.dart';
import 'package:fanexp/screens/shop/ProductCart.dart';
import 'package:fanexp/screens/shop/detailProduit.dart';
import 'package:fanexp/services/shop/product.service.dart';
import 'package:fanexp/services/shop/cart.service.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  static const int kFcfaPerPoint = 100;
  int userPoints = 1480;

  late Future<List<ProductInterface>> publishedProducts;
  final ProductService productService = ProductService();
  final CartService _cartService = CartService.instance;

  String query = '';
  String activeFilter = 'Tous';
  final filters = const [
    'Tous',
    'Maillots',
    'Accessoires Supporters',
    'Tenues d\'Entraînement',
    'Enfant',
    'Collectors',
  ];

  int _pointsForPrice(int fcfa) => (fcfa / kFcfaPerPoint).ceil();
  bool _canBuyWithPoints(int priceFcfa) =>
      userPoints >= _pointsForPrice(priceFcfa);

  @override
  void initState() {
    super.initState();
    publishedProducts = productService.getProducts();
  }

  void _reloadProducts() {
    setState(() {
      publishedProducts = productService.getProducts();
    });
  }

  void _handleAddToCart(ProductInterface p) {
    _cartService.addItem(p);
    _snack(context, 'Ajouté au panier');

    // Navigation vers la page de paiement
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Payment()));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductCart()),
              );
            },
            tooltip: 'Panier / Paiement',
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: FutureBuilder<List<ProductInterface>>(
        future: publishedProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _ShopSkeleton();
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: gaindeRed),
                    const SizedBox(height: 12),
                    const Text(
                      'Erreur lors du chargement des produits.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gaindeInk.withOpacity(.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _reloadProducts,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? <ProductInterface>[];

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'Aucun produit disponible pour le moment.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }

          final filtered = products.where((p) {
            final okFilter =
                activeFilter == 'Tous' || p.categorie == activeFilter;
            final okQuery =
                query.trim().isEmpty ||
                p.nomProduit.toLowerCase().contains(query.trim().toLowerCase());
            return okFilter && okQuery;
          }).toList();

          return CustomScrollView(
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
                        final price = p.newPrix ?? p.prix;
                        final pts = _pointsForPrice(price);
                        final canBuy = _canBuyWithPoints(price);

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
                            _snack(
                              context,
                              'Achat en points réussi (-$pts pts)',
                            );
                          },
                          onBuyCash: () => _handleAddToCart(p),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(product: p),
                              ),
                            );
                          },
                        );
                      }, childCount: filtered.length),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------- Card Produit ----------

class _ProductCard extends StatelessWidget {
  final ProductInterface product;
  final int points;
  final bool canBuyWithPoints;
  final VoidCallback onBuyPoints;
  final VoidCallback onBuyCash;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.points,
    required this.canBuyWithPoints,
    required this.onBuyPoints,
    required this.onBuyCash,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final displayPrice = product.newPrix ?? product.prix;

    return GestureDetector(
      onTap: onTap,
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
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => _fallbackImg(),
                          )
                        : _fallbackImg(),
                  ),
                ),
                if (product.hasDiscount)
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
                      child: const Text(
                        'Promo',
                        style: TextStyle(
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
              product.nomProduit,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),

            LayoutBuilder(
              builder: (ctx, cons) {
                final narrow = cons.maxWidth < 170;

                final priceText = Text(
                  _fcfa(displayPrice),
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
                          _fcfa(product.prix),
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
                      Row(children: [ptsChip]),
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
                    ptsChip,
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

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

  Widget _fallbackImg() {
    return Container(
      color: gaindeGoldSoft,
      child: const Center(
        child: Icon(Icons.shopping_bag_outlined, size: 44, color: gaindeGold),
      ),
    );
  }
}

// ---------- Skeleton (chargement) ----------

class _ShopSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              child: Row(
                children: [
                  FadeShimmer(
                    height: 80,
                    width: 80,
                    radius: 12,
                    highlightColor: const Color.fromARGB(255, 208, 240, 227),
                    baseColor: const Color.fromARGB(255, 175, 172, 172),
                    fadeTheme: FadeTheme.light,
                    millisecondsDelay: 1,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeShimmer(
                          height: 16,
                          width: mediaWidth(context) * 0.4,
                          radius: 5,
                          highlightColor: const Color.fromARGB(
                            255,
                            208,
                            240,
                            227,
                          ),
                          baseColor: const Color.fromARGB(255, 175, 172, 172),
                          fadeTheme: FadeTheme.light,
                          millisecondsDelay: 1,
                        ),
                        const SizedBox(height: 8),
                        FadeShimmer(
                          height: 14,
                          width: mediaWidth(context) * 0.3,
                          radius: 5,
                          highlightColor: const Color.fromARGB(
                            255,
                            208,
                            240,
                            227,
                          ),
                          baseColor: const Color.fromARGB(255, 175, 172, 172),
                          fadeTheme: FadeTheme.light,
                          millisecondsDelay: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------- Widgets utilitaires ----------

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

// ---------- Helpers ----------

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
