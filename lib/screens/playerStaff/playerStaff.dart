// import 'package:fanexp/entity/player.entity.dart';
// import 'package:fanexp/screens/playerStaff/playerDetail.dart';
// import 'package:fanexp/services/player/player.service.dart';
// import 'package:fanexp/theme/gainde_theme.dart';
// import 'package:flutter/material.dart';

// class PlayerAnalytics extends StatefulWidget {
//   const PlayerAnalytics({super.key});

//   @override
//   State<PlayerAnalytics> createState() => _PlayerAnalyticsState();
// }

// class _PlayerAnalyticsState extends State<PlayerAnalytics> {
//   final PlayerService _playerService = PlayerService();
//   late Future<List<PlayerEntity>> _futurePlayers;

//   String _query = '';
//   String _positionFilter = 'Tous';

//   final List<String> _positionFilters = const [
//     'Tous',
//     'GARDIEN',
//     'DEFENSEUR',
//     'MILIEU',
//     'ATTAQUANT',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _futurePlayers = _playerService.getPlayers();
//   }

//   void _reload() {
//     setState(() {
//       _futurePlayers = _playerService.getPlayers();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Stats joueurs'), centerTitle: false),
//       backgroundColor: cs.background,
//       body: FutureBuilder<List<PlayerEntity>>(
//         future: _futurePlayers,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const _PlayersSkeleton();
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.error_outline, size: 48, color: gaindeRed),
//                     const SizedBox(height: 12),
//                     const Text(
//                       'Impossible de charger les joueurs',
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
//                       onPressed: _reload,
//                       icon: const Icon(Icons.refresh_rounded),
//                       label: const Text('Réessayer'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           final players = snapshot.data ?? <PlayerEntity>[];
//           if (players.isEmpty) {
//             return const Center(
//               child: Text(
//                 'Aucun joueur disponible.',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             );
//           }

//           final filtered = players.where((p) {
//             final okSearch =
//                 _query.trim().isEmpty ||
//                 p.fullName.toLowerCase().contains(_query.trim().toLowerCase());
//             final cat = p.positionCategory.toUpperCase();
//             bool okPos = true;
//             if (_positionFilter != 'Tous') {
//               okPos = cat == _positionFilter.toUpperCase();
//             }
//             return okSearch && okPos;
//           }).toList();

//           return CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Profil IA des Lions',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         'Explore les stats, la forme et les insights IA des joueurs.',
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: gaindeInk.withOpacity(.7),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Rechercher un joueur…',
//                           prefixIcon: const Icon(Icons.search_rounded),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: gaindeInk.withOpacity(.1),
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: gaindeInk.withOpacity(.1),
//                             ),
//                           ),
//                         ),
//                         onChanged: (v) => setState(() => _query = v.trim()),
//                       ),
//                       const SizedBox(height: 12),
//                       SizedBox(
//                         height: 40,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: _positionFilters.length,
//                           separatorBuilder: (_, __) => const SizedBox(width: 8),
//                           itemBuilder: (_, i) {
//                             final f = _positionFilters[i];
//                             final selected = f == _positionFilter;
//                             return ChoiceChip(
//                               label: Text(f),
//                               selected: selected,
//                               onSelected: (_) =>
//                                   setState(() => _positionFilter = f),
//                               selectedColor: gaindeGreenSoft,
//                               side: BorderSide(
//                                 color: selected
//                                     ? gaindeGreen.withOpacity(.4)
//                                     : gaindeInk.withOpacity(.12),
//                               ),
//                               labelStyle: TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 color: selected ? gaindeGreen : gaindeInk,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverPadding(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//                 sliver: SliverList.separated(
//                   itemCount: filtered.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 12),
//                   itemBuilder: (context, index) {
//                     final p = filtered[index];
//                     return _PlayerCard(
//                       player: p,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => PlayerDetail(player: p),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _PlayerCard extends StatelessWidget {
//   final PlayerEntity player;
//   final VoidCallback onTap;

//   const _PlayerCard({required this.player, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(18),
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           gradient: const LinearGradient(
//             colors: [Color(0xFFE1F4EC), Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           border: Border.all(color: gaindeGreen.withOpacity(.15)),
//           boxShadow: [
//             BoxShadow(
//               color: gaindeInk.withOpacity(.06),
//               blurRadius: 10,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Hero(
//               tag: 'player_photo_${player.id}',
//               child: CircleAvatar(
//                 radius: 32,
//                 backgroundColor: Colors.white,
//                 backgroundImage: player.photoUrl.isNotEmpty
//                     ? NetworkImage(player.photoUrl)
//                     : null,
//                 child: player.photoUrl.isEmpty
//                     ? const Icon(Icons.person, color: gaindeGreen, size: 32)
//                     : null,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     player.fullName,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w800,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Row(
//                     children: [
//                       if (player.clubLogoUrl.isNotEmpty)
//                         CircleAvatar(
//                           radius: 10,
//                           backgroundImage: NetworkImage(player.clubLogoUrl),
//                           backgroundColor: Colors.white,
//                         ),
//                       if (player.clubLogoUrl.isNotEmpty)
//                         const SizedBox(width: 6),
//                       Flexible(
//                         child: Text(
//                           player.club,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: gaindeInk.withOpacity(.8),
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       _pill(
//                         label:
//                             '#${player.jerseyNumber} · ${player.primaryPosition}',
//                       ),
//                       const SizedBox(width: 6),
//                       _pill(
//                         label: 'Âge ${player.age}',
//                         icon: Icons.cake_outlined,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: gaindeGreen,
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.bolt_rounded,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         player.formRating.toStringAsFixed(1),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'Note IA',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: gaindeInk.withOpacity(.6),
//                   ),
//                 ),
//               ],
//             ),
//           ],
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

import 'package:fanexp/screens/playerStaff/playerDetail.dart';
import 'package:fanexp/services/player/staff.service.dart';
import 'package:flutter/material.dart';

import 'package:fanexp/entity/player.entity.dart';
import 'package:fanexp/entity/staff.entity.dart';

import 'package:fanexp/services/player/player.service.dart';

import 'package:fanexp/theme/gainde_theme.dart';

class PlayerStaff extends StatefulWidget {
  const PlayerStaff({super.key});

  @override
  State<PlayerStaff> createState() => _PlayerStaffState();
}

class _PlayerStaffState extends State<PlayerStaff>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final PlayerService playerService = PlayerService();
  final StaffService staffService = StaffService();

  late Future<List<PlayerEntity>> futurePlayers;
  late Future<List<StaffEntity>> futureStaff;

  // Filtres joueurs
  String _playerQuery = '';
  String _positionFilter = 'Tous';

  final List<String> _positionFilters = const [
    'Tous',
    'GARDIEN',
    'DEFENSEUR',
    'MILIEU',
    'ATTAQUANT',
  ];

  // Filtre staff
  String _staffQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    futurePlayers = playerService.getPlayers();
    futureStaff = staffService.getStaff();
  }

  void _reloadPlayers() {
    setState(() {
      futurePlayers = playerService.getPlayers();
    });
  }

  void _reloadStaff() {
    setState(() {
      futureStaff = staffService.getStaff();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Effectif & Staff'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: gaindeGreen,
          labelColor: gaindeGreen,
          unselectedLabelColor: gaindeInk.withOpacity(.6),
          tabs: const [
            Tab(icon: Icon(Icons.sports_soccer_rounded), text: 'Joueurs'),
            Tab(icon: Icon(Icons.groups_2_rounded), text: 'Staff'),
          ],
        ),
      ),
      backgroundColor: cs.background,
      body: TabBarView(
        controller: _tabController,
        children: [
          _PlayersTab(
            futurePlayers: futurePlayers,
            positionFilters: _positionFilters,
            positionFilter: _positionFilter,
            onPositionFilterChanged: (val) {
              setState(() => _positionFilter = val);
            },
            query: _playerQuery,
            onQueryChanged: (val) {
              setState(() => _playerQuery = val.trim());
            },
            onReload: _reloadPlayers,
          ),
          _StaffTab(
            futureStaff: futureStaff,
            query: _staffQuery,
            onQueryChanged: (val) {
              setState(() => _staffQuery = val.trim());
            },
            onReload: _reloadStaff,
          ),
        ],
      ),
    );
  }
}

/// ------------------
/// Onglet JOUEURS
/// ------------------

class _PlayersTab extends StatelessWidget {
  final Future<List<PlayerEntity>> futurePlayers;
  final List<String> positionFilters;
  final String positionFilter;
  final ValueChanged<String> onPositionFilterChanged;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onReload;

  const _PlayersTab({
    required this.futurePlayers,
    required this.positionFilters,
    required this.positionFilter,
    required this.onPositionFilterChanged,
    required this.query,
    required this.onQueryChanged,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlayerEntity>>(
      future: futurePlayers,
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
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
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
                    onPressed: onReload,
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
              query.isEmpty ||
              p.fullName.toLowerCase().contains(query.toLowerCase());
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
                      onChanged: onQueryChanged,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: positionFilters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
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

/// ------------------
/// Onglet STAFF
/// ------------------

class _StaffTab extends StatelessWidget {
  final Future<List<StaffEntity>> futureStaff;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onReload;

  const _StaffTab({
    required this.futureStaff,
    required this.query,
    required this.onQueryChanged,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StaffEntity>>(
      future: futureStaff,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _StaffSkeleton();
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
                    'Impossible de charger le staff',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
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
                    onPressed: onReload,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        final staffList = snapshot.data ?? <StaffEntity>[];
        if (staffList.isEmpty) {
          return const Center(
            child: Text(
              'Aucun membre du staff disponible.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        }

        final filtered = staffList.where((s) {
          final lower = query.toLowerCase();
          final okSearch =
              query.isEmpty ||
              s.nomComplet.toLowerCase().contains(lower) ||
              s.postOccupe.toLowerCase().contains(lower);
          return okSearch;
        }).toList();

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Staff & Encadrement',
                    //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    //     fontWeight: FontWeight.w800,
                    //   ),
                    // ),
                    // const SizedBox(height: 6),
                    // Text(
                    //   'Découvrez le staff technique et médical derrière la performance.',
                    //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    //     color: gaindeInk.withOpacity(.7),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher dans le staff…',
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
                      onChanged: onQueryChanged,
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
                  final s = filtered[index];
                  return _StaffCard(staff: s);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffEntity staff;

  const _StaffCard({required this.staff});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E9FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: gaindeGreen.withOpacity(.12)),
        boxShadow: [
          BoxShadow(
            color: gaindeInk.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            backgroundImage:
                (staff.photoUrl != null && staff.photoUrl!.trim().isNotEmpty)
                ? NetworkImage(staff.photoUrl!)
                : null,
            child: (staff.photoUrl == null || staff.photoUrl!.isEmpty)
                ? const Icon(Icons.person_outline, color: gaindeGreen, size: 28)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.nomComplet,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  staff.postOccupe,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: gaindeInk.withOpacity(.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _staffPill(
                      label: staff.nationalite,
                      icon: Icons.flag_outlined,
                    ),
                    if (staff.age != null && staff.age!.trim().isNotEmpty)
                      _staffPill(
                        label: '${staff.age} ans',
                        icon: Icons.cake_outlined,
                      ),
                    if (staff.nomme.isNotEmpty)
                      _staffPill(
                        label: 'Depuis ${staff.nomme}',
                        icon: Icons.calendar_month_outlined,
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
              if (staff.finDeContrat.isNotEmpty &&
                  staff.finDeContrat.trim() != '-')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gaindeGreenSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: gaindeGreen.withOpacity(.25)),
                  ),
                  child: Text(
                    'Contrat ${staff.finDeContrat}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: gaindeGreen,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _staffPill({required String label, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: gaindeInk.withOpacity(.12)),
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

class _StaffSkeleton extends StatelessWidget {
  const _StaffSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
          ),
        );
      },
    );
  }
}
