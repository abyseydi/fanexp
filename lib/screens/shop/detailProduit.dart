import 'package:flutter/material.dart';
import 'package:fanexp/constants/colors/main_color.dart'
    hide gaindeRed, gaindeGreen;
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';

import '../../theme/gainde_theme.dart';

/// Exemple de modèle produit.
/// Adapte-le à ton vrai modèle (ou supprime cette classe si tu en as déjà un).
class Product {
  final String id;
  final String name;
  final String image; // asset ou network
  final int price; // FCFA
  final String description;
  final List<String> tags;
  final bool isNew;
  final bool isLimited;
  final double rating; // 0–5
  final int reviewsCount;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    this.tags = const [],
    this.isNew = false,
    this.isLimited = false,
    this.rating = 4.5,
    this.reviewsCount = 0,
  });
}

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _qty = 1;
  bool _isFavorite = false;
  bool _expandedDesc = false;

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
    final p = widget.product;

    return Scaffold(
      backgroundColor: gaindeBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ---------- Header / Image ----------
            SliverAppBar(
              pinned: true,
              expandedHeight: 280,
              backgroundColor: gaindeBg,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: gaindeInk),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      _isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(_isFavorite),
                      color: _isFavorite ? gaindeRed : gaindeInk,
                    ),
                  ),
                  onPressed: () {
                    setState(() => _isFavorite = !_isFavorite);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isFavorite
                              ? 'Ajouté aux favoris'
                              : 'Retiré des favoris',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'product-${p.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                        child: _ProductImage(image: p.image),
                      ),
                    ),
                    // Badge(s) en overlay
                    Positioned(
                      left: 16,
                      bottom: 24,
                      child: Row(
                        children: [
                          if (p.isNew)
                            _Badge(
                              text: 'Nouveau',
                              bg: gaindeGreenSoft,
                              fg: gaindeGreen,
                              icon: Icons.fiber_new_rounded,
                            ),
                          if (p.isLimited) const SizedBox(width: 8),
                          if (p.isLimited)
                            const _Badge(
                              text: 'Édition limitée',
                              bg: gaindeRedSoft,
                              fg: gaindeRed,
                              icon: Icons.local_fire_department_rounded,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------- Contenu ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre + prix
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            p.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: gaindeInk,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _fcfa(p.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: gaindeGreen,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (p.rating > 0)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    p.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Opacity(
                                    opacity: .7,
                                    child: Text(
                                      '(${p.reviewsCount})',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tags (taille / collection / etc.)
                    if (p.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: p.tags
                            .map(
                              (t) => Chip(
                                label: Text(
                                  t,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: gaindeGreenSoft,
                                side: BorderSide(
                                  color: gaindeGreen.withOpacity(.25),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Bloc description
                    GlassCard(
                      background: Colors.white,
                      borderColor: Colors.black.withOpacity(.04),
                      shadowColor: Colors.black.withOpacity(.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: gaindeInk,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 220),
                            firstChild: Text(
                              p.description.length > 220
                                  ? '${p.description.substring(0, 220)}…'
                                  : p.description,
                              style: const TextStyle(height: 1.35),
                            ),
                            secondChild: Text(
                              p.description,
                              style: const TextStyle(height: 1.35),
                            ),
                            crossFadeState: _expandedDesc
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                          ),
                          if (p.description.length > 220) ...[
                            const SizedBox(height: 6),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => setState(
                                () => _expandedDesc = !_expandedDesc,
                              ),
                              icon: Icon(
                                _expandedDesc
                                    ? Icons.expand_less_rounded
                                    : Icons.expand_more_rounded,
                                size: 18,
                              ),
                              label: Text(
                                _expandedDesc ? 'Voir moins' : 'Voir plus',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Infos pratique (livraison, stock, etc.)
                    GlassCard(
                      background: Colors.white,
                      borderColor: Colors.black.withOpacity(.04),
                      shadowColor: Colors.black.withOpacity(.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _InfoRow(
                            icon: Icons.local_shipping_rounded,
                            title: 'Livraison',
                            subtitle: 'Sous 3 à 7 jours ouvrés selon la zone.',
                          ),
                          SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.redeem_rounded,
                            title: 'Retour',
                            subtitle:
                                'Retour possible sous 7 jours si article non porté.',
                          ),
                          SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.verified_rounded,
                            title: 'Produit officiel',
                            subtitle: 'Article officiel de la sélection.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sélecteur quantité
                    GlassCard(
                      background: Colors.white,
                      borderColor: Colors.black.withOpacity(.04),
                      shadowColor: Colors.black.withOpacity(.06),
                      child: Row(
                        children: [
                          const Text(
                            'Quantité',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: gaindeInk,
                            ),
                          ),
                          const Spacer(),
                          _QtyButton(
                            icon: Icons.remove_rounded,
                            onTap: () {
                              setState(() => _qty = (_qty - 1).clamp(1, 10));
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_qty',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _QtyButton(
                            icon: Icons.add_rounded,
                            onTap: () {
                              setState(() => _qty = (_qty + 1).clamp(1, 10));
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // (Optionnel) Section "Tu pourrais aussi aimer"
                    const Text(
                      'Tu pourrais aussi aimer',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: gaindeInk,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) => AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              color: gaindeGreenSoft,
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                'Autre produit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: gaindeInk,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------- Barre d’action en bas ----------
      bottomNavigationBar: SafeArea(
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Opacity(
                      opacity: .7,
                      child: Text('Total', style: TextStyle(fontSize: 12)),
                    ),
                    Text(
                      _fcfa(widget.product.price * _qty),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: gaindeGreen,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 190,
                child: GlowButton(
                  label: 'Ajouter au panier',
                  glowColor: gaindeGreen,
                  bgColor: gaindeGreen,
                  textColor: gaindeWhite,
                  onTap: _onAddToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddToCart() {
    // TODO: branche ton provider / bloc / backend panier ici
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_qty × ${widget.product.name} ajouté(s) au panier 🛒'),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String image;
  const _ProductImage({required this.image});

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        image.startsWith('http://') || image.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return Image.asset(
      image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      color: gaindeGreenSoft,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: gaindeGreen, size: 48),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  final IconData icon;
  const _Badge({
    required this.text,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: gaindeGreenSoft,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: gaindeGreen.withOpacity(.2)),
          ),
          child: Icon(icon, size: 18, color: gaindeGreen),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: gaindeInk,
                ),
              ),
              const SizedBox(height: 2),
              Opacity(
                opacity: .8,
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: gaindeGreenSoft,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: gaindeGreen.withOpacity(.4)),
          ),
          child: Icon(icon, color: gaindeGreen, size: 20),
        ),
      ),
    );
  }
}
