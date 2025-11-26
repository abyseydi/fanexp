import 'package:flutter/material.dart';
import 'package:fanexp/services/shop/cart.service.dart';
import 'package:fanexp/theme/gainde_theme.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final CartService _cartService = CartService.instance;

  String _selectedMethod = 'orange-money';
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _confirmPayment() async {
    if (_cartService.isEmpty) {
      _showSnack('Votre panier est vide.');
      return;
    }

    if (_phoneCtrl.text.trim().isEmpty) {
      _showSnack('Veuillez saisir votre numéro de téléphone.');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final total = _cartService.totalAmount;
      final phone = _phoneCtrl.text.trim();

      // 👉 ici tu branches ton vrai service backend
      // Exemple pseudo-code :
      //
      // await PaymentService().payWithMobileMoney(
      //   method: _selectedMethod,
      //   amount: total,
      //   phone: phone,
      // );
      //
      // En attendant, on simule juste un succès :

      await Future.delayed(const Duration(seconds: 2));

      _showSnack(
        'Demande de paiement envoyée via ${_labelForMethod(_selectedMethod)} pour ${_fcfa(total)}',
      );

      // Si succès réel : on vide le panier et on revient
      _cartService.clear();
      Navigator.pop(context);
    } catch (e) {
      _showSnack('Erreur lors du paiement: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  String _labelForMethod(String value) {
    switch (value) {
      case 'orange-money':
        return 'Orange Money';
      case 'wave':
        return 'Wave';
      case 'free-money':
        return 'FreeMoney';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartService.items;
    final total = _cartService.totalAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Votre panier est vide.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Récap du panier
                  const Text(
                    'Récapitulatif',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  ...items.map((item) {
                    final product = item.product;
                    final lineTotal = item.totalPrice;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: gaindeInk.withOpacity(.08)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity} × ${product.nomProduit}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            _fcfa(lineTotal),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Total : ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _fcfa(total),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: gaindeGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Choix du moyen de paiement
                  const Text(
                    'Moyen de paiement',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  _PaymentMethodTile(
                    value: 'orange-money',
                    groupValue: _selectedMethod,
                    label: 'Orange Money',
                    description:
                        'Paiement via compte OM (Orange). Vous recevrez une demande de confirmation.',
                    onChanged: (v) =>
                        setState(() => _selectedMethod = v ?? 'orange-money'),
                    logoColor: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 8),
                  _PaymentMethodTile(
                    value: 'wave',
                    groupValue: _selectedMethod,
                    label: 'Wave',
                    description:
                        'Payer avec votre compte Wave en un clic, frais réduits.',
                    onChanged: (v) =>
                        setState(() => _selectedMethod = v ?? 'wave'),
                    logoColor: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 8),
                  _PaymentMethodTile(
                    value: 'free-money',
                    groupValue: _selectedMethod,
                    label: 'FreeMoney',
                    description: 'Paiement via FreeMoney, rapide et sécurisé.',
                    onChanged: (v) =>
                        setState(() => _selectedMethod = v ?? 'free-money'),
                    logoColor: Colors.red.shade700,
                  ),

                  const SizedBox(height: 24),

                  // Champ numéro
                  const Text(
                    'Numéro de téléphone',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Ex : 77 123 45 67',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.phone_iphone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: gaindeInk.withOpacity(.12),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: gaindeInk.withOpacity(.12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton Valider
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
                      onPressed: _isProcessing ? null : _confirmPayment,
                      child: _isProcessing
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirmer le paiement',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                ],
              ),
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

class _PaymentMethodTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final String description;
  final ValueChanged<String?> onChanged;
  final Color logoColor;

  const _PaymentMethodTile({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.description,
    required this.onChanged,
    required this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? logoColor.withOpacity(.06) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? logoColor.withOpacity(.7) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: logoColor,
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 18,
              backgroundColor: logoColor,
              child: const Icon(Icons.payments, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
