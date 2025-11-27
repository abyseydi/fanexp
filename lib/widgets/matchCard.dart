import 'package:flutter/material.dart';
import 'package:fanexp/constants/country_code/country_code.dart';



String urlFlagcdn ="https://flagcdn.com";
bool flagInconnu = false;
class MatchCard extends StatelessWidget {
  final String date;
  final String time;
  final String team1;
  final String team2;
  final String stadium;
  final String phase;
  final String city;
  final String team1Logo;
  final String team2Logo;

  

  const MatchCard({
    super.key,
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
    required this.stadium,
    required this.phase,
    required this.city,
    required this.team1Logo,
    required this.team2Logo,
  });

  @override
  Widget build(BuildContext context) {

    

    return InkWell(
      // onTap: () {
      //   // Navigation vers l'écran de détails
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => MatchDetailsCard(),
      //     ),
      //   );
      // },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              // HEADER avec phase
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: Colors.grey.shade200,
                child: Text(
                  phase,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              // IMAGE DE FOND (optionnelle)
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/img/stade.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 16,
                      child: Text(
                        stadium,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 16,
                      child: Text(
                        city,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Date & Heure
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoItem(Icons.calendar_today, date),
                        _infoItem(Icons.access_time, time),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Logos équipes + VS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:  NetworkImage(getImgFlag(team1)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              team1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const Text(
                          "VS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Column(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(getImgFlag(team2)) ,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              team2,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }


  // fonction util

  String? getCountryISOCode(String country)
  {
    return countriesISO[country];
   
  }

  String getImgFlag(String country){

    String isoCode = countriesISO[country] ?? "inconnu";

    if(isoCode == "inconnu"){
      return "https://img.freepik.com/vecteurs-libre/illustration-realiste-coupe-or-ruban-rouge-gagnant-leader-champion_1262-13474.jpg?semt=ais_hybrid&w=740&q=80";
    }
    return '$urlFlagcdn/w80/$isoCode.png';
  }

}