import 'dart:async';
import 'package:flutter/material.dart';

class MatchCountdown extends StatefulWidget {
  final DateTime targetTime;

  const MatchCountdown({super.key, required this.targetTime});

  @override
  State<MatchCountdown> createState() => _MatchCountdownState();
}

class _MatchCountdownState extends State<MatchCountdown> {
  Duration remaining = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _updateCountdown();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final diff = widget.targetTime.difference(now);

    setState(() {
      remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  final days = remaining.inDays;
  final hours = (remaining.inHours % 24).toString().padLeft(2, '0');
  final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "Coup d'envoi dans",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),

      const SizedBox(height: 4),

      Text(
        "${days}j ${hours}h ${minutes}m ${seconds}s",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  );
}

}
