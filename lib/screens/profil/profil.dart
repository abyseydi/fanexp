import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Header(),
          SizedBox(height: 12),
          _FanStats(),
          SizedBox(height: 12),
          _Preferences(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          const CircleAvatar(radius: 28, backgroundColor: gaindeGreen),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Aby • Légende\nPoints: 1240',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
    );
  }
}

class _FanStats extends StatelessWidget {
  const _FanStats();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: const [
          _Stat(label: 'Présences', value: '12'),
          SizedBox(width: 10),
          _Stat(label: 'Quiz', value: '34'),
          SizedBox(width: 10),
          _Stat(label: 'Défis', value: '9'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: gaindeGoldSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _Preferences extends StatelessWidget {
  const _Preferences();
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Préférences IA',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Alertes buts'),
          ),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Cartons & VAR'),
          ),
          SwitchListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Breaking / mercato'),
          ),
        ],
      ),
    );
  }
}
