import 'dart:math';
import 'dart:ui';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/constants/size.dart';
import 'package:fanexp/screens/auth/login.dart';
import 'package:fanexp/screens/auth/register.dart';
import 'package:fanexp/screens/home/home.dart' hide gaindeGreen;

import 'package:fanexp/widgets/appBarGeneral.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/widgets/buttons.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00C853),
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
      appBar: AppBarGeneral(),
      body: Stack(
        fit: StackFit.expand,
        children: [
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

          IgnorePointer(
            child: CustomPaint(
              painter: _NeuralNetPainter(
                dotColor: Colors.black.withOpacity(.06),
                linkColor: Colors.black.withOpacity(.05),
              ),
              size: Size.infinite,
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
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

class _AuthContent extends StatelessWidget {
  const _AuthContent();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 18),

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
            'assets/img/federation.png',
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
          'Vibre au rythme de la taniere.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(.55),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 26),

        GlowButton(
          label: 'Se connecter',
          onTap: () => Navigator.of(context).push(_fade(Login())),
          glowColor: cs.primary,
          bgColor: gaindeGreen,
          textColor: Colors.white,
        ),
        const SizedBox(height: 12),
        GlowButton(
          glowColor: cs.primary,
          label: "S'inscrire",
          bgColor: Colors.white,
          textColor: Colors.black,
          onTap: () => Navigator.of(context).push(_fade(const Register())),
        ),

        const SizedBox(height: 20),
        const _OrDivider(),
        const SizedBox(height: 12),

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
      onTap: () {},
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
    await Future<void>.delayed(const Duration(milliseconds: 900));
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
          GlassCard(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Input(
                    controller: nameCtrl,
                    hint: 'Nom complet',
                    icon: Icons.badge_outlined,
                    validator: (v) => (v == null || v.trim().length < 2)
                        ? 'Nom invalide'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Input(
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
                  Input(
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
                Navigator.pushReplacement(context, _fade(const Login())),
            icon: const Icon(Icons.login_rounded),
            label: const Text('J’ai déjà un compte'),
          ),
        ),
      ),
    );
  }
}

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

class GradientTranslation extends GradientTransform {
  final double dx;
  const GradientTranslation(this.dx);
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..translate(dx, 0.0);
  }
}
