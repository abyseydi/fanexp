import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/matchCard.dart';
import 'package:fanexp/services/match/match.service.dart';

class _MatchHeader extends StatelessWidget {
  const _MatchHeader();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ligne des équipes + type de match
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Équipe 1
                _TeamBadge(
                  name: 'Sénégal',
                  flagAsset: 'assets/img/senegal.png',
                ),

                // "VS" stylisé
                Column(
                  children: const [
                    Text(
                      "⚡",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Équipe 2
                _TeamBadge(name: 'Brésil', flagAsset: 'assets/img/bresil.png'),
              ],
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                "Match du jour",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            // Bouton "Voir les détails" centré
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: gaindeGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // Navigation vers la page de détails
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MatchDetailsCard()),
                // );
              },
              child: const Text(
                'Détails',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String name;
  final String flagAsset;
  const _TeamBadge({required this.name, required this.flagAsset});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 18, backgroundImage: AssetImage(flagAsset)),
        const SizedBox(height: 12),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _KickoffTile extends StatelessWidget {
  final DateTime kickoff;
  const _KickoffTile({required this.kickoff});

  String _fmt(Duration d) {
    if (d.isNegative) return 'En approche';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final remain = kickoff.difference(DateTime.now());
    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Coup d’envoi dans ${_fmt(remain)} • ${kickoff.hour.toString().padLeft(2, '0')}:${kickoff.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Alerte'),
          ),
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getMatchs() async {
  var resp = MatchService().getMatchs();
  final List<Map<String, dynamic>> matchs = await resp;
  return matchs;
}

class MatchHub extends StatelessWidget {
  MatchHub({super.key});

  var matchs;

  @override
  Widget build(BuildContext context) {
    final kickoff = DateTime.now().add(const Duration(hours: 2, minutes: 30));

    Future.microtask(() => matchs = getMatchs());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Match'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Calendrier'),
              Tab(text: 'Live'),
              Tab(text: 'Stats post-match'),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            const SizedBox(height: 12),

            // Premier card avec "Match du jour" intégré
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // MatchHeader neutre
                  const _MatchHeader(),

                  const SizedBox(height: 6),

                  // Petit texte "Match du jour"
                  const SizedBox(height: 12),

                  // KickoffTile neutre
                  _KickoffTile(kickoff: kickoff),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Autres matchs à venir
            Center(
              child: Text(
                "Prochains",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 12),
            // À la place de ton ListView.builder actuel
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getMatchs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun match disponible'));
                }

                final matchs = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: matchs.length,
                  itemBuilder: (context, index) {
                    final match = matchs[index];
                    return MatchCard(
                      date: match['date'],
                      time: match['heure'],
                      team1: match['equipe1'],
                      team2: match['equipe2'],
                      stadium: match['stade'],
                      phase: match['phase'],
                      city: match['ville'],
                      team1Logo: "assets/img/senegal.png",
                      team2Logo: "assets/img/senegal.png",
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}