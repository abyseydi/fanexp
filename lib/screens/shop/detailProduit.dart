// import 'package:flutter/material.dart';
// import 'package:fanexp/theme/gainde_theme.dart';
// import 'package:fanexp/widgets/glasscard.dart';
// import 'package:fanexp/widgets/buttons.dart';
// import 'package:fanexp/entity/product.entity.dart';

// class ProductDetailPage extends StatelessWidget {
//   final ProductInterface product;
//   final int points;
//   final bool canBuyWithPoints;

//   const ProductDetailPage({
//     super.key,
//     required this.product,
//     required this.points,
//     required this.canBuyWithPoints,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           product.nomProduit,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GlassCard(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Hero(
//                       tag: 'product-${product.id}',
//                       child: AspectRatio(
//                         aspectRatio: 1,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Container(
//                             color: gaindeGoldSoft,
//                             child: (product.imageUrl.isNotEmpty)
//                                 ? Image.network(
//                                     product.imageUrl,
//                                     fit: BoxFit.contain,
//                                     errorBuilder: (_, __, ___) => const Center(
//                                       child: Icon(
//                                         Icons.shopping_bag_outlined,
//                                         size: 48,
//                                         color: gaindeGold,
//                                       ),
//                                     ),
//                                   )
//                                 : const Center(
//                                     child: Icon(
//                                       Icons.shopping_bag_outlined,
//                                       size: 48,
//                                       color: gaindeGold,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         if (product.categorie.isNotEmpty)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: gaindeGreenSoft,
//                               borderRadius: BorderRadius.circular(999),
//                               border: Border.all(
//                                 color: gaindeGreen.withOpacity(.3),
//                               ),
//                             ),
//                             child: Text(
//                               product.categorie,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w800,
//                                 color: gaindeGreen,
//                               ),
//                             ),
//                           ),
//                         const Spacer(),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: gaindeGreenSoft,
//                             borderRadius: BorderRadius.circular(999),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(
//                                 Icons.loyalty_rounded,
//                                 size: 16,
//                                 color: gaindeGreen,
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 '$points pts',
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w800,
//                                   color: gaindeGreen,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               Text(
//                 product.nomProduit,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w900,
//                   color: gaindeInk,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Text(
//                     _fcfa(product.prix),
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w900,
//                       color: gaindeInk,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   if (product.newPrix != null &&
//                       product.newPrix! > 0 &&
//                       product.newPrix! < product.prix)
//                     Opacity(
//                       opacity: .7,
//                       child: Text(
//                         _fcfa(product.newPrix!),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           decoration: TextDecoration.lineThrough,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               if (product.taille.isNotEmpty) ...[
//                 const Text(
//                   'Tailles disponibles',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 14,
//                     color: gaindeInk,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: product.taille.map((t) {
//                     return Chip(
//                       label: Text(
//                         t,
//                         style: const TextStyle(fontWeight: FontWeight.w700),
//                       ),
//                       backgroundColor: Colors.white,
//                       shape: StadiumBorder(
//                         side: BorderSide(color: gaindeInk.withOpacity(.15)),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 16),
//               ],

//               GlassCard(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                         fontSize: 14,
//                         color: gaindeInk,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       (product.description.isEmpty)
//                           ? "Ce produit n'a pas encore de description détaillée. Reste connecté, les infos arrivent !"
//                           : product.description,
//                       style: const TextStyle(fontSize: 13, height: 1.4),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               GlassCard(
//                 child: Row(
//                   children: [
//                     Icon(Icons.info_outline, color: cs.primary),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         canBuyWithPoints
//                             ? 'Tu peux acheter ce produit entièrement en points.'
//                             : 'Tu n’as pas encore assez de points pour payer entièrement en points.',
//                         style: const TextStyle(fontSize: 13),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               Row(
//                 children: [
//                   Expanded(
//                     child: GlowButton(
//                       label: 'Ajouter au panier',
//                       onTap: () {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               '${product.nomProduit} ajouté au panier',
//                             ),
//                           ),
//                         );
//                       },
//                       glowColor: gaindeGreen,
//                       bgColor: gaindeGreen,
//                       textColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: canBuyWithPoints
//                           ? () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     'Achat en points (${points} pts) – à connecter au backend',
//                                   ),
//                                 ),
//                               );
//                             }
//                           : null,
//                       icon: const Icon(Icons.loyalty_rounded),
//                       label: Text(
//                         canBuyWithPoints
//                             ? 'Payer en points'
//                             : 'Points insuffisants',
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(
//                           color: canBuyWithPoints
//                               ? gaindeGreen
//                               : gaindeInk.withOpacity(.2),
//                         ),
//                         foregroundColor: canBuyWithPoints
//                             ? gaindeGreen
//                             : gaindeInk,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// String _fcfa(int v) {
//   final s = v.toString();
//   final buf = StringBuffer();
//   for (int i = 0; i < s.length; i++) {
//     final revIdx = s.length - i;
//     buf.write(s[i]);
//     if (revIdx > 1 && revIdx % 3 == 1) buf.write(' ');
//   }
//   return '${buf.toString()} FCFA';
// }

// lib/screens/shop/product_detail_page.dart

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
