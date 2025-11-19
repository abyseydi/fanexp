import 'package:fanexp/screens/fanzone/fanprofile.dart';
import 'package:fanexp/screens/home/home.dart'
    hide gaindeGreen, gaindeGold, gaindeInk;
import 'package:flutter/material.dart';

class TicketingSpotlight extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;
  final DateTime dateTime;
  final String stadium;
  final String city;
  final int fromPriceFcfa;
  final String bannerAsset;
  final VoidCallback onOpenTickets;

  const TicketingSpotlight({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.dateTime,
    required this.stadium,
    required this.city,
    required this.fromPriceFcfa,
    required this.bannerAsset,
    required this.onOpenTickets,
  });

  String _fmtDate(DateTime d) {
    final wd = [
      'Lun.',
      'Mar.',
      'Mer.',
      'Jeu.',
      'Ven.',
      'Sam.',
      'Dim.',
    ][d.weekday - 1];
    final mo = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Juin',
      'Juil',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc',
    ][d.month - 1];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$wd ${d.day} $mo — $h:$m';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  bannerAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: gaindeLine,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.confirmation_num_outlined,
                      color: gaindeInk,
                      size: 42,
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x30000000),
                        Color(0x80000000),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ruban
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: gaindeGold.withOpacity(.95),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Billetterie officielle',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: gaindeInk,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$homeTeam  vs  $awayTeam',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        shadows: [
                          Shadow(blurRadius: 14, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _fmtDate(dateTime),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '$stadium • $city',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'À partir de ',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                TextSpan(
                                  text: _fcfa(fromPriceFcfa),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 38,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: gaindeGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: onOpenTickets,
                              icon: const Icon(Icons.confirmation_num_outlined),
                              label: const Text(
                                'Acheter',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Ripple
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(onTap: onOpenTickets),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
