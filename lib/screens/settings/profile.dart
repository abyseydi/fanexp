import 'dart:ui';

import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/constants/size.dart';
import 'package:fanexp/screens/auth/auth.dart';
import 'package:fanexp/services/auth/sharedPreferences.service.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // 👉 À brancher plus tard sur ton UserService / SharedPreferences
  String fullName = 'Aby Fan GO⚽';
  String phone = '+221 77 000 00 00';
  String email = 'fan@gogainde.sn';
  String city = 'Dakar, Sénégal';
  String favTeam = 'Équipe Nationale du Sénégal';
  String favClub = 'FC Bayern München';

  bool notifGoals = true;
  bool notifBreaking = true;
  bool notifMercto = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final h = mediaHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // --- Background gradient + blur ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE8F5E9), Color(0xFFF6F8FB)],
              ),
            ),
          ),
          Positioned(
            top: -h * 0.18,
            right: -h * 0.08,
            child: _GlowCircle(
              color: cs.primary.withOpacity(.22),
              size: h * .35,
            ),
          ),
          Positioned(
            bottom: -h * 0.2,
            left: -h * 0.1,
            child: _GlowCircle(
              color: Colors.amber.withOpacity(.18),
              size: h * .4,
            ),
          ),

          // --- Contenu ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderProfile(fullName: fullName, favTeam: favTeam, cs: cs),
                  const SizedBox(height: 18),

                  _AiInsightCard(),
                  const SizedBox(height: 18),

                  // --- Infos personnelles ---
                  GlassCard(
                    background: Colors.white.withOpacity(.9),
                    borderColor: Colors.black.withOpacity(.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(
                          icon: Icons.person_outline_rounded,
                          title: 'Informations personnelles',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Nom complet',
                          value: fullName,
                          icon: Icons.badge_outlined,
                        ),
                        _InfoRow(
                          label: 'Téléphone',
                          value: phone,
                          icon: Icons.phone_iphone_rounded,
                        ),
                        _InfoRow(
                          label: 'Email',
                          value: email,
                          icon: Icons.alternate_email_rounded,
                        ),
                        _InfoRow(
                          label: 'Ville',
                          value: city,
                          icon: Icons.location_on_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Fan profile ---
                  GlassCard(
                    background: Colors.white.withOpacity(.9),
                    borderColor: Colors.black.withOpacity(.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(
                          icon: Icons.sports_soccer_rounded,
                          title: 'Profil supporter',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Équipe nationale',
                          value: favTeam,
                          icon: Icons.flag_circle_rounded,
                        ),
                        _InfoRow(
                          label: 'Club favori',
                          value: favClub,
                          icon: Icons.shield_moon_outlined,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Niveau : Gaïndé Elite',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(.8),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: gaindeGreen.withOpacity(.06),
                                border: Border.all(
                                  color: gaindeGreen.withOpacity(.35),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.bolt_rounded,
                                    size: 16,
                                    color: gaindeGreen,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Fan score 87',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: gaindeGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Paramètres notifications ---
                  GlassCard(
                    background: Colors.white.withOpacity(.9),
                    borderColor: Colors.black.withOpacity(.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(
                          icon: Icons.notifications_active_outlined,
                          title: 'Notifications',
                        ),
                        const SizedBox(height: 4),
                        SwitchListTile.adaptive(
                          value: notifGoals,
                          onChanged: (v) => setState(() => notifGoals = v),
                          title: const Text(
                            'Buts & moments forts',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'Buts, cartons rouges, tirs au but… en temps réel.',
                          ),
                          secondary: const Icon(Icons.sports_soccer_rounded),
                        ),
                        SwitchListTile.adaptive(
                          value: notifBreaking,
                          onChanged: (v) => setState(() => notifBreaking = v),
                          title: const Text(
                            'Breaking news',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'News chaudes, blessure, conférence de presse.',
                          ),
                          secondary: const Icon(Icons.flash_on_rounded),
                        ),
                        SwitchListTile.adaptive(
                          value: notifMercto,
                          onChanged: (v) => setState(() => notifMercto = v),
                          title: const Text(
                            'Mercato & rumeurs',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'Transferts confirmés et rumeurs sérieuses.',
                          ),
                          secondary: const Icon(Icons.swap_horiz_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // // --- Boutons actions ---
                  // GlowButton(
                  //   label: 'Gérer mon compte',
                  //   onTap: () {
                  //     // TODO: aller vers une page "Compte" ou "Paramètres"
                  //   },
                  //   glowColor: cs.primary,
                  //   bgColor: gaindeGreen,
                  //   textColor: Colors.white,
                  // ),
                  // const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final prefs = SharedPreferencesService();

                      // 1. On efface les données locales (token, user, etc.)
                      // await prefs.logout();

                      // 2. On redirige vers l'écran Auth, et on vide la stack de navigation
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Auth()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text(
                      'Se déconnecter',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.withOpacity(.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  // OutlinedButton.icon(
                  //   onPressed: () {
                  //     // TODO: déconnexion + redirection vers Auth/Login
                  //     // Navigator.pushAndRemoveUntil(...);
                  //   },
                  //   icon: const Icon(Icons.logout_rounded, color: Colors.red),
                  //   label: const Text(
                  //     'Se déconnecter',
                  //     style: TextStyle(color: Colors.red),
                  //   ),
                  //   style: OutlinedButton.styleFrom(
                  //     side: BorderSide(color: Colors.red.withOpacity(.5)),
                  //     padding: const EdgeInsets.symmetric(vertical: 12),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(14),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Widgets internes ----------

class _HeaderProfile extends StatelessWidget {
  final String fullName;
  final String favTeam;
  final ColorScheme cs;

  const _HeaderProfile({
    required this.fullName,
    required this.favTeam,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(fullName);

    return GlassCard(
      blur: 18,
      background: Colors.white.withOpacity(.96),
      borderColor: Colors.black.withOpacity(.05),
      shadowColor: Colors.black.withOpacity(.06),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [cs.primary, Colors.amber, gaindeGreen, cs.primary],
                  ),
                ),
              ),
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.military_tech_rounded,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Fan GoGaïndé depuis 2019',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(.65),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: cs.primary.withOpacity(.08),
                    border: Border.all(color: cs.primary.withOpacity(.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: gaindeGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Fan IA : $favTeam',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: gaindeGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.isEmpty
          ? 'G'
          : parts.first.characters.take(2).toString().toUpperCase();
    }
    final first = parts.first.characters.first;
    final last = parts.last.characters.first;
    return (first + last).toUpperCase();
  }
}

class _AiInsightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassCard(
      blur: 18,
      background: cs.surface.withOpacity(.96),
      borderColor: cs.primary.withOpacity(.12),
      shadowColor: cs.primary.withOpacity(.08),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [cs.primary, gaindeGreen]),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil IA personnalisé',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black.withOpacity(.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "GoGainde adapte les stats, les alertes et les contenus "
                  "en fonction de tes habitudes de fan.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.7),
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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: gaindeGreen),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black.withOpacity(.65)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(.55),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0, 1],
        ),
      ),
    );
  }
}
