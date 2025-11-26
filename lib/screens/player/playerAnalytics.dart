// import 'dart:math';

// import 'package:flutter/material.dart';

// const gaindeGreen = Color(0xFF007A33);
// const gaindeGold = Color(0xFFFFD100);
// const gaindeRed = Color(0xFFE31E24);
// const gaindeInk = Color(0xFF0F1D13);
// const gaindeBg = Color(0xFFF6F8FB);
// const gaindeGreenSoft = Color(0xFFE5F3EC);
// const gaindeGoldSoft = Color(0xFFFFF4C2);
// const gaindeRedSoft = Color(0xFFFCE1E3);

// class Player {
//   final String name;
//   final String position;
//   final int age;
//   final String club;
//   final int number;
//   final int minutes;
//   final int goals;
//   final int assists;
//   final List<String> injuries;
//   final double form;
//   final List<double> workload;
//   final Map<String, double> metrics;
//   final List<String> recentMatches;

//   const Player({
//     required this.name,
//     required this.position,
//     required this.age,
//     required this.club,
//     required this.number,
//     required this.minutes,
//     required this.goals,
//     required this.assists,
//     required this.injuries,
//     required this.form,
//     required this.workload,
//     required this.metrics,
//     required this.recentMatches,
//   });
// }

// /// ---------- Données mock ----------
// final _playersMock = <Player>[
//   Player(
//     name: "Sadio Mané",
//     position: "FW",
//     age: 33,
//     club: "Al Nassr",
//     number: 10,
//     minutes: 2430,
//     goals: 18,
//     assists: 8,
//     injuries: const ["Ischio - J12 (court)"],
//     form: .86,
//     workload: const [.62, .70, .68, .74, .80, .76, .82, .78],
//     metrics: const {
//       "Vitesse": .88,
//       "Dribble": .90,
//       "Passe": .78,
//       "Tir": .84,
//       "Pressing": .72,
//       "Duels": .66,
//     },
//     recentMatches: const ["vs MAR: 7.6", "vs EGY: 7.3", "vs CIV: 8.0"],
//   ),
//   Player(
//     name: "Ismaïla Sarr",
//     position: "FW",
//     age: 27,
//     club: "OM",
//     number: 23,
//     minutes: 2200,
//     goals: 12,
//     assists: 9,
//     injuries: const [],
//     form: .79,
//     workload: const [.50, .55, .60, .62, .65, .70, .72, .74],
//     metrics: const {
//       "Vitesse": .92,
//       "Dribble": .82,
//       "Passe": .70,
//       "Tir": .73,
//       "Pressing": .75,
//       "Duels": .64,
//     },
//     recentMatches: const ["vs MAR: 7.2", "vs EGY: 7.0", "vs CIV: 7.5"],
//   ),
//   Player(
//     name: "Kalidou Koulibaly",
//     position: "DF",
//     age: 34,
//     club: "Al Hilal",
//     number: 3,
//     minutes: 2700,
//     goals: 2,
//     assists: 1,
//     injuries: const ["Cheville - J3 (léger)"],
//     form: .81,
//     workload: const [.58, .60, .64, .66, .68, .70, .73, .75],
//     metrics: const {
//       "Vitesse": .64,
//       "Dribble": .40,
//       "Passe": .76,
//       "Tir": .30,
//       "Pressing": .78,
//       "Duels": .90,
//     },
//     recentMatches: const ["vs MAR: 7.9", "vs EGY: 7.4", "vs CIV: 7.7"],
//   ),
//   Player(
//     name: "Idrissa Gana Gueye",
//     position: "MF",
//     age: 36,
//     club: "Everton",
//     number: 5,
//     minutes: 2550,
//     goals: 3,
//     assists: 4,
//     injuries: const [],
//     form: .75,
//     workload: const [.54, .56, .58, .60, .65, .63, .66, .68],
//     metrics: const {
//       "Vitesse": .66,
//       "Dribble": .58,
//       "Passe": .80,
//       "Tir": .46,
//       "Pressing": .88,
//       "Duels": .82,
//     },
//     recentMatches: const ["vs MAR: 7.1", "vs EGY: 6.9", "vs CIV: 7.3"],
//   ),
// ];

// class PlayerAnalytics extends StatefulWidget {
//   const PlayerAnalytics({super.key});
//   @override
//   State<PlayerAnalytics> createState() => _PlayerAnalyticsState();
// }

// class _PlayerAnalyticsState extends State<PlayerAnalytics> {
//   String query = "";
//   String posFilter = "ALL";
//   final Set<Player> compareSet = {};

//   List<Player> get filtered {
//     return _playersMock.where((p) {
//       final okPos = posFilter == "ALL" || p.position == posFilter;
//       final okQ =
//           query.isEmpty ||
//           p.name.toLowerCase().contains(query.toLowerCase()) ||
//           p.club.toLowerCase().contains(query.toLowerCase());
//       return okPos && okQ;
//     }).toList();
//   }

//   void _toggleCompare(Player p) {
//     setState(() {
//       if (compareSet.contains(p)) {
//         compareSet.remove(p);
//       } else {
//         if (compareSet.length >= 3) return;
//         compareSet.add(p);
//       }
//     });
//   }

//   void _openCompareSheet() {
//     if (compareSet.length < 2) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Sélectionne au moins 2 joueurs.")),
//       );
//       return;
//     }
//     showModalBottomSheet(
//       context: context,
//       useSafeArea: true,
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
//       ),
//       builder: (_) {
//         final players = compareSet.toList();
//         final keys = <String>{
//           for (final p in players) ...p.metrics.keys,
//         }.toList();
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.black12,
//                   borderRadius: BorderRadius.circular(99),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 "Comparateur (Radar)",
//                 style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: 280,
//                 child: RadarCompare(
//                   metricsKeys: keys,
//                   players: players,
//                   colors: const [gaindeGreen, gaindeRed, gaindeInk],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: List.generate(players.length, (i) {
//                   return Chip(
//                     avatar: CircleAvatar(
//                       radius: 10,
//                       backgroundColor: [gaindeGreen, gaindeRed, gaindeInk][i],
//                     ),
//                     label: Text(players[i].name),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _openPlayer(Player p) {
//     Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (_) => PlayerDetailPage(player: p)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: gaindeBg,
//       appBar: AppBar(
//         title: const Text("Analytics Joueurs"),
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//         foregroundColor: gaindeInk,
//         actions: [
//           IconButton(
//             onPressed: _openCompareSheet,
//             tooltip: "Comparer (2–3)",
//             icon: Stack(
//               children: [
//                 const Icon(Icons.auto_awesome_motion_outlined),
//                 if (compareSet.isNotEmpty)
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(3),
//                       decoration: const BoxDecoration(
//                         color: gaindeGreen,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         "${compareSet.length}",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Rechercher joueur, club...",
//                     prefixIcon: const Icon(Icons.search),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 10,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(
//                         color: Colors.black.withOpacity(.12),
//                       ),
//                     ),
//                   ),
//                   onChanged: (v) => setState(() => query = v),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               _PosFilter(
//                 value: posFilter,
//                 onChanged: (v) => setState(() => posFilter = v),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),

//           _AiHintCard(
//             title: "Suggestion IA",
//             lines: const [
//               "Forme offensive en hausse côté droit (xThreat↑).",
//               "Recommandation: Sarr + Mané pour transitions rapides.",
//             ],
//           ),
//           const SizedBox(height: 12),

//           ...filtered.map(
//             (p) => _PlayerRowCard(
//               player: p,
//               selected: compareSet.contains(p),
//               onCompare: () => _toggleCompare(p),
//               onOpen: () => _openPlayer(p),
//             ),
//           ),
//           const SizedBox(height: 8),
//           if (filtered.isEmpty)
//             const Center(child: Text("Aucun joueur trouvé.")),
//         ],
//       ),
//       floatingActionButton: compareSet.length >= 2
//           ? FloatingActionButton.extended(
//               backgroundColor: gaindeGreen,
//               foregroundColor: Colors.white,
//               onPressed: _openCompareSheet,
//               icon: const Icon(Icons.auto_awesome_motion),
//               label: const Text("Comparer"),
//             )
//           : null,
//     );
//   }
// }

// class _PosFilter extends StatelessWidget {
//   final String value;
//   final ValueChanged<String> onChanged;
//   const _PosFilter({required this.value, required this.onChanged});
//   @override
//   Widget build(BuildContext context) {
//     final items = const ["ALL", "GK", "DF", "MF", "FW"];
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.black.withOpacity(.12)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isDense: true,
//           items: items
//               .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//               .toList(),
//           onChanged: (v) => v == null ? null : onChanged(v),
//         ),
//       ),
//     );
//   }
// }

// class _AiHintCard extends StatelessWidget {
//   final String title;
//   final List<String> lines;
//   const _AiHintCard({required this.title, required this.lines});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: gaindeGoldSoft,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.black.withOpacity(.06)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: const [
//               Icon(Icons.auto_awesome_rounded, color: gaindeInk),
//               SizedBox(width: 8),
//               Text("Insight IA", style: TextStyle(fontWeight: FontWeight.w800)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           ...lines.map(
//             (t) => Row(
//               children: [
//                 const Icon(Icons.bolt_rounded, size: 16),
//                 const SizedBox(width: 6),
//                 Expanded(child: Text(t)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PlayerRowCard extends StatelessWidget {
//   final Player player;
//   final bool selected;
//   final VoidCallback onCompare;
//   final VoidCallback onOpen;
//   const _PlayerRowCard({
//     required this.player,
//     required this.selected,
//     required this.onCompare,
//     required this.onOpen,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = switch (player.position) {
//       "GK" => Colors.blueGrey,
//       "DF" => Colors.teal,
//       "MF" => Colors.orange,
//       "FW" => gaindeRed,
//       _ => gaindeInk,
//     };

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.black.withOpacity(.06)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: gaindeGreenSoft,
//               border: Border.all(color: Colors.black.withOpacity(.06)),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               player.number.toString(),
//               style: const TextStyle(fontWeight: FontWeight.w900),
//             ),
//           ),
//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   player.name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Opacity(
//                   opacity: .8,
//                   child: Text(
//                     "${player.position} • ${player.club}",
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 LayoutBuilder(
//                   builder: (ctx, constraints) {
//                     final canShowSpark = constraints.maxWidth > 300;
//                     return Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Wrap(
//                             spacing: 6,
//                             runSpacing: 6,
//                             children: [
//                               _MiniChip(
//                                 icon: Icons.timer,
//                                 text: "${player.minutes}'",
//                               ),
//                               _MiniChip(
//                                 icon: Icons.sports_soccer,
//                                 text: "${player.goals}",
//                               ),
//                               _MiniChip(
//                                 icon: Icons.diversity_2_rounded,
//                                 text: "${player.assists}",
//                               ),
//                             ],
//                           ),
//                         ),

//                         if (canShowSpark) ...[
//                           const SizedBox(width: 8),
//                           SizedBox(
//                             width: 88,
//                             height: 28,
//                             child: Sparkline(
//                               values: player.workload,
//                               stroke: color,
//                             ),
//                           ),
//                         ],
//                       ],
//                     );
//                   },
//                 ),

//                 if (player.injuries.isNotEmpty) ...[
//                   const SizedBox(height: 6),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 6,
//                     children: player.injuries
//                         .map(
//                           (inj) => Chip(
//                             label: Text(
//                               inj,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             backgroundColor: gaindeRedSoft,
//                             side: const BorderSide(color: gaindeRed),
//                             padding: EdgeInsets.zero,
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           const SizedBox(width: 10),

//           ConstrainedBox(
//             constraints: const BoxConstraints(minWidth: 80, maxWidth: 96),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 IconButton(
//                   tooltip: selected
//                       ? "Retirer de la comparaison"
//                       : "Ajouter à la comparaison",
//                   onPressed: onCompare,
//                   icon: Icon(
//                     selected ? Icons.done_all_rounded : Icons.add_chart_rounded,
//                     color: selected ? gaindeGreen : gaindeInk,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 SizedBox(
//                   height: 36,
//                   child: FilledButton(
//                     onPressed: onOpen,
//                     style: FilledButton.styleFrom(
//                       backgroundColor: gaindeGreen,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       textStyle: const TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                     child: const FittedBox(child: Text("Fiche")),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _MiniChip extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   const _MiniChip({required this.icon, required this.text});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: BoxDecoration(
//         color: gaindeBg,
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: Colors.black.withOpacity(.08)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14),
//           const SizedBox(width: 4),
//           Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
//         ],
//       ),
//     );
//   }
// }

// class RadarCompare extends StatelessWidget {
//   final List<String> metricsKeys;
//   final List<Player> players;
//   final List<Color> colors;
//   const RadarCompare({
//     super.key,
//     required this.metricsKeys,
//     required this.players,
//     required this.colors,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _RadarPainter(metricsKeys, players, colors),
//       child: Container(),
//     );
//   }
// }

// class _RadarPainter extends CustomPainter {
//   final List<String> keys;
//   final List<Player> players;
//   final List<Color> colors;

//   _RadarPainter(this.keys, this.players, this.colors);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.shortestSide / 2) * .82;
//     final n = keys.length;
//     if (n == 0) return;

//     final gridPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = Colors.black.withOpacity(.12)
//       ..strokeWidth = 1;

//     for (int r = 1; r <= 4; r++) {
//       _drawPolygon(canvas, center, radius * (r / 4), n, gridPaint);
//     }

//     // labels
//     final textPainter = TextPainter(textDirection: TextDirection.ltr);
//     for (int i = 0; i < n; i++) {
//       final angle = -90.0 + (360.0 * i / n);
//       final rad = angle * 3.14159265 / 180.0;
//       final pos =
//           center + Offset(radius * 1.06 * cos(rad), radius * 1.06 * sin(rad));
//       textPainter.text = TextSpan(
//         text: keys[i],
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//           color: gaindeInk,
//         ),
//       );
//       textPainter.layout();
//       final offset =
//           pos - Offset(textPainter.width / 2, textPainter.height / 2);
//       textPainter.paint(canvas, offset);
//     }

//     // polygones joueurs
//     for (int p = 0; p < players.length; p++) {
//       final path = Path();
//       for (int i = 0; i < n; i++) {
//         final key = keys[i];
//         final v = (players[p].metrics[key] ?? 0).clamp(0.0, 1.0);
//         final angle = -90.0 + (360.0 * i / n);
//         final rad = angle * 3.14159265 / 180.0;
//         final pt =
//             center + Offset(radius * v * cos(rad), radius * v * sin(rad));
//         if (i == 0) {
//           path.moveTo(pt.dx, pt.dy);
//         } else {
//           path.lineTo(pt.dx, pt.dy);
//         }
//       }
//       path.close();

//       final fill = Paint()
//         ..style = PaintingStyle.fill
//         ..color = colors[p % colors.length].withOpacity(.18);
//       final stroke = Paint()
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2
//         ..color = colors[p % colors.length];

//       canvas.drawPath(path, fill);
//       canvas.drawPath(path, stroke);
//     }
//   }

//   void _drawPolygon(Canvas c, Offset center, double r, int n, Paint paint) {
//     final path = Path();
//     for (int i = 0; i < n; i++) {
//       final angle = -90.0 + (360.0 * i / n);
//       final rad = angle * 3.14159265 / 180.0;
//       final pt = center + Offset(r * cos(rad), r * sin(rad));
//       if (i == 0) {
//         path.moveTo(pt.dx, pt.dy);
//       } else {
//         path.lineTo(pt.dx, pt.dy);
//       }
//     }
//     path.close();
//     c.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant _RadarPainter old) =>
//       old.keys != keys || old.players != players;
// }

// class Sparkline extends StatelessWidget {
//   final List<double> values; // 0..1
//   final Color stroke;
//   const Sparkline({super.key, required this.values, required this.stroke});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(painter: _SparkPainter(values, stroke));
//   }
// }

// class _SparkPainter extends CustomPainter {
//   final List<double> v;
//   final Color color;
//   _SparkPainter(this.v, this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (v.isEmpty) return;
//     final maxW = size.width;
//     final maxH = size.height;
//     final step = maxW / (v.length - 1);
//     final path = Path()..moveTo(0, maxH * (1 - v.first.clamp(0, 1)));
//     for (int i = 1; i < v.length; i++) {
//       path.lineTo(i * step, maxH * (1 - v[i].clamp(0, 1)));
//     }
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2
//       ..color = color;
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant _SparkPainter oldDelegate) =>
//       oldDelegate.v != v || oldDelegate.color != color;
// }

// class PlayerDetailPage extends StatelessWidget {
//   final Player player;
//   const PlayerDetailPage({super.key, required this.player});

//   @override
//   Widget build(BuildContext context) {
//     final keys = player.metrics.keys.toList();
//     return Scaffold(
//       backgroundColor: gaindeBg,
//       appBar: AppBar(
//         title: Text(player.name),
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//         foregroundColor: gaindeInk,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.black.withOpacity(.06)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 64,
//                   height: 64,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: gaindeGreenSoft,
//                     border: Border.all(color: Colors.black.withOpacity(.06)),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     player.number.toString(),
//                     style: const TextStyle(fontWeight: FontWeight.w900),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${player.name} • ${player.position}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w800,
//                           fontSize: 18,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Opacity(
//                         opacity: .8,
//                         child: Text("${player.age} ans • ${player.club}"),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 6,
//                         runSpacing: 6,
//                         children: [
//                           _MiniChip(
//                             icon: Icons.timer,
//                             text: "${player.minutes}'",
//                           ),
//                           _MiniChip(
//                             icon: Icons.sports_soccer,
//                             text: "${player.goals}",
//                           ),
//                           _MiniChip(
//                             icon: Icons.diversity_2_rounded,
//                             text: "${player.assists}",
//                           ),
//                           _MiniChip(
//                             icon: Icons.auto_graph_rounded,
//                             text: "Forme ${(player.form * 100).round()}%",
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: _cardDeco(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Profil radar",
//                   style: TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 260,
//                   child: RadarCompare(
//                     metricsKeys: keys,
//                     players: [player],
//                     colors: const [gaindeGreen],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: _cardDeco(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Charge de travail (8 semaines)",
//                   style: TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 64,
//                   child: WorkloadBars(values: player.workload),
//                 ),
//                 const SizedBox(height: 8),
//                 const Opacity(
//                   opacity: .8,
//                   child: Text(
//                     "Suivi charge: prévention blessures, optimisation rotation.",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           if (player.injuries.isNotEmpty)
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: _cardDeco(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Historique blessures",
//                     style: TextStyle(fontWeight: FontWeight.w800),
//                   ),
//                   const SizedBox(height: 8),
//                   ...player.injuries.map(
//                     (e) => Row(
//                       children: [
//                         const Icon(
//                           Icons.medical_services_outlined,
//                           color: gaindeRed,
//                           size: 18,
//                         ),
//                         const SizedBox(width: 6),
//                         Expanded(child: Text(e)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           if (player.injuries.isNotEmpty) const SizedBox(height: 12),

//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: _cardDeco(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Tendance minutes & forme",
//                   style: TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: SizedBox(
//                         height: 40,
//                         child: Sparkline(
//                           values: player.workload,
//                           stroke: gaindeInk,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: SizedBox(
//                         height: 40,
//                         child: Sparkline(
//                           values: _smooth(player.workload),
//                           stroke: gaindeGreen,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 const Opacity(
//                   opacity: .8,
//                   child: Text(
//                     "Ligne noire: charge • Ligne verte: forme lissée (proxy).",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: _cardDeco(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Derniers matches",
//                   style: TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 ...player.recentMatches.map(
//                   (m) => ListTile(
//                     dense: true,
//                     contentPadding: EdgeInsets.zero,
//                     leading: const Icon(Icons.sports_soccer_outlined),
//                     title: Text(m),
//                     trailing: const Icon(Icons.chevron_right_rounded),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static BoxDecoration _cardDeco() => BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(16),
//     border: Border.all(color: Colors.black.withOpacity(.06)),
//   );

//   List<double> _smooth(List<double> v) {
//     if (v.isEmpty) return v;
//     final out = <double>[];
//     for (int i = 0; i < v.length; i++) {
//       final a = i > 0 ? v[i - 1] : v[i];
//       final b = v[i];
//       final c = i < v.length - 1 ? v[i + 1] : v[i];
//       out.add((a + b + c) / 3);
//     }
//     return out;
//   }
// }

// class WorkloadBars extends StatelessWidget {
//   final List<double> values; // 0..1
//   const WorkloadBars({super.key, required this.values});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: List.generate(values.length, (i) {
//         final v = values[i].clamp(0.0, 1.0);
//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(right: i == values.length - 1 ? 0 : 4),
//             child: Container(
//               height: 16 + 48 * v,
//               decoration: BoxDecoration(
//                 color: gaindeGreen.withOpacity(.75),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// lib/screens/players/players_list_screen.dart

import 'package:fanexp/entity/player.entity.dart';
import 'package:fanexp/screens/player/playerDetail.dart';
import 'package:fanexp/services/player/player.service.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:flutter/material.dart';

class PlayerAnalytics extends StatefulWidget {
  const PlayerAnalytics({super.key});

  @override
  State<PlayerAnalytics> createState() => _PlayerAnalyticsState();
}

class _PlayerAnalyticsState extends State<PlayerAnalytics> {
  final PlayerService _playerService = PlayerService();
  late Future<List<PlayerEntity>> _futurePlayers;

  String _query = '';
  String _positionFilter = 'Tous';

  final List<String> _positionFilters = const [
    'Tous',
    'GARDIEN',
    'DEFENSEUR',
    'MILIEU',
    'ATTAQUANT',
  ];

  @override
  void initState() {
    super.initState();
    _futurePlayers = _playerService.getPlayers();
  }

  void _reload() {
    setState(() {
      _futurePlayers = _playerService.getPlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Stats joueurs'), centerTitle: false),
      backgroundColor: cs.background,
      body: FutureBuilder<List<PlayerEntity>>(
        future: _futurePlayers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _PlayersSkeleton();
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: gaindeRed),
                    const SizedBox(height: 12),
                    const Text(
                      'Impossible de charger les joueurs',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: gaindeInk.withOpacity(.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final players = snapshot.data ?? <PlayerEntity>[];
          if (players.isEmpty) {
            return const Center(
              child: Text(
                'Aucun joueur disponible.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }

          final filtered = players.where((p) {
            final okSearch =
                _query.trim().isEmpty ||
                p.fullName.toLowerCase().contains(_query.trim().toLowerCase());
            final cat = p.positionCategory.toUpperCase();
            bool okPos = true;
            if (_positionFilter != 'Tous') {
              okPos = cat == _positionFilter.toUpperCase();
            }
            return okSearch && okPos;
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profil IA des Lions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Explore les stats, la forme et les insights IA des joueurs.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: gaindeInk.withOpacity(.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un joueur…',
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: gaindeInk.withOpacity(.1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: gaindeInk.withOpacity(.1),
                            ),
                          ),
                        ),
                        onChanged: (v) => setState(() => _query = v.trim()),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _positionFilters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final f = _positionFilters[i];
                            final selected = f == _positionFilter;
                            return ChoiceChip(
                              label: Text(f),
                              selected: selected,
                              onSelected: (_) =>
                                  setState(() => _positionFilter = f),
                              selectedColor: gaindeGreenSoft,
                              side: BorderSide(
                                color: selected
                                    ? gaindeGreen.withOpacity(.4)
                                    : gaindeInk.withOpacity(.12),
                              ),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: selected ? gaindeGreen : gaindeInk,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final p = filtered[index];
                    return _PlayerCard(
                      player: p,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerDetail(player: p),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final PlayerEntity player;
  final VoidCallback onTap;

  const _PlayerCard({required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFE1F4EC), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: gaindeGreen.withOpacity(.15)),
          boxShadow: [
            BoxShadow(
              color: gaindeInk.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Hero(
              tag: 'player_photo_${player.id}',
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                backgroundImage: player.photoUrl.isNotEmpty
                    ? NetworkImage(player.photoUrl)
                    : null,
                child: player.photoUrl.isEmpty
                    ? const Icon(Icons.person, color: gaindeGreen, size: 32)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (player.clubLogoUrl.isNotEmpty)
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(player.clubLogoUrl),
                          backgroundColor: Colors.white,
                        ),
                      if (player.clubLogoUrl.isNotEmpty)
                        const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          player.club,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: gaindeInk.withOpacity(.8),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _pill(
                        label:
                            '#${player.jerseyNumber} · ${player.primaryPosition}',
                      ),
                      const SizedBox(width: 6),
                      _pill(
                        label: 'Âge ${player.age}',
                        icon: Icons.cake_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gaindeGreen,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        player.formRating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Note IA',
                  style: TextStyle(
                    fontSize: 11,
                    color: gaindeInk.withOpacity(.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill({required String label, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: gaindeGreen.withOpacity(.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: gaindeGreen),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _PlayersSkeleton extends StatelessWidget {
  const _PlayersSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 90,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
          ),
        );
      },
    );
  }
}
