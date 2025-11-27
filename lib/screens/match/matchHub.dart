import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/matchCard.dart';
import 'package:fanexp/services/match/match.service.dart';
import 'package:fanexp/widgets/countDown.dart';

class _MatchHeader extends StatelessWidget {
  const _MatchHeader();

  @override
Widget build(BuildContext context) {
  return FutureBuilder<Map<String, dynamic>>(
    future: getNextMatch(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Erreur : ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("Aucun match trouvé"));
      }

      final nextMatch = snapshot.data!;
      final kickoff = DateTime.now().add(const Duration(hours: 2, minutes: 30));

      return GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- LIGNE DES EQUIPES ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Équipe 1
                  _TeamBadge(
                    name: nextMatch["equipe1"] ?? "???",
                  ),

                  // VS stylisé
                  const Column(
                    children: [
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
                  _TeamBadge(
                    name: nextMatch["equipe2"] ?? "???",
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- TEXTE "Match du jour" ---
              Center(
                child: Text(
                  "Match à venir",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // --- BOUTON "Détails" ---
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
                  // Navigation future ici
                },
                child: const Text(
                  'Détails',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              _KickoffTile(date: nextMatch["date"], heure: nextMatch["heure"] ,),
            ],
          ),
        ),
      );
    },
  );
}

}

class _TeamBadge extends StatelessWidget {
  final String name;
  const _TeamBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 18, backgroundImage: NetworkImage(MatchCard.getImgFlag(name))),
        const SizedBox(height: 12),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class NextMatchGainde extends StatelessWidget {

  final String equipe1;
  final String equipe2;
  const NextMatchGainde({required this.equipe1,required this.equipe2});

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Équipe 1
                  _TeamBadge(
                    name: equipe1,
                  ),

                  // VS stylisé
                  const Column(
                    children: [
                      Text(
                        "vs",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Équipe 2
                  _TeamBadge(
                    name: equipe2,
                  ),
                ],
              );
  }
}

class _KickoffTile extends StatelessWidget {

  final String date;
  final String heure;

  _KickoffTile({required this.date, required this.heure});

  DateTime get targetTime => DateTime.parse("$date $heure:00");


  String _fmt(Duration d) {
    if (d.isNegative) return 'En approche';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    // final remain = kickoff.difference(DateTime.now());
    return GlassCard(
      child: Row(
        children: [
          MatchCountdown(targetTime: targetTime),
          Spacer(),
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
  return await MatchService().getMatchs();
}

Future<Map<String, dynamic>> getNextMatch() async {
  return await  MatchService().getNextMatch(); 
}

class MatchHub extends StatefulWidget {
  MatchHub({super.key});

  @override
  State<MatchHub> createState() => _MatchHubState();
}

class _MatchHubState extends State<MatchHub> {
  @override
  Widget build(BuildContext context) {
    
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
            const SizedBox(height: 8),

            // Premier card avec "Match du jour" intégré
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
            //       Center(
            //   child: Text(
            //     "Match des Lions",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.grey.shade700,
            //       letterSpacing: 0.3,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20,),
            // NextMatchGainde(equipe1: "Sénégal", equipe2: "Brésil",),
            

            SizedBox(height: 30,),
                  Center(
              child: Text(
                "Calendrier de la CAN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 18),
                  // MatchHeader neutre
                  const _MatchHeader(),

                  const SizedBox(height: 6),

                  // Petit texte "Match du jour"
                  const SizedBox(height: 12),

                  // KickoffTile neutre
                  
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Autres matchs à venir
      
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