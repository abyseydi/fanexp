import 'package:fanexp/constants/colors/main_color.dart'
    hide gaindeGreen, gaindeGold, gaindeRed;
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';

class PredictionReco extends StatelessWidget {
  const PredictionReco({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prédictions & Recos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _WinProba(),
          SizedBox(height: 12),
          _XIReco(),
          SizedBox(height: 12),
          _CoachingTips(),
        ],
      ),
    );
  }
}

class _WinProba extends StatelessWidget {
  const _WinProba();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Probabilités de résultat',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              _ProbPill(color: gaindeGreen, label: 'Victoire', value: '54%'),
              SizedBox(width: 8),
              _ProbPill(color: gaindeGold, label: 'Nul', value: '28%'),
              SizedBox(width: 8),
              _ProbPill(color: gaindeRed, label: 'Défaite', value: '18%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProbPill extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _ProbPill({
    required this.color,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: color,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.black.withOpacity(.7))),
          ],
        ),
      ),
    );
  }
}

class _XIReco extends StatelessWidget {
  const _XIReco();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'XI recommandé (IA)',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: gaindeGreenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          GlowButton(
            label: 'Voir détails',
            onTap: () {},
            glowColor: gaindeGreen,
            bgColor: gaindeGreen,
            textColor: gaindeWhite,
          ),
        ],
      ),
    );
  }
}

class _CoachingTips extends StatelessWidget {
  const _CoachingTips();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Recommandations IA',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          _Bullet(text: 'Pressing haut 15–30’ (faiblesse relance G.).'),
          _Bullet(text: 'Surveiller couloir droit (surnombre adverse).'),
          _Bullet(text: 'Changements min 60–70 pour impact maximal.'),
        ],
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
        const Icon(Icons.auto_awesome_rounded, size: 16, color: gaindeGreen),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}
