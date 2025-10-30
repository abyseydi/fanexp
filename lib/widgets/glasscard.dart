import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color background;
  final Color borderColor;
  final Color shadowColor;

  const GlassCard({
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
