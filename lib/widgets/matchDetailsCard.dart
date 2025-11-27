import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'dart:math';


class Player {
  final String name;
  final int number;
  const Player({required this.name, required this.number});
}

class _ProbableXI extends StatelessWidget {
  const _ProbableXI();

  @override
  Widget build(BuildContext context) {
    const xi = <Player>[
      Player(name: 'Mendy', number: 16),
      Player(name: 'Sabaly', number: 21),
      Player(name: 'Koulibaly', number: 3),
      Player(name: 'Diallo', number: 22),
      Player(name: 'Jakobs', number: 14),
      Player(name: 'Gueye', number: 5),
      Player(name: 'M. Mendy', number: 6),
      Player(name: 'Ndiaye', number: 13),
      Player(name: 'Sarr', number: 18),
      Player(name: 'Dia', number: 9),
      Player(name: 'Mané', number: 10),
    ];

    const bench = <Player>[
      Player(name: 'Dieng', number: 1),
      Player(name: 'Ciss', number: 2),
      Player(name: 'Sima', number: 11),
      Player(name: 'N. Jackson', number: 21),
      Player(name: 'L. Diatta', number: 15),
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.list_alt_rounded,
            title: 'Compo probable (4-3-3)',
          ),
          const SizedBox(height: 8),
          _PitchGrid(players: xi),
          const SizedBox(height: 12),
          const Text('Banc', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: bench
                .map((p) => Chip(label: Text('${p.number} • ${p.name}')))
                .toList(),
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
        Icon(icon, color: gaindeGreen),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _PitchGrid extends StatelessWidget {
  final List<Player> players;
  const _PitchGrid({required this.players});

  @override
  Widget build(BuildContext context) {
    final rows = [
      [players[0]],
      [players[1], players[2], players[3], players[4]],
      [players[5], players[6], players[7]],
      [players[8], players[9], players[10]],
    ];

    const rowY = [0.10, 0.33, 0.59, 0.84];

    final chips = <Widget>[];
    for (int i = 0; i < rows.length; i++) {
      final line = rows[i];
      final y = rowY[i];
      for (int j = 0; j < line.length; j++) {
        final x = (j + 1) / (line.length + 1);
        chips.add(
          Align(
            alignment: Alignment(x * 2 - 1, y * 2 - 1),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: SizedBox(),
            ),
          ),
        );
        chips[chips.length - 1] = Align(
          alignment: Alignment(x * 2 - 1, y * 2 - 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: _PlayerChip(player: line[j]),
          ),
        );
      }
    }

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(painter: _PitchPainter()),
            ...chips,
          ],
        ),
      ),
    );
  }
}

class _PlayerChip extends StatelessWidget {
  final Player player;
  const _PlayerChip({required this.player});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 92),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${player.number}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                height: 1.0,
                fontWeight: FontWeight.w900,
                color: gaindeInk,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: gaindeInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  const _PitchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final grass1 = const Color(0xFF5BAF5C);
    final grass2 = const Color(0xFF4CA956);
    final stripeH = size.height / 10;
    for (int i = 0; i < 10; i++) {
      final p = Paint()..color = (i % 2 == 0) ? grass1 : grass2;
      canvas.drawRect(Rect.fromLTWH(0, i * stripeH, size.width, stripeH), p);
    }

    final line = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.012;

    final margin = size.width * 0.04;
    final field = Rect.fromLTWH(
      margin,
      margin,
      size.width - 2 * margin,
      size.height - 2 * margin,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(field, const Radius.circular(12)),
      line,
    );

    final midY = field.top + field.height / 2;
    canvas.drawLine(Offset(field.left, midY), Offset(field.right, midY), line);

    final center = field.center;
    final centerRadius = field.width * 0.12;
    canvas.drawCircle(center, centerRadius, line);
    canvas.drawCircle(
      center,
      line.strokeWidth * 0.6,
      Paint()..color = Colors.white,
    );

    final areaW = field.width * 0.5;
    final areaH = field.height * 0.18;
    final smallAreaW = field.width * 0.3;
    final smallAreaH = field.height * 0.08;
    final goalDepth = field.height * 0.02;
    final arcR = field.width * 0.12;

    final topBig = Rect.fromLTWH(
      center.dx - areaW / 2,
      field.top,
      areaW,
      areaH,
    );
    final topSmall = Rect.fromLTWH(
      center.dx - smallAreaW / 2,
      field.top,
      smallAreaW,
      smallAreaH,
    );
    canvas.drawRect(topBig, line);
    canvas.drawRect(topSmall, line);
    final topPK = Offset(center.dx, field.top + areaH * 0.6);
    canvas.drawCircle(
      topPK,
      line.strokeWidth * 0.6,
      Paint()..color = Colors.white,
    );
    final topArcRect = Rect.fromCircle(
      center: Offset(center.dx, field.top + areaH),
      radius: arcR,
    );
    canvas.drawArc(topArcRect, 0.0, pi, false, line);
    final topGoal = Rect.fromLTWH(
      center.dx - field.width * 0.18 / 2,
      field.top - goalDepth,
      field.width * 0.18,
      goalDepth,
    );
    canvas.drawRect(topGoal, line);

    final bottomBig = Rect.fromLTWH(
      center.dx - areaW / 2,
      field.bottom - areaH,
      areaW,
      areaH,
    );
    final bottomSmall = Rect.fromLTWH(
      center.dx - smallAreaW / 2,
      field.bottom - smallAreaH,
      smallAreaW,
      smallAreaH,
    );
    canvas.drawRect(bottomBig, line);
    canvas.drawRect(bottomSmall, line);
    final botPK = Offset(center.dx, field.bottom - areaH * 0.6);
    canvas.drawCircle(
      botPK,
      line.strokeWidth * 0.6,
      Paint()..color = Colors.white,
    );
    final botArcRect = Rect.fromCircle(
      center: Offset(center.dx, field.bottom - areaH),
      radius: arcR,
    );
    canvas.drawArc(botArcRect, pi, pi, false, line);
    final bottomGoal = Rect.fromLTWH(
      center.dx - field.width * 0.18 / 2,
      field.bottom,
      field.width * 0.18,
      goalDepth,
    );
    canvas.drawRect(bottomGoal, line);

    final cornerR = field.width * 0.03;
    void cornerArc(Offset c, double startAngle) {
      final rr = Rect.fromCircle(center: c, radius: cornerR);
      canvas.drawArc(rr, startAngle, pi / 2, false, line);
    }

    cornerArc(Offset(field.left, field.top), 0);
    cornerArc(Offset(field.right, field.top), pi / 2);
    cornerArc(Offset(field.right, field.bottom), pi);
    cornerArc(Offset(field.left, field.bottom), 3 * pi / 2);
  }

  @override
  bool shouldRepaint(covariant _PitchPainter oldDelegate) => false;
}



class MatchDetailsCard extends StatelessWidget {
  const MatchDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du match"),
      ),
      body: ListView(
        children: [
          const _ProbableXI()
        ],
      ),
    
    );
  }
}
