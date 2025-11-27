import 'package:fanexp/entity/product.entity.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductInterface product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.nomProduit),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => _fallbackImg(),
                          )
                        : _fallbackImg(),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.nomProduit,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  product.categorie,
                  style: TextStyle(
                    color: gaindeInk.withOpacity(.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      _fcfa(product.newPrix ?? product.prix),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: gaindeGreen,
                      ),
                    ),
                    if (product.hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        _fcfa(product.prix),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (product.taille.isNotEmpty) ...[
            const Text(
              'Tailles disponibles',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.taille
                  .map(
                    (t) => Chip(
                      label: Text(
                        t,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      backgroundColor: gaindeGreenSoft,
                      shape: StadiumBorder(
                        side: BorderSide(color: gaindeGreen.withOpacity(.4)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],

          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            product.description.isEmpty
                ? 'Aucune description détaillée pour ce produit.'
                : product.description,
            style: const TextStyle(height: 1.4),
          ),
          const SizedBox(height: 24),

          GlowButton(
            label: 'Ajouter au panier',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.nomProduit} ajouté au panier'),
                ),
              );
            },
            glowColor: gaindeGreen,
            bgColor: gaindeGreen,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _fallbackImg() {
    return Container(
      color: gaindeGoldSoft,
      child: const Center(
        child: Icon(Icons.shopping_bag_outlined, size: 64, color: gaindeGold),
      ),
    );
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
}
