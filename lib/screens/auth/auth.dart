// import 'dart:ui';
// import 'package:flutter/material.dart';

// class Auth extends StatelessWidget {
//   const Auth({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cs = ColorScheme.fromSeed(
//       seedColor: const Color(0xFF00C853), // vert fédé
//       brightness: Brightness.light,
//     );

//     return Theme(
//       data: ThemeData(
//         useMaterial3: true,
//         colorScheme: cs,
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: const Color(0xFFF6F8FB),
//       ),
//       child: const _AuthScaffold(),
//     );
//   }
// }

// class _AuthScaffold extends StatelessWidget {
//   const _AuthScaffold();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     final cs = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Dégradé doux clair
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFFF6F8FB),
//                   Color(0xFFEFF3F9),
//                   Color(0xFFF6F8FB),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),

//           // Halo subtil
//           Align(
//             alignment: const Alignment(-0.9, -1.0),
//             child: Container(
//               width: size.width * .7,
//               height: size.width * .7,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: RadialGradient(
//                   colors: [cs.primary.withOpacity(.18), Colors.transparent],
//                 ),
//               ),
//             ),
//           ),

//           // Carte en verre (version light)
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: _GlassCard(
//                 blur: 12,
//                 background: Colors.white.withOpacity(.65),
//                 borderColor: Colors.black.withOpacity(.06),
//                 shadowColor: Colors.black.withOpacity(.08),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.green.withOpacity(0.3),
//                             blurRadius: 20,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Image.asset(
//                         'assets/img/federation.png',
//                         height: 100,
//                       ),
//                     ),

//                     const SizedBox(height: 18),
//                     Text(
//                       'GoGAINDE',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: .4,
//                         color: Colors.black.withOpacity(.92),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'Du stade à ton écran : l’émotion en direct.',
//                       style: TextStyle(
//                         color: Colors.black.withOpacity(.55),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 28),

//                     _PrimaryButton(
//                       label: 'Se connecter',
//                       icon: Icons.login_rounded,
//                       onTap: () =>
//                           Navigator.of(context).push(_fade(const LoginPage())),
//                     ),
//                     const SizedBox(height: 12),
//                     _SecondaryButton(
//                       label: "S'inscrire",
//                       icon: Icons.person_add_alt_1_rounded,
//                       onTap: () => Navigator.of(
//                         context,
//                       ).push(_fade(const RegisterPage())),
//                     ),

//                     const SizedBox(height: 20),
//                     const _OrDivider(),
//                     const SizedBox(height: 12),

//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       alignment: WrapAlignment.center,
//                       children: const [
//                         _SSOChip(icon: Icons.apple, label: 'Apple'),
//                         _SSOChip(
//                           icon: Icons.g_mobiledata_rounded,
//                           label: 'Google',
//                         ),
//                         _SSOChip(icon: Icons.email_outlined, label: 'Email'),
//                       ],
//                     ),
//                     const SizedBox(height: 12),

//                     Opacity(
//                       opacity: .7,
//                       child: Text(
//                         "En continuant, vous acceptez nos conditions d’utilisation.",
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---------- Boutons ----------
// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;
//   const _PrimaryButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 0,
//         ),
//         icon: Icon(icon),
//         label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//         onPressed: onTap,
//       ),
//     );
//   }
// }

// class _SecondaryButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;
//   const _SecondaryButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return SizedBox(
//       width: double.infinity,
//       child: OutlinedButton.icon(
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: cs.outline.withOpacity(.5)),
//           foregroundColor: Colors.black87,
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         icon: Icon(icon),
//         label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
//         onPressed: onTap,
//       ),
//     );
//   }
// }

// // ---------- Carte verre réutilisable ----------
// class _GlassCard extends StatelessWidget {
//   final Widget child;
//   final double blur;
//   final Color background;
//   final Color borderColor;
//   final Color shadowColor;
//   const _GlassCard({
//     required this.child,
//     this.blur = 12,
//     this.background = const Color(0xA0FFFFFF),
//     this.borderColor = const Color(0x14000000),
//     this.shadowColor = const Color(0x14000000),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             color: background,
//             border: Border.all(color: borderColor),
//             boxShadow: [
//               BoxShadow(
//                 color: shadowColor,
//                 blurRadius: 30,
//                 spreadRadius: -8,
//                 offset: const Offset(0, 14),
//               ),
//             ],
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }

// class _OrDivider extends StatelessWidget {
//   const _OrDivider();
//   @override
//   Widget build(BuildContext context) {
//     final line = Expanded(
//       child: Container(height: 1, color: Colors.black.withOpacity(.08)),
//     );
//     return Row(
//       children: [
//         line,
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Opacity(
//             opacity: .6,
//             child: Text('ou', style: Theme.of(context).textTheme.bodyMedium),
//           ),
//         ),
//         line,
//       ],
//     );
//   }
// }

// class _SSOChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _SSOChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: () {}, // TODO: brancher SSO
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: cs.surface.withOpacity(.75),
//           border: Border.all(color: cs.outline.withOpacity(.25)),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 20, color: Colors.black87),
//             const SizedBox(width: 8),
//             Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ---------- Login ----------
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final formKey = GlobalKey<FormState>();
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   bool loading = false;

//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     passCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!formKey.currentState!.validate()) return;
//     setState(() => loading = true);
//     await Future<void>.delayed(
//       const Duration(milliseconds: 900),
//     ); // TODO: API auth
//     if (!mounted) return;
//     setState(() => loading = false);
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Connexion réussie (mock)')));
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Se connecter'),
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
//         children: [
//           const SizedBox(height: 8),
//           Text(
//             'Ravis de vous revoir 👋',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 18),
//           _GlassCard(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   _Input(
//                     controller: emailCtrl,
//                     hint: 'Email',
//                     icon: Icons.alternate_email_rounded,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (v) =>
//                         (v == null || v.isEmpty || !v.contains('@'))
//                         ? 'Email invalide'
//                         : null,
//                   ),
//                   const SizedBox(height: 12),
//                   _Input(
//                     controller: passCtrl,
//                     hint: 'Mot de passe',
//                     icon: Icons.lock_outline_rounded,
//                     obscure: true,
//                     validator: (v) => (v == null || v.length < 6)
//                         ? 'Au moins 6 caractères'
//                         : null,
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton(
//                       onPressed: loading ? null : _submit,
//                       child: loading
//                           ? const SizedBox(
//                               height: 18,
//                               width: 18,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             )
//                           : const Text('Connexion'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 18),
//           TextButton(
//             onPressed: () {},
//             child: const Text('Mot de passe oublié ?'),
//           ),
//           const SizedBox(height: 24),
//           Opacity(
//             opacity: .7,
//             child: Text(
//               'Astuce : activez les notifications pour recevoir les buts en direct.',
//               style: Theme.of(context).textTheme.bodySmall,
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//           child: OutlinedButton.icon(
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: cs.outline.withOpacity(.35)),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 14),
//             ),
//             onPressed: () =>
//                 Navigator.pushReplacement(context, _fade(const RegisterPage())),
//             icon: const Icon(Icons.person_add_alt_1_rounded),
//             label: const Text("Créer un compte"),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ---------- Register ----------
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final formKey = GlobalKey<FormState>();
//   final nameCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   bool loading = false;
//   bool agree = true;

//   @override
//   void dispose() {
//     nameCtrl.dispose();
//     emailCtrl.dispose();
//     passCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!formKey.currentState!.validate() || !agree) return;
//     setState(() => loading = true);
//     await Future<void>.delayed(const Duration(milliseconds: 900)); // TODO: API
//     if (!mounted) return;
//     setState(() => loading = false);
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Compte créé (mock)')));
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("S'inscrire"),
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
//         children: [
//           const SizedBox(height: 8),
//           Text(
//             'Rejoignez la communauté 💚',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 18),
//           _GlassCard(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   _Input(
//                     controller: nameCtrl,
//                     hint: 'Nom complet',
//                     icon: Icons.badge_outlined,
//                     validator: (v) => (v == null || v.trim().length < 2)
//                         ? 'Nom invalide'
//                         : null,
//                   ),
//                   const SizedBox(height: 12),
//                   _Input(
//                     controller: emailCtrl,
//                     hint: 'Email',
//                     icon: Icons.alternate_email_rounded,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (v) =>
//                         (v == null || v.isEmpty || !v.contains('@'))
//                         ? 'Email invalide'
//                         : null,
//                   ),
//                   const SizedBox(height: 12),
//                   _Input(
//                     controller: passCtrl,
//                     hint: 'Mot de passe',
//                     icon: Icons.lock_outline_rounded,
//                     obscure: true,
//                     validator: (v) => (v == null || v.length < 6)
//                         ? 'Au moins 6 caractères'
//                         : null,
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: agree,
//                         onChanged: (v) => setState(() => agree = v ?? false),
//                       ),
//                       Expanded(
//                         child: Text(
//                           "J'accepte les conditions d’utilisation",
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton(
//                       onPressed: (!agree || loading) ? null : _submit,
//                       child: loading
//                           ? const SizedBox(
//                               height: 18,
//                               width: 18,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             )
//                           : const Text("Créer le compte"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           Opacity(
//             opacity: .7,
//             child: Text(
//               "Astuce : ajoutez vos équipes favorites pour recevoir les notifications de buts.",
//               style: Theme.of(context).textTheme.bodySmall,
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//           child: OutlinedButton.icon(
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: cs.outline.withOpacity(.35)),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 14),
//             ),
//             onPressed: () =>
//                 Navigator.pushReplacement(context, _fade(const LoginPage())),
//             icon: const Icon(Icons.login_rounded),
//             label: const Text('J’ai déjà un compte'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ---------- Inputs ----------
// class _Input extends StatelessWidget {
//   final TextEditingController controller;
//   final String hint;
//   final IconData icon;
//   final TextInputType? keyboardType;
//   final bool obscure;
//   final String? Function(String?)? validator;
//   const _Input({
//     required this.controller,
//     required this.hint,
//     required this.icon,
//     this.keyboardType,
//     this.obscure = false,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return TextFormField(
//       controller: controller,
//       obscureText: obscure,
//       keyboardType: keyboardType,
//       validator: validator,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon, color: Colors.black87),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: cs.outline.withOpacity(.3)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: cs.outline.withOpacity(.3)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: cs.primary, width: 1.5),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 16,
//           horizontal: 14,
//         ),
//       ),
//     );
//   }
// }

// // ---------- Transition fade ----------
// PageRouteBuilder<T> _fade<T>(Widget page) {
//   return PageRouteBuilder<T>(
//     transitionDuration: const Duration(milliseconds: 420),
//     pageBuilder: (_, __, ___) => page,
//     transitionsBuilder: (_, anim, __, child) => FadeTransition(
//       opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
//       child: child,
//     ),
//   );
// }

import 'dart:math';
import 'dart:ui';
import 'package:fanexp/constants/size.dart';
import 'package:fanexp/screens/auth/login.dart';
import 'package:fanexp/screens/auth/register.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00C853), // vert néon
      brightness: Brightness.light,
    );

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: cs,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.black87),
        ),
      ),
      child: const _AuthScaffold(),
    );
  }
}

class _AuthScaffold extends StatefulWidget {
  const _AuthScaffold();

  @override
  State<_AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<_AuthScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Dégradé animé (doucement mouvant)
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              final t = Curves.easeInOut.transform(_ctrl.value);
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + t * 0.2, -1),
                    end: Alignment(1 - t * 0.2, 1),
                    colors: const [
                      Color(0xFFF6F8FB),
                      Color(0xFFEFF3F9),
                      Color(0xFFF6F8FB),
                    ],
                  ),
                ),
              );
            },
          ),

          // 2) Halo IA (radial subtil)
          Align(
            alignment: const Alignment(0.85, -0.95),
            child: Container(
              width: size.width * .65,
              height: size.width * .65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  stops: const [0, .6, 1],
                  colors: [
                    cs.primary.withOpacity(.18),
                    cs.primary.withOpacity(.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3) Motif “neural” très léger (canvas custom)
          IgnorePointer(
            child: CustomPaint(
              painter: _NeuralNetPainter(
                dotColor: Colors.black.withOpacity(.06),
                linkColor: Colors.black.withOpacity(.05),
              ),
              size: Size.infinite,
            ),
          ),

          // 4) Carte en verre
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _GlassCard(
                blur: 14,
                background: Colors.white,
                borderColor: Colors.black.withOpacity(.06),
                shadowColor: Colors.black.withOpacity(.08),
                child: const _AuthContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------- Contenu de la carte ---------
class _AuthContent extends StatelessWidget {
  const _AuthContent();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge AI
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(999),
        //     color: cs.primary.withOpacity(.08),
        //     border: Border.all(color: cs.primary.withOpacity(.25)),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(Icons.auto_awesome_rounded, size: 16, color: cs.primary),
        //       const SizedBox(width: 6),
        //       Text(
        //         'IA-powered fan experience',
        //         style: TextStyle(
        //           color: Colors.black.withOpacity(.7),
        //           fontWeight: FontWeight.w600,
        //           fontSize: 12.5,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 18),

        // Logo FSF (optionnel) + marque
        // -> remplace par ton asset si besoin
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(.25),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.asset(
            'assets/img/federation.png', // <= ton logo
            height: mediaHeight(context) * 0.25,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 16),
        _ShimmerText(
          'GoGAINDE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: .4,
            color: Colors.black.withOpacity(.92),
          ),
          shimmerColor: cs.primary,
        ),
        const SizedBox(height: 6),
        Text(
          'Vibre au rythme de la tanniere.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(.55),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 26),

        // CTA
        _GlowButton(
          label: 'Se connecter',
          icon: Icons.login_rounded,
          onTap: () => Navigator.of(context).push(_fade(Login())),
          glowColor: cs.primary,
        ),
        const SizedBox(height: 12),
        _OutlineSoftButton(
          label: "S'inscrire",
          icon: Icons.person_add_alt_1_rounded,
          onTap: () => Navigator.of(context).push(_fade(const Register())),
        ),

        const SizedBox(height: 20),
        const _OrDivider(),
        const SizedBox(height: 12),

        // SSO
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: const [
            _SSOChip(icon: Icons.apple, label: 'Apple'),
            _SSOChip(icon: Icons.g_mobiledata_rounded, label: 'Google'),
            _SSOChip(icon: Icons.email_outlined, label: 'Email'),
          ],
        ),

        const SizedBox(height: 14),
        Opacity(
          opacity: .7,
          child: Text(
            "En continuant, vous acceptez nos conditions d’utilisation.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

// --------- Boutons “AI look” ---------
class _GlowButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color glowColor;

  const _GlowButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(.35),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(icon),
          label: const Text(
            'Se connecter',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}

class _OutlineSoftButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _OutlineSoftButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: cs.outline.withOpacity(.45)),
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        onPressed: onTap,
      ),
    );
  }
}

// --------- Carte verre réutilisable ---------
class _GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color background;
  final Color borderColor;
  final Color shadowColor;

  const _GlassCard({
    required this.child,
    this.blur = 12,
    this.background = const Color(0xA0FFFFFF),
    this.borderColor = const Color(0x14000000),
    this.shadowColor = const Color(0x14000000),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: background,
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 30,
                spreadRadius: -8,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// --------- SSO & séparateur ---------
class _OrDivider extends StatelessWidget {
  const _OrDivider();
  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: Colors.black.withOpacity(.08)),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Opacity(
            opacity: .6,
            child: Text('ou', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        line,
      ],
    );
  }
}

class _SSOChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SSOChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {}, // TODO: brancher SSO
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cs.surface.withOpacity(.75),
          border: Border.all(color: cs.outline.withOpacity(.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// --------- “Neural net” painter (léger & chic) ---------
class _NeuralNetPainter extends CustomPainter {
  final Color dotColor;
  final Color linkColor;
  _NeuralNetPainter({required this.dotColor, required this.linkColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(42);
    final dots = <Offset>[];
    for (int i = 0; i < 28; i++) {
      dots.add(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
      );
    }

    final linkPaint = Paint()
      ..color = linkColor
      ..strokeWidth = 1;

    // relier quelques points proches
    for (final a in dots) {
      for (final b in dots) {
        if (a == b) continue;
        final d = (a - b).distance;
        if (d < size.shortestSide * .18) {
          canvas.drawLine(a, b, linkPaint);
        }
      }
    }

    final dotPaint = Paint()..color = dotColor;
    for (final p in dots) {
      canvas.drawCircle(p, 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralNetPainter oldDelegate) =>
      oldDelegate.dotColor != dotColor || oldDelegate.linkColor != linkColor;
}

// --------- ÉCRANS LOGIN / REGISTER (identiques à ton flux, UI harmonisée) ---------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900)); // TODO: API
    if (!mounted) return;
    setState(() => loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connexion réussie (mock)')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Se connecter'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          const SizedBox(height: 8),
          Text(
            'Ravis de vous revoir 👋',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          _GlassCard(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _Input(
                    controller: emailCtrl,
                    hint: 'Email',
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty || !v.contains('@'))
                        ? 'Email invalide'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _Input(
                    controller: passCtrl,
                    hint: 'Mot de passe',
                    icon: Icons.lock_outline_rounded,
                    obscure: true,
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Au moins 6 caractères'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Connexion'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () {},
            child: const Text('Mot de passe oublié ?'),
          ),
          const SizedBox(height: 24),
          Opacity(
            opacity: .7,
            child: Text(
              'Astuce : activez les notifications pour recevoir les buts en direct.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cs.outline.withOpacity(.35)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () =>
                Navigator.pushReplacement(context, _fade(const RegisterPage())),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text("Créer un compte"),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool agree = true;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate() || !agree) return;
    setState(() => loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900)); // TODO: API
    if (!mounted) return;
    setState(() => loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Compte créé (mock)')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("S'inscrire"),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          const SizedBox(height: 8),
          Text(
            'Rejoignez la communauté 💚',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          _GlassCard(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _Input(
                    controller: nameCtrl,
                    hint: 'Nom complet',
                    icon: Icons.badge_outlined,
                    validator: (v) => (v == null || v.trim().length < 2)
                        ? 'Nom invalide'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _Input(
                    controller: emailCtrl,
                    hint: 'Email',
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty || !v.contains('@'))
                        ? 'Email invalide'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _Input(
                    controller: passCtrl,
                    hint: 'Mot de passe',
                    icon: Icons.lock_outline_rounded,
                    obscure: true,
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Au moins 6 caractères'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: agree,
                        onChanged: (v) => setState(() => agree = v ?? false),
                      ),
                      Expanded(
                        child: Text(
                          "J'accepte les conditions d’utilisation",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (!agree || loading) ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Créer le compte"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Opacity(
            opacity: .7,
            child: Text(
              "Astuce : ajoutez vos équipes favorites pour recevoir les notifications de buts.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cs.outline.withOpacity(.35)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () =>
                Navigator.pushReplacement(context, _fade(const LoginPage())),
            icon: const Icon(Icons.login_rounded),
            label: const Text('J’ai déjà un compte'),
          ),
        ),
      ),
    );
  }
}

// --------- Inputs ---------
class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscure;
  final String? Function(String?)? validator;
  const _Input({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black87),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outline.withOpacity(.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outline.withOpacity(.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
      ),
    );
  }
}

// --------- Transition fade ---------
PageRouteBuilder<T> _fade<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
      child: child,
    ),
  );
}

// --------- Shimmer texte (sans package) ---------
class _ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color shimmerColor;
  const _ShimmerText(this.text, {this.style, required this.shimmerColor});

  @override
  State<_ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<_ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (rect) {
            final width = rect.width;
            final dx = (width + 120) * _c.value - 60;
            return LinearGradient(
              colors: [
                Colors.transparent,
                widget.shimmerColor.withOpacity(.6),
                Colors.transparent,
              ],
              stops: const [0.35, 0.5, 0.65],
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              transform: GradientTranslation(dx),
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: Text(widget.text, style: widget.style),
        );
      },
    );
  }
}

// Utilitaire pour translater le gradient
class GradientTranslation extends GradientTransform {
  final double dx;
  const GradientTranslation(this.dx);
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..translate(dx, 0.0);
  }
}
