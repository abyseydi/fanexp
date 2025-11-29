import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/matchCard.dart';
import 'package:fanexp/services/match/match.service.dart';
import 'package:fanexp/widgets/countDown.dart';
import 'package:intl/intl.dart';

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
        final kickoff = DateTime.now().add(
          const Duration(hours: 2, minutes: 30),
        );

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
                    _TeamBadge(name: nextMatch["equipe1"] ?? "???"),

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
                    _TeamBadge(name: nextMatch["equipe2"] ?? "???"),
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
                SizedBox(height: 20),
                _KickoffTile(
                  date: nextMatch["date"],
                  heure: nextMatch["heure"],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _TeamBadge extends StatelessWidget {
//   final String name;
//   const _TeamBadge({required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(radius: 18, backgroundImage: NetworkImage(MatchCard.getImgFlag(name))),
//         const SizedBox(height: 12),
//         Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
//       ],
//     );
//   }
// }

class _TeamBadge extends StatelessWidget {
  final String name;
  final bool isTextWhite;

  const _TeamBadge({
    required this.name,
    this.isTextWhite = false, // 🔥 nouveau paramètre
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cercle stylé avec bord blanc
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(MatchCard.getImgFlag(name)),
          ),
        ),

        const SizedBox(height: 12),

        // ----- Texte adaptable -----
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isTextWhite ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}

class NextMatchGainde extends StatelessWidget {
  final String equipe1;
  final String equipe2;
  const NextMatchGainde({
    super.key,
    required this.equipe1,
    required this.equipe2,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Équipe 1
        _TeamBadge(name: equipe1, isTextWhite: true),

        // VS stylisé
        const Column(
          children: [
            Text(
              "vs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        // Équipe 2
        _TeamBadge(name: equipe2, isTextWhite: true),
      ],
    );
  }
}

Widget prochainMatchGaindeCard({
  required String equipe1,
  required String equipe2,
  required String date,
  required String heure,
  required String lieu,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Color(0xFF007A33),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),

        // ----- LES ÉQUIPES + INFOS -----
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _TeamBadge(name: equipe1, isTextWhite: true),

            // ----- LIEU + HEURE -----
            Column(
              children: [
                Text(
                  lieu,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  heure,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            _TeamBadge(name: equipe2, isTextWhite: true),
          ],
        ),

        const SizedBox(height: 14),

        // ----- DATE -----
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            formatDateFr(date),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

String formatDateFr(String dateStr) {
  // Convertit la string en DateTime
  DateTime date = DateTime.parse(dateStr);

  // Formatte la date en français
  final DateFormat formatter = DateFormat("dd MMMM yyyy", "fr_FR");

  return formatter.format(date);
}

class _KickoffTile extends StatelessWidget {
  final String date;
  final String heure;

  const _KickoffTile({required this.date, required this.heure});

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
  return await MatchService().getNextMatch();
}

class MatchHub extends StatefulWidget {
  const MatchHub({super.key});

  @override
  State<MatchHub> createState() => _MatchHubState();
}

class _MatchHubState extends State<MatchHub> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  Center(
                    child: Text(
                      "Match des Lions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //NextMatchGainde(equipe1: "Sénégal", equipe2: "Brésil",),
                  FutureBuilder<Map<String, dynamic>>(
                    future: MatchService().getNextMatchSenegal(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucun match disponible'),
                        );
                      }

                      final nextMatchSenegal = snapshot.data!;

                      return prochainMatchGaindeCard(
                        equipe1: nextMatchSenegal["equipe1"],
                        equipe2: nextMatchSenegal["equipe2"],
                        date: nextMatchSenegal["date"],
                        heure: nextMatchSenegal["heure"],
                        lieu: nextMatchSenegal["ville"],
                      );
                    },
                  ),

                  SizedBox(height: 30),
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
