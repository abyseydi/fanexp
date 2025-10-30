import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';

class PlayerAnalytics extends StatelessWidget {
  const PlayerAnalytics({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Joueurs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SearchBar(),
          SizedBox(height: 12),
          _PlayerCard(),
          SizedBox(height: 12),
          _RadarAndHeat(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Rechercher un joueur…',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: gaindeGreenSoft,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Ismaïla Sarr • Ailier droit\nForme: élevée • xThreat: 0.28',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _RadarAndHeat extends StatelessWidget {
  const _RadarAndHeat();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: gaindeGreenSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('Radar')),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: gaindeGoldSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('Heatmap')),
            ),
          ),
        ],
      ),
    );
  }
}
