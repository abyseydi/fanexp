// import 'package:fanexp/constants/colors/main_color.dart'
//     hide gaindeGreen, gaindeRed, gaindeGold;
// import 'package:fanexp/entity/femalePlayer.entity.dart';
// import 'package:fanexp/screens/notificationHome.dart';
// import 'package:fanexp/screens/settings/settings.dart'
//     hide gaindeInk, gaindeGreen, gaindeBg, gaindeGreenSoft, gaindeGold;
// import 'package:fanexp/services/player/femalePlayer.service.dart';
// import 'package:flutter/material.dart';

// import 'package:fanexp/services/player/staff.service.dart';
// import 'package:fanexp/entity/staff.entity.dart';

// import 'package:fanexp/theme/gainde_theme.dart' hide gaindeRed;
// import 'package:fanexp/widgets/glasscard.dart';

// class FemalePlayerStaff extends StatefulWidget {
//   const FemalePlayerStaff({super.key});

//   @override
//   State<FemalePlayerStaff> createState() => _FemalePlayerStaffState();
// }

// class _FemalePlayerStaffState extends State<FemalePlayerStaff>
//     with SingleTickerProviderStateMixin {
//   late final TabController _tabController;

//   final FemalePlayerService femalePlayerService = FemalePlayerService();
//   final StaffService staffService = StaffService();

//   late Future<List<FemalePlayerEntity>> futureFemalePlayers;
//   late Future<List<StaffEntity>> futureFemaleStaff;

//   // Filtres joueuses
//   String _playerQuery = '';
//   String _positionFilter = 'Tous';

//   final List<String> _positionFilters = const [
//     'Tous',
//     'GARDIEN',
//     'DEFENSEUR',
//     'MILIEU',
//     'ATTAQUANT',
//   ];

//   // Filtre staff
//   String _staffQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);

//     futureFemalePlayers = femalePlayerService.getFemalePlayers();
//     futureFemaleStaff = staffService
//         .getStaff(); // à adapter si staff féminin séparé
//   }

//   void _reloadFemalePlayers() {
//     setState(() {
//       futureFemalePlayers = femalePlayerService.getFemalePlayers();
//     });
//   }

//   void _reloadFemaleStaff() {
//     setState(() {
//       futureFemaleStaff = staffService.getStaff();
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: gaindeBg,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//         title: Row(
//           children: [
//             SizedBox(
//               height: 28,
//               width: 28,
//               child: Image.asset(
//                 'assets/img/federation.png',
//                 errorBuilder: (_, __, ___) => const Icon(
//                   Icons.sports_soccer_outlined,
//                   color: gaindeGreen,
//                   size: 22,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               'Foot féminin',
//               style: TextStyle(fontWeight: FontWeight.w800, color: gaindeInk),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const NotificationHome()),
//               );
//             },
//             icon: const Icon(
//               Icons.notifications_none_rounded,
//               color: gaindeInk,
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               Navigator.of(
//                 context,
//               ).push(MaterialPageRoute(builder: (_) => const Settings()));
//             },
//             icon: const Icon(Icons.settings, color: gaindeInk),
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: gaindeGreen,
//           labelColor: gaindeGreen,
//           unselectedLabelColor: gaindeInk.withOpacity(.6),
//           labelStyle: const TextStyle(fontWeight: FontWeight.w700),
//           tabs: const [
//             Tab(icon: Icon(Icons.sports_soccer_rounded), text: 'Joueuses'),
//             Tab(icon: Icon(Icons.groups_2_rounded), text: 'Staff'),
//           ],
//         ),
//       ),

//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           const _GaindeBackground(),
//           TabBarView(
//             controller: _tabController,
//             children: [
//               _PlayersTab(
//                 // ICI le fix : on passe bien le Future, pas le service
//                 futureFemalePlayers: futureFemalePlayers,
//                 positionFilters: _positionFilters,
//                 positionFilter: _positionFilter,
//                 onPositionFilterChanged: (val) {
//                   setState(() => _positionFilter = val);
//                 },
//                 query: _playerQuery,
//                 onQueryChanged: (val) {
//                   setState(() => _playerQuery = val.trim());
//                 },
//                 onReload: _reloadFemalePlayers,
//               ),
//               _StaffTab(
//                 futureStaff: futureFemaleStaff,
//                 query: _staffQuery,
//                 onQueryChanged: (val) {
//                   setState(() => _staffQuery = val.trim());
//                 },
//                 onReload: _reloadFemaleStaff,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GaindeBackground extends StatelessWidget {
//   const _GaindeBackground();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         const DecoratedBox(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [gaindeBg, gaindeWhite, gaindeBg],
//             ),
//           ),
//         ),
//         Align(
//           alignment: const Alignment(0.85, -0.95),
//           child: Container(
//             width: size.width * .65,
//             height: size.width * .65,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 stops: [0, .6, 1],
//                 colors: [
//                   Color(0x29007A33),
//                   Color(0x14007A33),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// ------------------
// /// Onglet JOUEUSES
// /// ------------------

// class _PlayersTab extends StatelessWidget {
//   final Future<List<FemalePlayerEntity>> futureFemalePlayers;
//   final List<String> positionFilters;
//   final String positionFilter;
//   final ValueChanged<String> onPositionFilterChanged;
//   final String query;
//   final ValueChanged<String> onQueryChanged;
//   final VoidCallback onReload;

//   const _PlayersTab({
//     required this.futureFemalePlayers,
//     required this.positionFilters,
//     required this.positionFilter,
//     required this.onPositionFilterChanged,
//     required this.query,
//     required this.onQueryChanged,
//     required this.onReload,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<FemalePlayerEntity>>(
//       future: futureFemalePlayers,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const _PlayersSkeleton();
//         }

//         if (snapshot.hasError) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: GlassCard(
//                 background: Colors.white.withOpacity(.96),
//                 borderColor: Colors.black.withOpacity(.06),
//                 shadowColor: Colors.black.withOpacity(.08),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.error_outline, size: 48, color: gaindeRed),
//                     const SizedBox(height: 12),
//                     const Text(
//                       'Impossible de charger les joueuses',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       snapshot.error.toString(),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: gaindeInk.withOpacity(.7),
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: gaindeGreen,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: onReload,
//                       icon: const Icon(Icons.refresh_rounded),
//                       label: const Text('Réessayer'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         final players = snapshot.data ?? <FemalePlayerEntity>[];
//         if (players.isEmpty) {
//           return Center(
//             child: GlassCard(
//               background: Colors.white.withOpacity(.96),
//               child: const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   'Aucune joueuse disponible.',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           );
//         }

//         final filtered = players.where((p) {
//           final okSearch =
//               query.isEmpty ||
//               p.nom.toLowerCase().contains(query.toLowerCase());
//           final cat = p.positionCategory.toUpperCase();
//           bool okPos = true;
//           if (positionFilter != 'Tous') {
//             okPos = cat == positionFilter.toUpperCase();
//           }
//           return okSearch && okPos;
//         }).toList();

//         return CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GlassCard(
//                       background: Colors.white.withOpacity(.95),
//                       borderColor: Colors.black.withOpacity(.04),
//                       shadowColor: Colors.black.withOpacity(.04),
//                       child: Column(
//                         children: [
//                           TextField(
//                             decoration: InputDecoration(
//                               hintText: 'Rechercher une joueuse…',
//                               prefixIcon: const Icon(Icons.search_rounded),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(
//                                   color: gaindeInk.withOpacity(.05),
//                                 ),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide(
//                                   color: gaindeInk.withOpacity(.05),
//                                 ),
//                               ),
//                             ),
//                             onChanged: onQueryChanged,
//                           ),
//                           const SizedBox(height: 10),
//                           SizedBox(
//                             height: 36,
//                             child: ListView.separated(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: positionFilters.length,
//                               separatorBuilder: (_, __) =>
//                                   const SizedBox(width: 8),
//                               itemBuilder: (_, i) {
//                                 final f = positionFilters[i];
//                                 final selected = f == positionFilter;
//                                 return ChoiceChip(
//                                   label: Text(f),
//                                   selected: selected,
//                                   onSelected: (_) => onPositionFilterChanged(f),
//                                   selectedColor: gaindeGreenSoft,
//                                   side: BorderSide(
//                                     color: selected
//                                         ? gaindeGreen.withOpacity(.4)
//                                         : gaindeInk.withOpacity(.12),
//                                   ),
//                                   labelStyle: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     color: selected ? gaindeGreen : gaindeInk,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//               sliver: SliverList.separated(
//                 itemCount: filtered.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final p = filtered[index];
//                   return _PlayerCard(
//                     player: p,
//                     onTap: () {
//                       // TODO: ouvrir detail joueuse si tu le crées
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _PlayerCard extends StatelessWidget {
//   final FemalePlayerEntity player;
//   final VoidCallback onTap;

//   const _PlayerCard({required this.player, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: GlassCard(
//         background: const Color(0xFFE1F4EC),
//         borderColor: gaindeGreen.withOpacity(.15),
//         shadowColor: gaindeInk.withOpacity(.06),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//             gradient: const LinearGradient(
//               colors: [Color(0xFFE1F4EC), Colors.white],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               // Avatar = drapeau du pays du club + initiale de la joueuse
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.white,
//                 backgroundImage: player.paysClubPhotoUrl.isNotEmpty
//                     ? NetworkImage(player.paysClubPhotoUrl)
//                     : null,
//                 child: player.paysClubPhotoUrl.isEmpty
//                     ? Text(
//                         player.nom.isNotEmpty ? player.nom[0] : '?',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w800,
//                           fontSize: 22,
//                           color: gaindeGreen,
//                         ),
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       player.nom,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             player.club,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: gaindeInk.withOpacity(.8),
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: gaindeGreenSoft,
//                             borderRadius: BorderRadius.circular(999),
//                           ),
//                           child: Text(
//                             player.paysClub,
//                             style: const TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600,
//                               color: gaindeInk,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Wrap(
//                       spacing: 6,
//                       runSpacing: 4,
//                       children: [
//                         _pill(label: '#${player.numero} · ${player.position}'),
//                         _pill(
//                           label: 'Âge ${player.age}',
//                           icon: Icons.cake_outlined,
//                         ),
//                         if (player.tailleCm != null)
//                           _pill(
//                             label: '${player.tailleCm} cm',
//                             icon: Icons.height_rounded,
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _pill({required String label, IconData? icon}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.9),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: gaindeGreen.withOpacity(.18)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null) ...[
//             Icon(icon, size: 13, color: gaindeGreen),
//             const SizedBox(width: 4),
//           ],
//           Text(
//             label,
//             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PlayersSkeleton extends StatelessWidget {
//   const _PlayersSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//       itemCount: 6,
//       itemBuilder: (_, __) {
//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           height: 90,
//           decoration: BoxDecoration(
//             color: cs.surface,
//             borderRadius: BorderRadius.circular(18),
//           ),
//         );
//       },
//     );
//   }
// }

// /// ------------------
// /// Onglet STAFF
// /// ------------------

// class _StaffTab extends StatelessWidget {
//   final Future<List<StaffEntity>> futureStaff;
//   final String query;
//   final ValueChanged<String> onQueryChanged;
//   final VoidCallback onReload;

//   const _StaffTab({
//     required this.futureStaff,
//     required this.query,
//     required this.onQueryChanged,
//     required this.onReload,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<StaffEntity>>(
//       future: futureStaff,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const _StaffSkeleton();
//         }

//         if (snapshot.hasError) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: GlassCard(
//                 background: Colors.white.withOpacity(.96),
//                 borderColor: Colors.black.withOpacity(.06),
//                 shadowColor: Colors.black.withOpacity(.08),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.error_outline, size: 48, color: gaindeRed),
//                     const SizedBox(height: 12),
//                     const Text(
//                       'Impossible de charger le staff',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       snapshot.error.toString(),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: gaindeInk.withOpacity(.7),
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: gaindeGreen,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: onReload,
//                       icon: const Icon(Icons.refresh_rounded),
//                       label: const Text('Réessayer'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         final staffList = snapshot.data ?? <StaffEntity>[];
//         if (staffList.isEmpty) {
//           return Center(
//             child: GlassCard(
//               background: Colors.white.withOpacity(.96),
//               child: const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text(
//                   'Aucun membre du staff disponible.',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           );
//         }

//         final filtered = staffList.where((s) {
//           final lower = query.toLowerCase();
//           final okSearch =
//               query.isEmpty ||
//               s.nomComplet.toLowerCase().contains(lower) ||
//               s.postOccupe.toLowerCase().contains(lower);
//           return okSearch;
//         }).toList();

//         return CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GlassCard(
//                       background: Colors.white.withOpacity(.95),
//                       borderColor: Colors.black.withOpacity(.04),
//                       shadowColor: Colors.black.withOpacity(.04),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Rechercher dans le staff…',
//                           prefixIcon: const Icon(Icons.search_rounded),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: gaindeInk.withOpacity(.05),
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: gaindeInk.withOpacity(.05),
//                             ),
//                           ),
//                         ),
//                         onChanged: onQueryChanged,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverPadding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//               sliver: SliverList.separated(
//                 itemCount: filtered.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final s = filtered[index];
//                   return _StaffCard(staff: s);
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _StaffCard extends StatelessWidget {
//   final StaffEntity staff;

//   const _StaffCard({required this.staff});

//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       background: const Color(0xFFE1F4EC),
//       borderColor: gaindeGreen.withOpacity(.15),
//       shadowColor: gaindeInk.withOpacity(.06),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFE1F4EC), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 26,
//               backgroundColor: Colors.white,
//               backgroundImage:
//                   (staff.photoUrl != null && staff.photoUrl!.trim().isNotEmpty)
//                   ? NetworkImage(staff.photoUrl!)
//                   : null,
//               child: (staff.photoUrl == null || staff.photoUrl!.trim().isEmpty)
//                   ? const Icon(
//                       Icons.person_outline,
//                       color: gaindeGreen,
//                       size: 28,
//                     )
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     staff.nomComplet,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w800,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     staff.postOccupe,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       color: gaindeInk.withOpacity(.8),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Wrap(
//                     spacing: 6,
//                     runSpacing: 4,
//                     children: [
//                       _staffPill(
//                         label: staff.nationalite,
//                         icon: Icons.flag_outlined,
//                       ),
//                       if (staff.age != null && staff.age!.trim().isNotEmpty)
//                         _staffPill(
//                           label: '${staff.age} ans',
//                           icon: Icons.cake_outlined,
//                         ),
//                       if (staff.nomme.isNotEmpty)
//                         _staffPill(
//                           label: 'Depuis ${staff.nomme}',
//                           icon: Icons.calendar_month_outlined,
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 if (staff.finDeContrat.isNotEmpty &&
//                     staff.finDeContrat.trim() != '-')
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: gaindeGreenSoft,
//                       borderRadius: BorderRadius.circular(999),
//                       border: Border.all(color: gaindeGreen.withOpacity(.25)),
//                     ),
//                     child: Text(
//                       'Contrat ${staff.finDeContrat}',
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: gaindeGreen,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _staffPill({required String label, IconData? icon}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.9),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: gaindeInk.withOpacity(.12)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null) ...[
//             Icon(icon, size: 13, color: gaindeGreen),
//             const SizedBox(width: 4),
//           ],
//           Text(
//             label,
//             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StaffSkeleton extends StatelessWidget {
//   const _StaffSkeleton();

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//       itemCount: 6,
//       itemBuilder: (_, __) {
//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           height: 80,
//           decoration: BoxDecoration(
//             color: cs.surface,
//             borderRadius: BorderRadius.circular(18),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:fanexp/constants/colors/main_color.dart'
    hide gaindeGreen, gaindeRed, gaindeGold;
import 'package:fanexp/entity/femalePlayer.entity.dart';
import 'package:fanexp/screens/notificationHome.dart';
import 'package:fanexp/screens/settings/settings.dart'
    hide gaindeInk, gaindeGreen, gaindeBg, gaindeGreenSoft, gaindeGold;
import 'package:fanexp/services/player/femalePlayer.service.dart';
import 'package:flutter/material.dart';

import 'package:fanexp/theme/gainde_theme.dart' hide gaindeRed;
import 'package:fanexp/widgets/glasscard.dart';

class FemalePlayerStaff extends StatefulWidget {
  const FemalePlayerStaff({super.key});

  @override
  State<FemalePlayerStaff> createState() => _FemalePlayerStaffState();
}

class _FemalePlayerStaffState extends State<FemalePlayerStaff> {
  final FemalePlayerService femalePlayerService = FemalePlayerService();

  late Future<List<FemalePlayerEntity>> futureFemalePlayers;

  // Filtres joueuses
  String _playerQuery = '';
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
    futureFemalePlayers = femalePlayerService.getFemalePlayers();
  }

  void _reloadFemalePlayers() {
    setState(() {
      futureFemalePlayers = femalePlayerService.getFemalePlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gaindeBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: Image.asset(
                'assets/img/federation.png',
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.sports_soccer_outlined,
                  color: gaindeGreen,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Foot féminin',
              style: TextStyle(fontWeight: FontWeight.w800, color: gaindeInk),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationHome()),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: gaindeInk,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const Settings()));
            },
            icon: const Icon(Icons.settings, color: gaindeInk),
          ),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          const _GaindeBackground(),
          _PlayersTab(
            futureFemalePlayers: futureFemalePlayers,
            positionFilters: _positionFilters,
            positionFilter: _positionFilter,
            onPositionFilterChanged: (val) {
              setState(() => _positionFilter = val);
            },
            query: _playerQuery,
            onQueryChanged: (val) {
              setState(() => _playerQuery = val.trim());
            },
            onReload: _reloadFemalePlayers,
          ),
        ],
      ),
    );
  }
}

class _GaindeBackground extends StatelessWidget {
  const _GaindeBackground();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [gaindeBg, gaindeWhite, gaindeBg],
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.85, -0.95),
          child: Container(
            width: size.width * .65,
            height: size.width * .65,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                stops: [0, .6, 1],
                colors: [
                  Color(0x29007A33),
                  Color(0x14007A33),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ------------------
/// Onglet JOUEUSES (page unique)
/// ------------------

class _PlayersTab extends StatelessWidget {
  final Future<List<FemalePlayerEntity>> futureFemalePlayers;
  final List<String> positionFilters;
  final String positionFilter;
  final ValueChanged<String> onPositionFilterChanged;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onReload;

  const _PlayersTab({
    required this.futureFemalePlayers,
    required this.positionFilters,
    required this.positionFilter,
    required this.onPositionFilterChanged,
    required this.query,
    required this.onQueryChanged,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FemalePlayerEntity>>(
      future: futureFemalePlayers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _PlayersSkeleton();
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GlassCard(
                background: Colors.white.withOpacity(.96),
                borderColor: Colors.black.withOpacity(.06),
                shadowColor: Colors.black.withOpacity(.08),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: gaindeRed),
                    const SizedBox(height: 12),
                    const Text(
                      'Impossible de charger les joueuses',
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gaindeGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onReload,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final players = snapshot.data ?? <FemalePlayerEntity>[];
        if (players.isEmpty) {
          return Center(
            child: GlassCard(
              background: Colors.white.withOpacity(.96),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Aucune joueuse disponible.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }

        final filtered = players.where((p) {
          final okSearch =
              query.isEmpty ||
              p.nom.toLowerCase().contains(query.toLowerCase());
          final cat = p.positionCategory.toUpperCase();
          bool okPos = true;
          if (positionFilter != 'Tous') {
            okPos = cat == positionFilter.toUpperCase();
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
                    GlassCard(
                      background: Colors.white.withOpacity(.95),
                      borderColor: Colors.black.withOpacity(.04),
                      shadowColor: Colors.black.withOpacity(.04),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Rechercher une joueuse…',
                              prefixIcon: const Icon(Icons.search_rounded),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: gaindeInk.withOpacity(.05),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: gaindeInk.withOpacity(.05),
                                ),
                              ),
                            ),
                            onChanged: onQueryChanged,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 36,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: positionFilters.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (_, i) {
                                final f = positionFilters[i];
                                final selected = f == positionFilter;
                                return ChoiceChip(
                                  label: Text(f),
                                  selected: selected,
                                  onSelected: (_) => onPositionFilterChanged(f),
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
                      // TODO : ouvrir un écran de détail plus tard si besoin
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final FemalePlayerEntity player;
  final VoidCallback onTap;

  const _PlayerCard({required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: GlassCard(
        background: const Color(0xFFE1F4EC),
        borderColor: gaindeGreen.withOpacity(.15),
        shadowColor: gaindeInk.withOpacity(.06),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFFE1F4EC), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar = drapeau du pays du club ou initiale
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: player.paysClubPhotoUrl.isNotEmpty
                    ? NetworkImage(player.paysClubPhotoUrl)
                    : null,
                child: player.paysClubPhotoUrl.isEmpty
                    ? Text(
                        player.nom.isNotEmpty ? player.nom[0] : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          color: gaindeGreen,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.nom,
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
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: gaindeGreenSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            player.paysClub,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: gaindeInk,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _pill(label: '#${player.numero} · ${player.position}'),
                        _pill(
                          label: 'Âge ${player.age}',
                          icon: Icons.cake_outlined,
                        ),
                        // if (player.tailleCm != null &&
                        //     player.tailleCm!.trim().isNotEmpty &&
                        //     player.tailleCm != '-')
                        //   _pill(
                        //     label: '${player.tailleCm} cm',
                        //     icon: Icons.height_rounded,
                        //   ),
                        // on affiche la taille seulement si > 0
                        if (player.tailleCm != null && player.tailleCm! > 0)
                          _pill(
                            label: '${player.tailleCm} cm',
                            icon: Icons.height_rounded,
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
