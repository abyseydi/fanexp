// // // lib/screens/profil/profil_fan.dart
// // import 'package:fanexp/widgets/fanprofileheader.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fanexp/theme/gainde_theme.dart'; // contient gaindeGreen/Gold/Red/Ink/Bg + theme
// // import 'package:fanexp/widgets/glasscard.dart';
// // import 'package:fanexp/widgets/buttons.dart'; // GlowButton / OutlineSoftButton

// // class Fanprofile extends StatefulWidget {
// //   const Fanprofile({super.key});

// //   @override
// //   State<Fanprofile> createState() => _FanprofileState();
// // }

// // class _FanprofileState extends State<Fanprofile> {
// //   bool notifGoals = true;
// //   bool notifBreaking = true;
// //   bool notifFavPlayer = true;
// //   bool darkMode = false;

// //   double fanXp = 0.66; // mock progression “niveau fan”
// //   String region = 'Dakar';
// //   final favPlayers = <String>{'Sadio Mané', 'Ismaïla Sarr'};
// //   final chants = <String>{'Allez les Lions', 'Gaïndé Forever'};

// //   @override
// //   Widget build(BuildContext context) {
// //     final cs = Theme.of(context).colorScheme;
// //     final textTheme = Theme.of(context).textTheme;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Mon profil fan'),
// //         actions: [
// //           IconButton(
// //             onPressed: _onShareFanCard,
// //             icon: const Icon(Icons.ios_share_rounded),
// //             tooltip: 'Partager ma Fan Card',
// //           ),
// //         ],
// //       ),
// //       body: ListView(
// //         padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
// //         children: [
// //           // HEADER — Cover + Avatar + Identité
// //           _HeaderCard(onEdit: _onEditProfile, dark: darkMode),
// //           const SizedBox(height: 12),

// //           // FAN LEVEL + BADGES
// //           GlassCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Niveau de fan', style: _titleStyle()),
// //                 const SizedBox(height: 8),
// //                 _FanLevelProgress(value: fanXp),
// //                 const SizedBox(height: 10),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: const [
// //                     _BadgePill(icon: Icons.emoji_events_rounded, label: 'Capo'),
// //                     _BadgePill(
// //                       icon: Icons.military_tech_rounded,
// //                       label: 'Ultra',
// //                     ),
// //                     _BadgePill(icon: Icons.stars_rounded, label: 'Inside'),
// //                     _BadgePill(icon: Icons.verified_rounded, label: 'Officiel'),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 12),

// //           // PRÉFÉRENCES IA
// //           GlassCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Préférences IA', style: _titleStyle()),
// //                 const SizedBox(height: 8),
// //                 _PrefSwitch(
// //                   label: 'Alerte Buts / Cartons',
// //                   value: notifGoals,
// //                   onChanged: (v) => setState(() => notifGoals = v),
// //                 ),
// //                 _PrefSwitch(
// //                   label: 'Breaking news (sélection, transfert, blessure)',
// //                   value: notifBreaking,
// //                   onChanged: (v) => setState(() => notifBreaking = v),
// //                 ),
// //                 _PrefSwitch(
// //                   label: 'Entrée de mon joueur favori',
// //                   value: notifFavPlayer,
// //                   onChanged: (v) => setState(() => notifFavPlayer = v),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: [
// //                     _ChoiceChip(
// //                       label: 'Sadio Mané',
// //                       selected: favPlayers.contains('Sadio Mané'),
// //                       onSelected: (s) =>
// //                           _toggleSet(favPlayers, 'Sadio Mané', s),
// //                     ),
// //                     _ChoiceChip(
// //                       label: 'Kalidou Koulibaly',
// //                       selected: favPlayers.contains('Kalidou Koulibaly'),
// //                       onSelected: (s) =>
// //                           _toggleSet(favPlayers, 'Kalidou Koulibaly', s),
// //                     ),
// //                     _ChoiceChip(
// //                       label: 'Ismaïla Sarr',
// //                       selected: favPlayers.contains('Ismaïla Sarr'),
// //                       onSelected: (s) =>
// //                           _toggleSet(favPlayers, 'Ismaïla Sarr', s),
// //                     ),
// //                     _ChoiceChip(
// //                       label: 'Gana Gueye',
// //                       selected: favPlayers.contains('Gana Gueye'),
// //                       onSelected: (s) =>
// //                           _toggleSet(favPlayers, 'Gana Gueye', s),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),
// //                 Text(
// //                   'Chants favoris',
// //                   style: textTheme.labelLarge?.copyWith(
// //                     fontWeight: FontWeight.w800,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 6),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: [
// //                     _ChoiceChip(
// //                       label: 'Allez les Lions',
// //                       selected: chants.contains('Allez les Lions'),
// //                       onSelected: (s) =>
// //                           _toggleSet(chants, 'Allez les Lions', s),
// //                     ),
// //                     _ChoiceChip(
// //                       label: 'Gaïndé Forever',
// //                       selected: chants.contains('Gaïndé Forever'),
// //                       onSelected: (s) =>
// //                           _toggleSet(chants, 'Gaïndé Forever', s),
// //                     ),
// //                     _ChoiceChip(
// //                       label: 'Wër ndogou',
// //                       selected: chants.contains('Wër ndogou'),
// //                       onSelected: (s) => _toggleSet(chants, 'Wër ndogou', s),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 12),

// //           // LOCALISATION + ID FAN
// //           GlassCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Ma tanière', style: _titleStyle()),
// //                 const SizedBox(height: 8),
// //                 _RegionSelector(
// //                   value: region,
// //                   onChanged: (v) => setState(() => region = v),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _FanIdTile(id: 'GG-221-0097-DAK', onQr: _onShowQr),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 12),

// //           // COMPTES LIÉS
// //           GlassCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Comptes liés', style: _titleStyle()),
// //                 const SizedBox(height: 8),
// //                 _LinkedRow(
// //                   icon: Icons.g_mobiledata_rounded,
// //                   label: 'Google',
// //                   linked: true,
// //                   onTap: () {},
// //                 ),
// //                 _LinkedRow(
// //                   icon: Icons.apple,
// //                   label: 'Apple',
// //                   linked: false,
// //                   onTap: () {},
// //                 ),
// //                 _LinkedRow(
// //                   icon: Icons.alternate_email_rounded,
// //                   label: 'Email',
// //                   linked: true,
// //                   onTap: () {},
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 12),

// //           // CONFIDENTIALITÉ / APPARENCE
// //           GlassCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Affichage & confidentialité', style: _titleStyle()),
// //                 const SizedBox(height: 8),
// //                 _PrefSwitch(
// //                   label: 'Mode sombre',
// //                   value: darkMode,
// //                   onChanged: (v) => setState(() => darkMode = v),
// //                 ),
// //                 _PrefLine(
// //                   icon: Icons.lock_outline_rounded,
// //                   label: 'Préférences de confidentialité',
// //                   onTap: () => _snack('Ouverture des préférences…'),
// //                 ),
// //                 _PrefLine(
// //                   icon: Icons.delete_outline_rounded,
// //                   label: 'Supprimer mon compte',
// //                   danger: true,
// //                   onTap: () => _snack('Demande de suppression envoyée'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 18),

// //           // CTA
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: OutlineSoftButton(
// //                   label: 'Voir ma Fan Card',
// //                   // icon: Icons.credit_card_rounded,
// //                   onTap: _onShowQr,
// //                 ),
// //               ),
// //               const SizedBox(width: 10),
// //               Expanded(
// //                 child: GlowButton(
// //                   label: 'Enregistrer',
// //                   onTap: () => _snack('Profil sauvegardé ✅'),
// //                   glowColor: Theme.of(context).colorScheme.primary,
// //                   bgColor: gaindeGreen,
// //                   textColor: Colors.white,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   TextStyle _titleStyle() => const TextStyle(
// //     fontWeight: FontWeight.w800,
// //     color: gaindeInk,
// //     fontSize: 16,
// //   );

// //   void _toggleSet(Set<String> set, String v, bool selected) {
// //     setState(() {
// //       if (selected) {
// //         set.add(v);
// //       } else {
// //         set.remove(v);
// //       }
// //     });
// //   }

// //   void _onEditProfile() => _snack('Édition du profil…');
// //   void _onShareFanCard() => _snack('Partage Fan Card…');
// //   void _onShowQr() => _snack('Affichage du QR Fan…');

// //   void _snack(String msg) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// //   }
// // }

// // /// ----- Header (cover + avatar + stats rapides)
// // class _HeaderCard extends StatelessWidget {
// //   final VoidCallback onEdit;
// //   final bool dark;
// //   const _HeaderCard({required this.onEdit, required this.dark});

// //   @override
// //   Widget build(BuildContext context) {
// //     final cs = Theme.of(context).colorScheme;
// //     return GlassCard(
// //       // padding: EdgeInsets.zero,
// //       child: Column(
// //         children: [
// //           // Cover
// //           Container(
// //             height: 96,
// //             decoration: BoxDecoration(
// //               borderRadius: const BorderRadius.vertical(
// //                 top: Radius.circular(16),
// //               ),
// //               gradient: LinearGradient(
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //                 colors: dark
// //                     ? [gaindeInk, gaindeGreen.withOpacity(.7)]
// //                     : [
// //                         gaindeGreen.withOpacity(.85),
// //                         gaindeGold.withOpacity(.85),
// //                       ],
// //               ),
// //             ),
// //           ),
// //           // Padding(
// //           //   padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
// //           //   child: Row(
// //           //     crossAxisAlignment: CrossAxisAlignment.end,
// //           //     children: [
// //           //       Transform.translate(
// //           //         offset: const Offset(0, -36),
// //           //         child: Container(
// //           //           padding: const EdgeInsets.all(3),
// //           //           decoration: BoxDecoration(
// //           //             color: Colors.white,
// //           //             shape: BoxShape.circle,
// //           //             boxShadow: [
// //           //               BoxShadow(
// //           //                 color: Colors.black.withOpacity(.08),
// //           //                 blurRadius: 12,
// //           //               ),
// //           //             ],
// //           //           ),
// //           //           child: const CircleAvatar(
// //           //             radius: 32,
// //           //             backgroundImage: AssetImage('assets/img/avatar.jpg'),
// //           //           ),
// //           //         ),
// //           //       ),
// //           //       const SizedBox(width: 12),
// //           //       Expanded(
// //           //         child: Transform.translate(
// //           //           offset: const Offset(0, -20),
// //           //           child: Column(
// //           //             crossAxisAlignment: CrossAxisAlignment.start,
// //           //             children: [
// //           //               const Text(
// //           //                 'Poulo SEYDI',
// //           //                 style: TextStyle(
// //           //                   fontWeight: FontWeight.w800,
// //           //                   fontSize: 18,
// //           //                 ),
// //           //               ),
// //           //               Opacity(
// //           //                 opacity: .7,
// //           //                 child: Row(
// //           //                   children: const [
// //           //                     Icon(Icons.location_on_outlined, size: 16),
// //           //                     SizedBox(width: 4),
// //           //                     Text('Dakar • SEN'),
// //           //                   ],
// //           //                 ),
// //           //               ),
// //           //               const SizedBox(height: 8),
// //           //               Row(
// //           //                 children: const [
// //           //                   _MiniStat(label: 'Badges', value: '12'),
// //           //                   SizedBox(width: 12),
// //           //                   _MiniStat(label: 'Points', value: '1 480'),
// //           //                   SizedBox(width: 12),
// //           //                   _MiniStat(label: 'Rang', value: '#27'),
// //           //                 ],
// //           //               ),
// //           //             ],
// //           //           ),
// //           //         ),
// //           //       ),
// //           //       const SizedBox(width: 8),
// //           //       FilledButton.icon(
// //           //         onPressed: onEdit,
// //           //         icon: const Icon(Icons.edit_rounded, size: 18),
// //           //         label: const Text('Modifier'),
// //           //       ),
// //           //     ],
// //           //   ),
// //           // ),
// //           ProfileHeader(onEdit: onEdit),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _MiniStat extends StatelessWidget {
// //   final String label;
// //   final String value;
// //   const _MiniStat({required this.label, required this.value});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Opacity(
// //           opacity: .7,
// //           child: Text(label, style: const TextStyle(fontSize: 12)),
// //         ),
// //         Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
// //       ],
// //     );
// //   }
// // }

// // /// ----- Fan level progress
// // class _FanLevelProgress extends StatelessWidget {
// //   final double value;
// //   const _FanLevelProgress({required this.value});

// //   @override
// //   Widget build(BuildContext context) {
// //     final v = value.clamp(0.0, 1.0);
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Stack(
// //           children: [
// //             Container(
// //               height: 10,
// //               decoration: BoxDecoration(
// //                 color: Colors.black12,
// //                 borderRadius: BorderRadius.circular(999),
// //               ),
// //             ),
// //             FractionallySizedBox(
// //               widthFactor: v,
// //               child: Container(
// //                 height: 10,
// //                 decoration: BoxDecoration(
// //                   color: gaindeGreen,
// //                   borderRadius: BorderRadius.circular(999),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         const SizedBox(height: 6),
// //         Row(
// //           children: [
// //             const Text('Niveau Capo'),
// //             const Spacer(),
// //             Text('${(v * 100).round()} %'),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }

// // /// ----- Badge
// // class _BadgePill extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   const _BadgePill({required this.icon, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Chip(
// //       avatar: Icon(icon, size: 16, color: gaindeGreen),
// //       label: Text(label),
// //       backgroundColor: gaindeGreenSoft,
// //       side: BorderSide(color: gaindeInk.withOpacity(.12)),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //     );
// //   }
// // }

// // /// ----- Préférence (switch ligne)
// // class _PrefSwitch extends StatelessWidget {
// //   final String label;
// //   final bool value;
// //   final ValueChanged<bool> onChanged;
// //   const _PrefSwitch({
// //     required this.label,
// //     required this.value,
// //     required this.onChanged,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListTile(
// //       contentPadding: EdgeInsets.zero,
// //       title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
// //       trailing: Switch(value: value, onChanged: onChanged),
// //     );
// //   }
// // }

// // /// ----- Ligne simple avec icône
// // class _PrefLine extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   final bool danger;
// //   final VoidCallback onTap;
// //   const _PrefLine({
// //     required this.icon,
// //     required this.label,
// //     required this.onTap,
// //     this.danger = false,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final color = danger ? gaindeRed : gaindeInk;
// //     return ListTile(
// //       contentPadding: EdgeInsets.zero,
// //       leading: Icon(icon, color: color),
// //       title: Text(
// //         label,
// //         style: TextStyle(fontWeight: FontWeight.w600, color: color),
// //       ),
// //       trailing: const Icon(Icons.chevron_right_rounded),
// //       onTap: onTap,
// //     );
// //   }
// // }

// // /// ----- ChoiceChip stylé
// // class _ChoiceChip extends StatelessWidget {
// //   final String label;
// //   final bool selected;
// //   final ValueChanged<bool> onSelected;
// //   const _ChoiceChip({
// //     required this.label,
// //     required this.selected,
// //     required this.onSelected,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final cs = Theme.of(context).colorScheme;
// //     return FilterChip(
// //       label: Text(label),
// //       selected: selected,
// //       onSelected: onSelected,
// //       showCheckmark: false,
// //       selectedColor: gaindeGreenSoft,
// //       side: BorderSide(color: cs.primary.withOpacity(.2)),
// //     );
// //   }
// // }

// // /// ----- Sélecteur de région (mock)
// // class _RegionSelector extends StatelessWidget {
// //   final String value;
// //   final ValueChanged<String> onChanged;
// //   const _RegionSelector({required this.value, required this.onChanged});

// //   @override
// //   Widget build(BuildContext context) {
// //     final regions = const [
// //       'Dakar',
// //       'Thiès',
// //       'Saint-Louis',
// //       'Kaolack',
// //       'Ziguinchor',
// //     ];
// //     return InputDecorator(
// //       decoration: InputDecoration(
// //         labelText: 'Région',
// //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<String>(
// //           value: value,
// //           isExpanded: true,
// //           items: regions
// //               .map((r) => DropdownMenuItem(value: r, child: Text(r)))
// //               .toList(),
// //           onChanged: (v) => v == null ? null : onChanged(v),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // /// ----- Fan ID + QR
// // class _FanIdTile extends StatelessWidget {
// //   final String id;
// //   final VoidCallback onQr;
// //   const _FanIdTile({required this.id, required this.onQr});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListTile(
// //       contentPadding: EdgeInsets.zero,
// //       leading: const Icon(Icons.qr_code_2_rounded, size: 32),
// //       title: const Text('Fan ID'),
// //       subtitle: Text(id, style: const TextStyle(fontWeight: FontWeight.w700)),
// //       trailing: FilledButton(onPressed: onQr, child: const Text('Voir QR')),
// //     );
// //   }
// // }

// // class _LinkedRow extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   final bool linked;
// //   final VoidCallback onTap;

// //   const _LinkedRow({
// //     required this.icon,
// //     required this.label,
// //     required this.linked,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final cs = Theme.of(context).colorScheme;

// //     return ListTile(
// //       contentPadding: EdgeInsets.zero,
// //       leading: Container(
// //         width: 40,
// //         height: 40,
// //         decoration: BoxDecoration(
// //           color: cs.primary.withOpacity(.10),
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Icon(icon, color: cs.primary),
// //       ),
// //       title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
// //       subtitle: Text(
// //         linked ? 'Connecté' : 'Non lié',
// //         style: TextStyle(
// //           color: linked ? Colors.green[700] : Colors.black54,
// //           fontWeight: FontWeight.w600,
// //         ),
// //       ),
// //       trailing: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           if (linked)
// //             const Icon(Icons.verified_rounded, color: Colors.green)
// //           else
// //             Icon(Icons.link_rounded, color: cs.primary),
// //           const SizedBox(width: 6),
// //           const Icon(Icons.chevron_right_rounded),
// //         ],
// //       ),
// //       onTap: onTap,
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:fanexp/theme/gainde_theme.dart'; // couleurs + theme
// import 'package:fanexp/widgets/glasscard.dart';
// import 'package:fanexp/widgets/buttons.dart'; // GlowButton / OutlineSoftButton
// import 'package:fanexp/widgets/fanprofileheader.dart'; // ton header compact si dispo

// class Fanprofile extends StatefulWidget {
//   const Fanprofile({super.key});

//   @override
//   State<Fanprofile> createState() => _FanprofileState();
// }

// class _FanprofileState extends State<Fanprofile> {
//   // ===== États (mock) =====
//   bool notifGoals = true;
//   bool notifBreaking = true;
//   bool notifFavPlayer = true;
//   bool darkMode = false;

//   double fanXp = 0.66; // progression niveau fan
//   String region = 'Dakar';
//   final favPlayers = <String>{'Sadio Mané', 'Ismaïla Sarr'};
//   final chants = <String>{'Allez les Lions', 'Gaïndé Forever'};

//   // Quick prefs (venant de "Profil")
//   bool pAlertesButs = true;
//   bool pCartonsVar = true;
//   bool pBreaking = false;

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mon profil fan'),
//         actions: [
//           IconButton(
//             onPressed: _onShareFanCard,
//             icon: const Icon(Icons.ios_share_rounded),
//             tooltip: 'Partager ma Fan Card',
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//         children: [
//           // ===== 1) HEADER =====
//           _HeaderCard(onEdit: _onEditProfile, dark: darkMode),
//           const SizedBox(height: 12),

//           // ===== 2) FAN STATS (fusionne avec _FanStats de "Profil") =====
//           _FanStatsRow(presence: '12', quiz: '34', defis: '9'),
//           const SizedBox(height: 12),

//           // ===== 3) QUICK PREFS (section Préférences IA de "Profil") =====
//           GlassCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Préférences IA (rapide)',
//                   style: const TextStyle(fontWeight: FontWeight.w800),
//                 ),

//                 const SizedBox(height: 8),
//                 SwitchListTile(
//                   contentPadding: EdgeInsets.zero,
//                   value: pAlertesButs,
//                   onChanged: (v) => setState(() => pAlertesButs = v),
//                   title: const Text('Alertes buts'),
//                 ),
//                 SwitchListTile(
//                   contentPadding: EdgeInsets.zero,
//                   value: pCartonsVar,
//                   onChanged: (v) => setState(() => pCartonsVar = v),
//                   title: const Text('Cartons & VAR'),
//                 ),
//                 SwitchListTile(
//                   contentPadding: EdgeInsets.zero,
//                   value: pBreaking,
//                   onChanged: (v) => setState(() => pBreaking = v),
//                   title: const Text('Breaking / mercato'),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ===== 4) FAN LEVEL + BADGES =====
//           GlassCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Niveau de fan',
//                   style: const TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 _FanLevelProgress(value: fanXp),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: const [
//                     _BadgePill(icon: Icons.emoji_events_rounded, label: 'Capo'),
//                     _BadgePill(
//                       icon: Icons.military_tech_rounded,
//                       label: 'Ultra',
//                     ),
//                     _BadgePill(icon: Icons.stars_rounded, label: 'Inside'),
//                     _BadgePill(icon: Icons.verified_rounded, label: 'Officiel'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ===== 5) PRÉFÉRENCES IA (détaillées) =====
//           GlassCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Préférences IA (détaillées)',
//                   style: const TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 _PrefSwitch(
//                   label: 'Alerte Buts / Cartons',
//                   value: notifGoals,
//                   onChanged: (v) => setState(() => notifGoals = v),
//                 ),
//                 _PrefSwitch(
//                   label: 'Breaking news (sélection, transfert, blessure)',
//                   value: notifBreaking,
//                   onChanged: (v) => setState(() => notifBreaking = v),
//                 ),
//                 _PrefSwitch(
//                   label: 'Entrée de mon joueur favori',
//                   value: notifFavPlayer,
//                   onChanged: (v) => setState(() => notifFavPlayer = v),
//                 ),
//                 const SizedBox(height: 8),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _ChoiceChip(
//                       label: 'Sadio Mané',
//                       selected: favPlayers.contains('Sadio Mané'),
//                       onSelected: (s) =>
//                           _toggleSet(favPlayers, 'Sadio Mané', s),
//                     ),
//                     _ChoiceChip(
//                       label: 'Kalidou Koulibaly',
//                       selected: favPlayers.contains('Kalidou Koulibaly'),
//                       onSelected: (s) =>
//                           _toggleSet(favPlayers, 'Kalidou Koulibaly', s),
//                     ),
//                     _ChoiceChip(
//                       label: 'Ismaïla Sarr',
//                       selected: favPlayers.contains('Ismaïla Sarr'),
//                       onSelected: (s) =>
//                           _toggleSet(favPlayers, 'Ismaïla Sarr', s),
//                     ),
//                     _ChoiceChip(
//                       label: 'Gana Gueye',
//                       selected: favPlayers.contains('Gana Gueye'),
//                       onSelected: (s) =>
//                           _toggleSet(favPlayers, 'Gana Gueye', s),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Chants favoris',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 6),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _ChoiceChip(
//                       label: 'Allez les Lions',
//                       selected: chants.contains('Allez les Lions'),
//                       onSelected: (s) =>
//                           _toggleSet(chants, 'Allez les Lions', s),
//                     ),
//                     _ChoiceChip(
//                       label: 'Gaïndé Forever',
//                       selected: chants.contains('Gaïndé Forever'),
//                       onSelected: (s) =>
//                           _toggleSet(chants, 'Gaïndé Forever', s),
//                     ),
//                     _ChoiceChip(
//                       label: 'Wër ndogou',
//                       selected: chants.contains('Wër ndogou'),
//                       onSelected: (s) => _toggleSet(chants, 'Wër ndogou', s),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ===== 6) LOCALISATION + ID FAN =====
//           GlassCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Ma tanière',
//                   style: const TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 _RegionSelector(
//                   value: region,
//                   onChanged: (v) => setState(() => region = v),
//                 ),
//                 const SizedBox(height: 12),
//                 _FanIdTile(id: 'GG-221-0097-DAK', onQr: _onShowQr),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ===== 7) COMPTES LIÉS =====
//           GlassCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 _SectionHeaderRow(title: 'Comptes liés'),
//                 _LinkedRow(
//                   icon: Icons.g_mobiledata_rounded,
//                   label: 'Google',
//                   linked: true,
//                   onTap: null,
//                 ),
//                 _LinkedRow(
//                   icon: Icons.apple,
//                   label: 'Apple',
//                   linked: false,
//                   onTap: null,
//                 ),
//                 _LinkedRow(
//                   icon: Icons.alternate_email_rounded,
//                   label: 'Email',
//                   linked: true,
//                   onTap: null,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ===== 8) AFFICHAGE & CONFIDENTIALITÉ =====
//           GlassCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Affichage & confidentialité',
//                   style: const TextStyle(fontWeight: FontWeight.w800),
//                 ),
//                 const SizedBox(height: 8),
//                 _PrefSwitch(
//                   label: 'Mode sombre',
//                   value: darkMode,
//                   onChanged: (v) => setState(() => darkMode = v),
//                 ),
//                 _PrefLine(
//                   icon: Icons.lock_outline_rounded,
//                   label: 'Préférences de confidentialité',
//                   onTap: () => _snack('Ouverture des préférences…'),
//                 ),
//                 _PrefLine(
//                   icon: Icons.delete_outline_rounded,
//                   label: 'Supprimer mon compte',
//                   danger: true,
//                   onTap: () => _snack('Demande de suppression envoyée'),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 18),

//           // ===== CTA =====
//           Row(
//             children: [
//               Expanded(
//                 child: OutlineSoftButton(
//                   label: 'Voir ma Fan Card',
//                   onTap: _onShowQr,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: GlowButton(
//                   label: 'Enregistrer',
//                   onTap: () => _snack('Profil sauvegardé ✅'),
//                   glowColor: cs.primary,
//                   bgColor: gaindeGreen,
//                   textColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ===== Helpers =====
//   TextStyle _sectionTitle(String t) => const TextStyle(
//     fontWeight: FontWeight.w800,
//     color: gaindeInk,
//     fontSize: 16,
//   );

//   void _toggleSet(Set<String> set, String v, bool selected) {
//     setState(() {
//       if (selected) {
//         set.add(v);
//       } else {
//         set.remove(v);
//       }
//     });
//   }

//   void _onEditProfile() => _snack('Édition du profil…');
//   void _onShareFanCard() => _snack('Partage Fan Card…');
//   void _onShowQr() => _snack('Affichage du QR Fan…');

//   void _snack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }
// }

// // ===================== Widgets locaux =====================

// class _SectionHeaderRow extends StatelessWidget {
//   final String title;
//   const _SectionHeaderRow({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
//       child: Row(
//         children: [
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
//         ],
//       ),
//     );
//   }
// }

// /// Header fusionné : cover + avatar + identités + stats rapides (overflow-safe)
// class _HeaderCard extends StatelessWidget {
//   final VoidCallback onEdit;
//   final bool dark;
//   const _HeaderCard({required this.onEdit, required this.dark});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return GlassCard(
//       child: Column(
//         children: [
//           // Cover
//           Container(
//             height: 96,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(16),
//               ),
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: dark
//                     ? [gaindeInk, gaindeGreen.withOpacity(.7)]
//                     : [
//                         gaindeGreen.withOpacity(.85),
//                         gaindeGold.withOpacity(.85),
//                       ],
//               ),
//             ),
//           ),
//           // Contenu header
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // Avatar avec fallback propre (évite crash asset manquant)
//                 Transform.translate(
//                   offset: const Offset(0, -36),
//                   child: Container(
//                     padding: const EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(.08),
//                           blurRadius: 12,
//                         ),
//                       ],
//                     ),
//                     child: ClipOval(
//                       child: Image.asset(
//                         'assets/img/avatar.jpg',
//                         width: 64,
//                         height: 64,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           color: gaindeGreenSoft,
//                           width: 64,
//                           height: 64,
//                           child: const Icon(Icons.person, color: gaindeGreen),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Infos + mini stats (prend la place restante)
//                 Expanded(
//                   child: Transform.translate(
//                     offset: const Offset(0, -20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           'Aby • Légende',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 18,
//                           ),
//                         ),
//                         SizedBox(height: 2),
//                         Opacity(
//                           opacity: .7,
//                           child: Text(
//                             'Points: 1240 • Dakar, SEN',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         _MiniStatsInline(
//                           badges: '12',
//                           points: '1 480',
//                           rang: '#27',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 // Bouton "Modifier" compact (évite overflow)
//                 Transform.translate(
//                   offset: const Offset(0, -22),
//                   child: LayoutBuilder(
//                     builder: (ctx, c) {
//                       // si trop étroit, n'afficher qu'une icône
//                       if (c.maxWidth < 140) {
//                         return IconButton(
//                           onPressed: onEdit,
//                           icon: const Icon(Icons.edit_rounded),
//                           tooltip: 'Modifier',
//                         );
//                       }
//                       return FilledButton.icon(
//                         onPressed: onEdit,
//                         icon: const Icon(Icons.edit_rounded, size: 18),
//                         label: const Text('Modifier'),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Si tu souhaites utiliser ton widget header externe :
//           // ProfileHeader(onEdit: onEdit),
//         ],
//       ),
//     );
//   }
// }

// class _MiniStatsInline extends StatelessWidget {
//   final String badges, points, rang;
//   const _MiniStatsInline({
//     required this.badges,
//     required this.points,
//     required this.rang,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         _MiniStat(label: 'Badges', value: badges),
//         const SizedBox(width: 12),
//         _MiniStat(label: 'Points', value: points),
//         const SizedBox(width: 12),
//         _MiniStat(label: 'Rang', value: rang),
//       ],
//     );
//   }
// }

// class _MiniStat extends StatelessWidget {
//   final String label;
//   final String value;
//   const _MiniStat({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Opacity(
//           opacity: .7,
//           child: Text(label, style: const TextStyle(fontSize: 12)),
//         ),
//         Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
//       ],
//     );
//   }
// }

// // ===== Fan stats (carte 3 colonnes)
// class _FanStatsRow extends StatelessWidget {
//   final String presence;
//   final String quiz;
//   final String defis;
//   const _FanStatsRow({
//     required this.presence,
//     required this.quiz,
//     required this.defis,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       child: Row(
//         children: [
//           _Stat(label: 'Présences', value: presence),
//           const SizedBox(width: 10),
//           _Stat(label: 'Quiz', value: quiz),
//           const SizedBox(width: 10),
//           _Stat(label: 'Défis', value: defis),
//         ],
//       ),
//     );
//   }
// }

// class _Stat extends StatelessWidget {
//   final String label, value;
//   const _Stat({required this.label, required this.value});
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: gaindeGoldSoft,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
//             ),
//             const SizedBox(height: 4),
//             Text(label),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ===== Fan level progress
// class _FanLevelProgress extends StatelessWidget {
//   final double value;
//   const _FanLevelProgress({required this.value});

//   @override
//   Widget build(BuildContext context) {
//     final v = value.clamp(0.0, 1.0);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Stack(
//           children: [
//             Container(
//               height: 10,
//               decoration: BoxDecoration(
//                 color: Colors.black12,
//                 borderRadius: BorderRadius.circular(999),
//               ),
//             ),
//             FractionallySizedBox(
//               widthFactor: v,
//               child: Container(
//                 height: 10,
//                 decoration: BoxDecoration(
//                   color: gaindeGreen,
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             const Text('Niveau Capo'),
//             const Spacer(),
//             Text('${(v * 100).round()} %'),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // ===== Badges
// class _BadgePill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _BadgePill({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       avatar: Icon(icon, size: 16, color: gaindeGreen),
//       label: Text(label),
//       backgroundColor: gaindeGreenSoft,
//       side: BorderSide(color: gaindeInk.withOpacity(.12)),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     );
//   }
// }

// // ===== Switch ligne
// class _PrefSwitch extends StatelessWidget {
//   final String label;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   const _PrefSwitch({
//     required this.label,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//       trailing: Switch(value: value, onChanged: onChanged),
//       onTap: () => onChanged(!value),
//     );
//   }
// }

// // ===== Ligne simple avec icône
// class _PrefLine extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool danger;
//   final VoidCallback onTap;
//   const _PrefLine({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.danger = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = danger ? gaindeRed : gaindeInk;
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Icon(icon, color: color),
//       title: Text(
//         label,
//         style: TextStyle(fontWeight: FontWeight.w600, color: color),
//       ),
//       trailing: const Icon(Icons.chevron_right_rounded),
//       onTap: onTap,
//     );
//   }
// }

// // ===== ChoiceChip stylée
// class _ChoiceChip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final ValueChanged<bool> onSelected;
//   const _ChoiceChip({
//     required this.label,
//     required this.selected,
//     required this.onSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return FilterChip(
//       label: Text(label),
//       selected: selected,
//       onSelected: onSelected,
//       showCheckmark: false,
//       selectedColor: gaindeGreenSoft,
//       side: BorderSide(color: cs.primary.withOpacity(.2)),
//     );
//   }
// }

// // ===== Sélecteur de région
// class _RegionSelector extends StatelessWidget {
//   final String value;
//   final ValueChanged<String> onChanged;
//   const _RegionSelector({required this.value, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     final regions = const [
//       'Dakar',
//       'Thiès',
//       'Saint-Louis',
//       'Kaolack',
//       'Ziguinchor',
//     ];
//     return InputDecorator(
//       decoration: InputDecoration(
//         labelText: 'Région',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isExpanded: true,
//           items: regions
//               .map((r) => DropdownMenuItem(value: r, child: Text(r)))
//               .toList(),
//           onChanged: (v) => v == null ? null : onChanged(v),
//         ),
//       ),
//     );
//   }
// }

// // ===== Fan ID + QR
// class _FanIdTile extends StatelessWidget {
//   final String id;
//   final VoidCallback onQr;
//   const _FanIdTile({required this.id, required this.onQr});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: const Icon(Icons.qr_code_2_rounded, size: 32),
//       title: const Text('Fan ID'),
//       subtitle: Text(id, style: const TextStyle(fontWeight: FontWeight.w700)),
//       trailing: FilledButton(onPressed: onQr, child: const Text('Voir QR')),
//       onTap: onQr,
//     );
//   }
// }

// // ===== Comptes liés
// class _LinkedRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool linked;
//   final VoidCallback? onTap;

//   const _LinkedRow({
//     required this.icon,
//     required this.label,
//     required this.linked,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14),
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: cs.primary.withOpacity(.10),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Icon(icon, color: cs.primary),
//       ),
//       title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//       subtitle: Text(
//         linked ? 'Connecté' : 'Non lié',
//         style: TextStyle(
//           color: linked ? Colors.green[700] : Colors.black54,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (linked)
//             const Icon(Icons.verified_rounded, color: Colors.green)
//           else
//             Icon(Icons.link_rounded, color: cs.primary),
//           const SizedBox(width: 6),
//           const Icon(Icons.chevron_right_rounded),
//         ],
//       ),
//       onTap: onTap,
//     );
//   }
// }

// // ===== Petite aide
// Text _sectionTitle(String t) =>
//     Text(t, style: const TextStyle(fontWeight: FontWeight.w800));

// lib/screens/profil/fanprofile.dart
import 'package:flutter/material.dart';

/// --- Palette minimale (tu peux remplacer par ton gainde_theme.dart)
const gaindeGreen = Color(0xFF007A33);
const gaindeGold = Color(0xFFFFD100);
const gaindeRed = Color(0xFFE31E24);
const gaindeInk = Color(0xFF0F1D13);
const gaindeBg = Color(0xFFF6F8FB);
const gaindeGreenSoft = Color(0xFFE5F3EC);

/// --- Carte “verre” légère
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const GlassCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// --- Bouton glow simple
class GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color glowColor;
  final Color bgColor;
  final Color textColor;
  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.glowColor,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(.35),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// --- Bouton contour soft
class OutlineSoftButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const OutlineSoftButton({
    super.key,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: gaindeInk,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        side: BorderSide(color: Colors.black.withOpacity(.12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

/// --- Avatar robuste (fallback si l’asset est manquant)
class SafeAvatar extends StatelessWidget {
  final String assetPath;
  final double size;
  const SafeAvatar(this.assetPath, {super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 12),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Icon(Icons.person, size: 28, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}

/// --- Page Profil Fan
class Fanprofile extends StatefulWidget {
  const Fanprofile({super.key});
  @override
  State<Fanprofile> createState() => _FanprofileState();
}

class _FanprofileState extends State<Fanprofile> {
  bool notifGoals = true;
  bool notifBreaking = true;
  bool notifFavPlayer = true;
  bool darkMode = false;

  double fanXp = 0.66;
  String region = 'Dakar';
  final favPlayers = <String>{'Sadio Mané', 'Ismaïla Sarr'};
  final chants = <String>{'Allez les Lions', 'Gaïndé Forever'};

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: gaindeBg,
      appBar: AppBar(
        title: const Text('Mon profil fan'),
        foregroundColor: gaindeInk,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _onShareFanCard,
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Partager ma Fan Card',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _HeaderCard(onEdit: _onEditProfile, dark: darkMode),
          const SizedBox(height: 12),

          // NIVEAU + BADGES
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Niveau de fan', style: _titleStyle()),
                const SizedBox(height: 8),
                _FanLevelProgress(value: fanXp),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _BadgePill(icon: Icons.emoji_events_rounded, label: 'Capo'),
                    _BadgePill(
                      icon: Icons.military_tech_rounded,
                      label: 'Ultra',
                    ),
                    _BadgePill(icon: Icons.stars_rounded, label: 'Inside'),
                    _BadgePill(icon: Icons.verified_rounded, label: 'Officiel'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // PREFS IA
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Préférences IA', style: _titleStyle()),
                const SizedBox(height: 8),
                _PrefSwitch(
                  label: 'Alerte Buts / Cartons',
                  value: notifGoals,
                  onChanged: (v) => setState(() => notifGoals = v),
                ),
                _PrefSwitch(
                  label: 'Breaking news (sélection, transfert, blessure)',
                  value: notifBreaking,
                  onChanged: (v) => setState(() => notifBreaking = v),
                ),
                _PrefSwitch(
                  label: 'Entrée de mon joueur favori',
                  value: notifFavPlayer,
                  onChanged: (v) => setState(() => notifFavPlayer = v),
                ),
                const SizedBox(height: 8),

                // joueurs favoris
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ChoiceChip(
                      label: 'Sadio Mané',
                      selected: favPlayers.contains('Sadio Mané'),
                      onSelected: (s) =>
                          _toggleSet(favPlayers, 'Sadio Mané', s),
                    ),
                    _ChoiceChip(
                      label: 'Kalidou Koulibaly',
                      selected: favPlayers.contains('Kalidou Koulibaly'),
                      onSelected: (s) =>
                          _toggleSet(favPlayers, 'Kalidou Koulibaly', s),
                    ),
                    _ChoiceChip(
                      label: 'Ismaïla Sarr',
                      selected: favPlayers.contains('Ismaïla Sarr'),
                      onSelected: (s) =>
                          _toggleSet(favPlayers, 'Ismaïla Sarr', s),
                    ),
                    _ChoiceChip(
                      label: 'Gana Gueye',
                      selected: favPlayers.contains('Gana Gueye'),
                      onSelected: (s) =>
                          _toggleSet(favPlayers, 'Gana Gueye', s),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  'Chants favoris',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ChoiceChip(
                      label: 'Allez les Lions',
                      selected: chants.contains('Allez les Lions'),
                      onSelected: (s) =>
                          _toggleSet(chants, 'Allez les Lions', s),
                    ),
                    _ChoiceChip(
                      label: 'Gaïndé Forever',
                      selected: chants.contains('Gaïndé Forever'),
                      onSelected: (s) =>
                          _toggleSet(chants, 'Gaïndé Forever', s),
                    ),
                    _ChoiceChip(
                      label: 'Wër ndogou',
                      selected: chants.contains('Wër ndogou'),
                      onSelected: (s) => _toggleSet(chants, 'Wër ndogou', s),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // LOCALISATION + ID
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ma tanière', style: _titleStyle()),
                const SizedBox(height: 8),
                _RegionSelector(
                  value: region,
                  onChanged: (v) => setState(() => region = v),
                ),
                const SizedBox(height: 12),
                _FanIdTile(id: 'GG-221-0097-DAK', onQr: _onShowQr),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // COMPTES LIÉS
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Comptes liés',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: gaindeInk,
                  ),
                ),
                SizedBox(height: 8),
                _LinkedRow(
                  icon: Icons.g_mobiledata_rounded,
                  label: 'Google',
                  linked: true,
                  onTap: null,
                ),
                _LinkedRow(
                  icon: Icons.apple,
                  label: 'Apple',
                  linked: false,
                  onTap: null,
                ),
                _LinkedRow(
                  icon: Icons.alternate_email_rounded,
                  label: 'Email',
                  linked: true,
                  onTap: null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // AFFICHAGE / CONFIDENTIALITÉ
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Affichage & confidentialité', style: _titleStyle()),
                const SizedBox(height: 8),
                _PrefSwitch(
                  label: 'Mode sombre',
                  value: darkMode,
                  onChanged: (v) => setState(() => darkMode = v),
                ),
                _PrefLine(
                  icon: Icons.lock_outline_rounded,
                  label: 'Préférences de confidentialité',
                  onTap: () => _snack('Ouverture des préférences…'),
                ),
                _PrefLine(
                  icon: Icons.delete_outline_rounded,
                  label: 'Supprimer mon compte',
                  danger: true,
                  onTap: () => _snack('Demande de suppression envoyée'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // CTA
          Row(
            children: [
              Expanded(
                child: OutlineSoftButton(
                  label: 'Voir ma Fan Card',
                  onTap: _onShowQr,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlowButton(
                  label: 'Enregistrer',
                  onTap: () => _snack('Profil sauvegardé ✅'),
                  glowColor: cs.primary,
                  bgColor: gaindeGreen,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _titleStyle() => const TextStyle(
    fontWeight: FontWeight.w800,
    color: gaindeInk,
    fontSize: 16,
  );

  void _toggleSet(Set<String> set, String v, bool selected) {
    setState(() {
      if (selected)
        set.add(v);
      else
        set.remove(v);
    });
  }

  void _onEditProfile() => _snack('Édition du profil…');
  void _onShareFanCard() => _snack('Partage Fan Card…');
  void _onShowQr() => _snack('Affichage du QR Fan…');

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

/// ----- Header (cover + avatar + infos + stats rapides)
class _HeaderCard extends StatelessWidget {
  final VoidCallback onEdit;
  final bool dark;
  const _HeaderCard({required this.onEdit, required this.dark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Cover
          Container(
            height: 96,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? [gaindeInk, gaindeGreen.withOpacity(.7)]
                    : [
                        gaindeGreen.withOpacity(.85),
                        gaindeGold.withOpacity(.85),
                      ],
              ),
            ),
          ),
          // Bandeau identités
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: const Offset(0, -36),
                  child: const SafeAvatar('assets/img/you.png', size: 64),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Poulo • Ultra',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 2),
                        Opacity(
                          opacity: .7,
                          child: Text(
                            'Points: 1240 • Dakar, SEN',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        _MiniStatsInline(
                          badges: '12',
                          points: '1 480',
                          rang: '#27',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 96),
                  child: FilledButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Modifier'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatsInline extends StatelessWidget {
  final String badges, points, rang;
  const _MiniStatsInline({
    required this.badges,
    required this.points,
    required this.rang,
  });
  @override
  Widget build(BuildContext context) {
    Widget cell(String l, String v) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: .7,
          child: Text(l, style: const TextStyle(fontSize: 12)),
        ),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
    return Row(
      children: [
        cell('Badges', badges),
        const SizedBox(width: 12),
        cell('Points', points),
        const SizedBox(width: 12),
        cell('Rang', rang),
      ],
    );
  }
}

/// ----- Fan level progress
class _FanLevelProgress extends StatelessWidget {
  final double value;
  const _FanLevelProgress({required this.value});

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            FractionallySizedBox(
              widthFactor: v,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: gaindeGreen,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('Niveau Capo'),
            const Spacer(),
            Text('${(v * 100).round()} %'),
          ],
        ),
      ],
    );
  }
}

/// ----- Badge
class _BadgePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BadgePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: gaindeGreen),
      label: Text(label),
      backgroundColor: gaindeGreenSoft,
      side: BorderSide(color: gaindeInk.withOpacity(.12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

/// ----- Switch ligne
class _PrefSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _PrefSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

/// ----- Ligne simple
class _PrefLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;
  final VoidCallback onTap;
  const _PrefLine({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? gaindeRed : gaindeInk;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

/// ----- ChoiceChip stylé
class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      selectedColor: gaindeGreenSoft,
      side: BorderSide(color: cs.primary.withOpacity(.2)),
    );
  }
}

/// ----- Sélecteur de région (mock)
class _RegionSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _RegionSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const regions = ['Dakar', 'Thiès', 'Saint-Louis', 'Kaolack', 'Ziguinchor'];
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Région',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: regions
              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
              .toList(),
          onChanged: (v) => v == null ? null : onChanged(v),
        ),
      ),
    );
  }
}

/// ----- Fan ID + QR
class _FanIdTile extends StatelessWidget {
  final String id;
  final VoidCallback onQr;
  const _FanIdTile({required this.id, required this.onQr});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.qr_code_2_rounded, size: 32),
      title: const Text('Fan ID'),
      subtitle: Text(id, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: FilledButton(onPressed: onQr, child: const Text('Voir QR')),
    );
  }
}

/// ----- Ligne “Compte lié”
class _LinkedRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool linked;
  final VoidCallback? onTap;

  const _LinkedRow({
    required this.icon,
    required this.label,
    required this.linked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: cs.primary),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        linked ? 'Connecté' : 'Non lié',
        style: TextStyle(
          color: linked ? Colors.green[700] : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (linked)
            const Icon(Icons.verified_rounded, color: Colors.green)
          else
            Icon(Icons.link_rounded, color: cs.primary),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
      onTap: onTap,
    );
  }
}
