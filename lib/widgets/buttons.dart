import 'package:flutter/material.dart';
import '../../constants/colors/main_color.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

class SpeakButton extends StatefulWidget {
  const SpeakButton({super.key});

  @override
  State<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<SpeakButton> {
  final FlutterTts tts = FlutterTts();

  Future<void> _speak() async {
    await tts.setLanguage("fr-FR");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.9);
    await tts.speak("Numéro de téléphone");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _speak,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: gaindeGreen, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Image.asset("assets/img/play.png", fit: BoxFit.contain),
      ),
    );
  }
}

class GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color glowColor;
  final Color bgColor;
  final IconData? icon;
  final double height;
  final double radius;
  final Color textColor;

  final bool pulse;

  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.glowColor,
    required this.bgColor,
    required this.textColor,
    this.icon,
    this.height = 54,
    this.radius = 16,
    this.pulse = true,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _hovered = false;

  late final AnimationController _pulse;
  late final Animation<double> _pulseT;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseT = CurvedAnimation(parent: _pulse, curve: Curves.easeInOut);
    if (widget.pulse) _pulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _setPressed(bool v) => setState(() => _pressed = v);
  void _setHovered(bool v) => setState(() => _hovered = v);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseT,
      builder: (context, _) {
        final base = 0.28 + (_pulseT.value * 0.10); // 0.28 → 0.38
        final hover = 0.40 + (_pulseT.value * 0.08); // 0.40 → 0.48
        final press = 0.58; // fixe au press

        final glowOpacity = _pressed ? press : (_hovered ? hover : base);
        final blur = _pressed ? 30.0 : (22.0 + (_pulseT.value * 6.0));

        return MouseRegion(
          onEnter: (_) => _setHovered(true),
          onExit: (_) => _setHovered(false),
          child: GestureDetector(
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(widget.radius),
                boxShadow: [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(glowOpacity),
                    blurRadius: blur,
                    spreadRadius: _pressed ? 2 : 1,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(.07),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: widget.glowColor.withOpacity(.30),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[const SizedBox(width: 10)],
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: widget.textColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .2,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OutlineSoftButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const OutlineSoftButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: gaindeRed.withOpacity(.45)),
          foregroundColor: gaindeRed,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        onPressed: onTap,
      ),
    );
  }
}
