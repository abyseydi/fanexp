import 'package:fanexp/screens/settings/profile.dart';
import 'package:flutter/material.dart';

const gaindeGreen = Color(0xFF007A33);
const gaindeGold = Color(0xFFFFD100);
const gaindeRed = Color(0xFFE31E24);
const gaindeInk = Color(0xFF0F1D13);
const gaindeBg = Color(0xFFF6F8FB);

const gaindeGreenSoft = Color(0xFFE5F3EC);
const gaindeGoldSoft = Color(0xFFFFF4C2);
const gaindeRedSoft = Color(0xFFFCE1E3);

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

enum AppThemeMode { system, light, dark }

enum AppLanguage { fr, en }

class _SettingsState extends State<Settings> {
  bool notifMatchAlerts = true;
  bool notifGoals = true;
  bool notifCards = true;
  bool notifBreaking = true;
  bool notifTraining = false;
  bool notifLive = true;

  bool privacyPrivate = false;
  bool privacyMentions = true;
  bool privacyShareActivity = true;

  AppThemeMode themeMode = AppThemeMode.system;
  AppLanguage language = AppLanguage.fr;

  double dataCacheMb = 128.4;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickTheme() async {
    final selected = await showModalBottomSheet<AppThemeMode>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 8),
            const Text(
              'Thème',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _RadioTile<AppThemeMode>(
              value: AppThemeMode.system,
              group: themeMode,
              title: 'Système',
              onChanged: (v) => Navigator.pop(context, v),
            ),
            _RadioTile<AppThemeMode>(
              value: AppThemeMode.light,
              group: themeMode,
              title: 'Clair',
              onChanged: (v) => Navigator.pop(context, v),
            ),
            _RadioTile<AppThemeMode>(
              value: AppThemeMode.dark,
              group: themeMode,
              title: 'Sombre',
              onChanged: (v) => Navigator.pop(context, v),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => themeMode = selected);
      _snack('Thème appliqué : ${_themeLabel(selected)}');
    }
  }

  String _themeLabel(AppThemeMode m) {
    switch (m) {
      case AppThemeMode.system:
        return 'Système';
      case AppThemeMode.light:
        return 'Clair';
      case AppThemeMode.dark:
        return 'Sombre';
    }
  }

  Future<void> _pickLanguage() async {
    final selected = await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 8),
            const Text(
              'Langue',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _RadioTile<AppLanguage>(
              value: AppLanguage.fr,
              group: language,
              title: 'Français',
              onChanged: (v) => Navigator.pop(context, v),
            ),
            _RadioTile<AppLanguage>(
              value: AppLanguage.en,
              group: language,
              title: 'English',
              onChanged: (v) => Navigator.pop(context, v),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() => language = selected);
      _snack('Langue : ${selected == AppLanguage.fr ? 'Français' : 'English'}');
      // TODO: changer locale app + persister
    }
  }

  Future<void> _confirmClearCache() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Vider le cache ?'),
        content: Text(
          'Cela libérera ~${dataCacheMb.toStringAsFixed(1)} Mo de stockage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: gaindeGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vider'),
          ),
        ],
      ),
    );
    if (yes == true) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => dataCacheMb = 0);
      _snack('Cache vidé ✅');
    }
  }

  Future<void> _confirmLogout() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text('Vous pourrez vous reconnecter à tout moment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: gaindeInk,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (yes == true) {
      _snack('Déconnecté');
    }
  }

  Future<void> _confirmDelete() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le compte ?'),
        content: const Text(
          'Action irréversible. Vos données seront supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: gaindeRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (yes == true) {
      _snack('Suppression demandée…');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
        // actions: [
        //   IconButton(
        //     tooltip: 'Sauvegarder (demo)',
        //     onPressed: () => _snack('Réglages sauvegardés'),
        //     icon: const Icon(Icons.check_rounded),
        //   ),
        // ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SectionTitle('Compte'),
          SizedBox(height: 8),
          _Card(
            child: Column(
              children: [
                _NavTile(
                  icon: Icons.person_outline,
                  title: 'Profil',
                  subtitle: 'Nom, photo, bio',
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => Profile())),
                ),
                _DividerThin(),
                _NavTile(
                  icon: Icons.lock_outline,
                  title: 'Sécurité',
                  subtitle: 'Mot de passe, 2FA',
                  onTap: () {},
                ),
                // _DividerThin(),
                // _NavTile(
                //   icon: Icons.link_outlined,
                //   title: 'Comptes liés',
                //   subtitle: 'Apple / Google / X / Facebook',
                //   onTap: () {},
                // ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _SectionTitle('Notifications'),
          SizedBox(height: 8),
          _Card(
            child: Column(
              children: [
                _SwitchTile(
                  icon: Icons.sports_soccer_outlined,
                  title: 'Alertes match (J-1 / J-0 / coup d’envoi)',
                  value: notifMatchAlerts,
                  onChanged: (v) => setState(() => notifMatchAlerts = v),
                ),
                _DividerThin(),
                _SwitchTile(
                  icon: Icons.sports_outlined,
                  title: 'Buts',
                  value: notifGoals,
                  onChanged: (v) => setState(() => notifGoals = v),
                ),
                _DividerThin(),
                _SwitchTile(
                  icon: Icons.warning_amber_outlined,
                  title: 'Cartons',
                  value: notifCards,
                  onChanged: (v) => setState(() => notifCards = v),
                ),
                _DividerThin(),
                _SwitchTile(
                  icon: Icons.bolt_outlined,
                  title: 'Breaking',
                  value: notifBreaking,
                  onChanged: (v) => setState(() => notifBreaking = v),
                ),
                _DividerThin(),
                _SwitchTile(
                  icon: Icons.fitness_center_outlined,
                  title: 'Inside Training / contenus d’entraînement',
                  value: notifTraining,
                  onChanged: (v) => setState(() => notifTraining = v),
                ),
                // _DividerThin(),
                // _SwitchTile(
                //   icon: Icons.live_tv_outlined,
                //   title: 'Live / résumés IA en direct',
                //   value: notifLive,
                //   onChanged: (v) => setState(() => notifLive = v),
                // ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // _SectionTitle('Confidentialité'),
          // SizedBox(height: 8),
          // _Card(
          //   child: Column(
          //     children: [
          //       _SwitchTile(
          //         icon: Icons.lock_person_outlined,
          //         title: 'Profil privé',
          //         subtitle: 'Seuls vos abonnés voient votre activité',
          //         value: privacyPrivate,
          //         onChanged: (v) => setState(() => privacyPrivate = v),
          //       ),

          //       _DividerThin(),
          //       _SwitchTile(
          //         icon: Icons.insights_outlined,
          //         title: 'Partager mes interactions anonymisées',
          //         subtitle: 'Aide Go Gaïndé à améliorer ses recommandations IA',
          //         value: privacyShareActivity,
          //         onChanged: (v) => setState(() => privacyShareActivity = v),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 16),
          _SectionTitle('Affichage & langue'),
          SizedBox(height: 8),
          _Card(
            child: Column(
              children: [
                _NavTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Thème',
                  subtitle: _themeLabel(themeMode),
                  onTap: _pickTheme,
                ),
                _DividerThin(),
                _NavTile(
                  icon: Icons.language_outlined,
                  title: 'Langue',
                  subtitle: language == AppLanguage.fr ? 'Français' : 'English',
                  onTap: _pickLanguage,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SectionTitle('À propos'),
          SizedBox(height: 8),
          _Card(
            child: Column(
              children: [
                _NavTile(
                  icon: Icons.info_outline,
                  title: 'Version',
                  subtitle: 'Go Gaïndé 1.0.0 (Build 1)',
                  onTap: () {},
                ),
                _DividerThin(),
                _NavTile(
                  icon: Icons.description_outlined,
                  title: 'Licences',
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Go Gaïndé',
                  ),
                ),
                _DividerThin(),
                _NavTile(
                  icon: Icons.verified_outlined,
                  title: 'Crédits & mentions légales',
                  onTap: () => _snack('Crédits…'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _SectionTitle('Zone sensible'),
          SizedBox(height: 8),
          _Card(
            color: gaindeRedSoft,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout, color: gaindeInk),
                  title: const Text(
                    'Se déconnecter',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _confirmLogout,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: gaindeRed),
                  title: const Text(
                    'Supprimer mon compte',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: gaindeRed,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _confirmDelete,
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
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 12,
        letterSpacing: 1.1,
        color: gaindeInk.withOpacity(.6),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final Color? color;
  const _Card({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DividerThin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.black.withOpacity(.08));
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: cs.primary.withOpacity(.1),
        child: Icon(icon, color: cs.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: cs.primary.withOpacity(.1),
        child: Icon(icon, color: cs.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: gaindeGreen,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.black12,
      ),
      onTap: () => onChanged(!value),
    );
  }
}

class _RadioTile<T> extends StatelessWidget {
  final T value;
  final T group;
  final String title;
  final ValueChanged<T> onChanged;

  const _RadioTile({
    required this.value,
    required this.group,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == group;
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? gaindeGreen : Colors.black26,
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      onTap: () => onChanged(value),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      margin: const EdgeInsets.only(top: 10, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
