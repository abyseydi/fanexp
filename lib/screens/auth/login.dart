import 'dart:async';
import 'dart:math';
import 'package:fanexp/constants/colors/main_color.dart';
import 'package:fanexp/constants/size.dart';
import 'package:fanexp/screens/home/home.dart' hide gaindeGreen;
import 'package:fanexp/widgets/appBarGeneral.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fanexp/screens/auth/register.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/inputs.dart';
import 'package:fanexp/widgets/buttons.dart';

const Color _aiGreen = Color(0xFF00C853);

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  bool _loading = false;
  bool _codeSent = false;
  int _secondsLeft = 0;
  Timer? _timer;

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
    phoneCtrl.dispose();
    codeCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown([int seconds = 60]) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _sendCode() async {
    if (phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un numéro.')),
      );
      return;
    }

    setState(() => _loading = true);
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _loading = false;
      _codeSent = true;
    });
    _startCountdown(60);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Code envoyé (simulation).')));
  }

  Future<void> _verifyCode() async {
    if (!_codeSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demandez le code d’abord.')),
      );
      return;
    }

    final code = codeCtrl.text.trim();
    if (code.length != 4 || !RegExp(r'^\d{4}$').hasMatch(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez un code à 4 chiffres.')),
      );
      return;
    }

    setState(() => _loading = true);
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connexion réussie ✅')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  stops: [0, .6, 1],
                  colors: [_aiGreen, Color(0x2900C853), Colors.transparent],
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: GlassCard(
                background: Colors.white,
                borderColor: Colors.black.withOpacity(.06),
                shadowColor: Colors.black.withOpacity(.08),
                blur: 14,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'fsf-logo',
                      child: Image.asset(
                        'assets/img/federation.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'CONNEXION',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Input(
                      controller: phoneCtrl,
                      hint: 'Numéro de téléphone',
                      icon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Numéro requis' : null,
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          width: mediaWidth(context) * 0.5,
                          child: GlowButton(
                            textColor: Colors.white,
                            bgColor: gaindeGreen,
                            label: "Envoyer le code",
                            onTap: _sendCode,
                            glowColor: gaindeGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text(
                              _secondsLeft > 0 ? '$_secondsLeft s' : '',
                              style: TextStyle(
                                color: Colors.black.withOpacity(.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _CodeField(controller: codeCtrl, enabled: _codeSent),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: gaindeGreen,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _loading ? null : _verifyCode,
                        child: _loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Vérifier & Entrer'),
                      ),
                    ),

                    const SizedBox(height: 12),
                    const _OrDivider(),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: const [
                        _SSOChip(icon: Icons.apple, label: 'Apple'),
                        _SSOChip(
                          icon: Icons.g_mobiledata_rounded,
                          label: 'Google',
                        ),
                        _SSOChip(icon: Icons.email_outlined, label: 'Email'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black.withOpacity(.15)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () =>
                Navigator.pushReplacement(context, _fade(const Register())),
            icon: const Icon(
              Icons.person_add_alt_1_rounded,
              color: gaindeGreen,
            ),
            label: const Text(
              "Créer un compte",
              style: TextStyle(color: gaindeGreen, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _CodeField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const _CodeField({required this.controller, this.enabled = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      textAlign: TextAlign.center,
      style: const TextStyle(
        letterSpacing: 8,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: '— — — —',
        hintStyle: TextStyle(
          letterSpacing: 8,
          color: Colors.black.withOpacity(.25),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: _aiGreen, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
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
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Connexion $label bientôt dispo'))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(.85),
          border: Border.all(color: Colors.black.withOpacity(.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
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
    final rnd = Random(24);
    final dots = <Offset>[];
    for (int i = 0; i < 26; i++) {
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
        if (d < size.shortestSide * .18) canvas.drawLine(a, b, linkPaint);
      }
    }
    final dotPaint = Paint()..color = dotColor;
    for (final p in dots) {
      canvas.drawCircle(p, 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralNetPainter old) =>
      old.dotColor != dotColor || old.linkColor != linkColor;
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
