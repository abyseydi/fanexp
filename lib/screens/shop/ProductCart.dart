import 'package:fanexp/screens/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/services/shop/cart.service.dart';
import 'package:fanexp/theme/gainde_theme.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({super.key});

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  final CartService _cart = CartService.instance;

  void _goToPayment() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Payment()));
  }

  void _removeItem(String id) {
    _cart.removeItem(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;
    final total = _cart.totalAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon Panier')),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Votre panier est vide.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: gaindeInk.withOpacity(.1)),
                        ),
                        child: Row(
                          children: [
                            // Image
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: gaindeGoldSoft,
                              ),
                              child: item.product.imageUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item.product.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.shopping_bag_outlined),
                            ),
                            const SizedBox(width: 12),

                            // Infos
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.nomProduit,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item.quantity} × ${_fcfa(item.product.newPrix ?? item.product.prix)}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            // Total & supprimer
                            Column(
                              children: [
                                Text(
                                  _fcfa(item.totalPrice),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _removeItem(item.product.id),
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: gaindeRed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // TOTAL + Bouton paiement
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total :',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _fcfa(total),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: gaindeGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gaindeGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _goToPayment,
                          child: const Text(
                            'Passer au paiement',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String _fcfa(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final rev = s.length - i;
      buf.write(s[i]);
      if (rev > 1 && rev % 3 == 1) buf.write(" ");
    }
    return "$buf FCFA";
  }
}
