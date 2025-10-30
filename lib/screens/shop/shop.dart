import 'package:fanexp/constants/colors/main_color.dart'
    hide gaindeGreen, gaindeGold;
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});
  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => 'Produit ${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Boutique')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: .82,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: gaindeGoldSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 44,
                    color: gaindeGold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                items[i],
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              GlowButton(
                label: 'Acheter',
                onTap: () {},
                glowColor: gaindeGreen,
                bgColor: gaindeGreen,
                textColor: gaindeWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
