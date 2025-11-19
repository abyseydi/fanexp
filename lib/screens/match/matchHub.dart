import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';

class MatchHub extends StatelessWidget {
  const MatchHub({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Match'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Match du jour'),
              Tab(text: 'Live'),
              Tab(text: 'Stats post-match'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_MatchOfTheDayTab(), _LiveTab(), _PostMatchStatsTab()],
        ),
      ),
    );
  }
}

class Player {
  final String name;
  final int number;
  const Player({required this.name, required this.number});
}

class _MatchOfTheDayTab extends StatelessWidget {
  const _MatchOfTheDayTab();

  @override
  Widget build(BuildContext context) {
    final kickoff = DateTime.now().add(const Duration(hours: 2, minutes: 30));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const _MatchHeader(),
        const SizedBox(height: 12),
        _KickoffTile(kickoff: kickoff),
        const SizedBox(height: 12),
        const _ProbableXI(),
        const SizedBox(height: 12),
        const _CoachNotes(),
        const SizedBox(height: 12),
        const _QuickActionsRow(),
      ],
    );
  }
}

class _MatchHeader extends StatelessWidget {
  const _MatchHeader();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          _TeamBadge(name: 'Sénégal', flagAsset: 'assets/img/senegal.png'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: gaindeGold.withOpacity(.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: gaindeGold.withOpacity(.35)),
            ),
            child: const Text(
              'Amical',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const Spacer(),
          _TeamBadge(name: 'Brésil', flagAsset: 'assets/img/bresil.png'),
        ],
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String name;
  final String flagAsset;
  const _TeamBadge({required this.name, required this.flagAsset});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundImage: AssetImage(flagAsset)),
        const SizedBox(width: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _KickoffTile extends StatelessWidget {
  final DateTime kickoff;
  const _KickoffTile({required this.kickoff});

  String _fmt(Duration d) {
    if (d.isNegative) return 'En approche';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final remain = kickoff.difference(DateTime.now());
    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Coup d’envoi dans ${_fmt(remain)} • ${kickoff.hour.toString().padLeft(2, '0')}:${kickoff.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Alerte'),
          ),
        ],
      ),
    );
  }
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

class _CoachNotes extends StatelessWidget {
  const _CoachNotes();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SectionTitle(icon: Icons.note_alt_outlined, title: 'Notes staff'),
          SizedBox(height: 8),
          _Bullet('Bloc médian compact, déclenchement pressing couloir droit.'),
          _Bullet('Transitions offensives rapides après récupération haute.'),
          _Bullet('CPA : variations 1er/2e poteau testées.'),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GlassCard(
      child: Row(
        children: [
          _QuickAction(
            icon: Icons.confirmation_num_outlined,
            label: 'Billetterie',
            color: cs.primary,
          ),
          const SizedBox(width: 12),
          _QuickAction(
            icon: Icons.bar_chart_rounded,
            label: 'Classement',
            color: gaindeInk,
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: color.withOpacity(.08),
            border: Border.all(color: color.withOpacity(.25)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
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

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.fiber_manual_record, size: 10, color: gaindeGreen),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _LiveTab extends StatelessWidget {
  const _LiveTab();

  @override
  Widget build(BuildContext context) {
    final events = const [
      _LiveEvent(minute: 12, type: 'Occasion', text: 'Sarr frappe – arrêté'),
      _LiveEvent(minute: 31, type: 'But', text: 'Dia (SEN) 1–0'),
      _LiveEvent(minute: 54, type: 'Carton', text: 'Jaune pour Hakimi'),
      _LiveEvent(minute: 70, type: 'xG élevé', text: 'Mané face à face (0.35)'),
    ];

    final xgSenegal = [0.05, 0.12, 0.20, 0.35, 0.40, 0.55, 0.65];
    final xgAdverse = [0.02, 0.06, 0.10, 0.12, 0.20, 0.27, 0.35];

    final momentum = [0.2, 0.4, 0.5, 0.7, 0.45, 0.2, -0.1, 0.1, 0.6, 0.8, 0.3];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.flash_on_rounded,
                title: 'Événements',
              ),
              const SizedBox(height: 8),
              for (final e in events) _EventTile(e: e),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.bar_chart,
                title: 'xG live (cumulé)',
              ),
              const SizedBox(height: 12),
              _XgBars(senegal: xgSenegal.last, opponent: xgAdverse.last),
              const SizedBox(height: 8),
              Text(
                'SEN ${xgSenegal.last.toStringAsFixed(2)} — ${xgAdverse.last.toStringAsFixed(2)} OPP',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: xgSenegal,
                    color: gaindeGreen,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 80,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: xgAdverse,
                    color: gaindeRed,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.stacked_line_chart,
                title: 'Momentum',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: CustomPaint(
                  painter: _MomentumPainter(values: momentum),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 6),
              const Text('>0 domination Sénégal • <0 domination adverse'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiveEvent {
  final int minute;
  final String type;
  final String text;
  const _LiveEvent({
    required this.minute,
    required this.type,
    required this.text,
  });
}

class _EventTile extends StatelessWidget {
  final _LiveEvent e;
  const _EventTile({required this.e});

  IconData _icon() {
    switch (e.type) {
      case 'But':
        return Icons.sports_soccer;
    }
    if (e.type.toLowerCase().contains('carton')) {
      return Icons.warning_amber_rounded;
    }
    if (e.type.toLowerCase().contains('xg')) return Icons.bolt_rounded;
    return Icons.event;
  }

  Color _color() {
    if (e.type == 'But') return gaindeGreen;
    if (e.type.toLowerCase().contains('carton')) return gaindeGold;
    if (e.type.toLowerCase().contains('xg')) return gaindeRed;
    return gaindeInk;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: _color().withOpacity(.12),
        child: Icon(_icon(), color: _color(), size: 18),
      ),
      title: Text(e.text, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text("${e.minute}'"),
    );
  }
}

class _XgBars extends StatelessWidget {
  final double senegal;
  final double opponent;
  const _XgBars({required this.senegal, required this.opponent});

  @override
  Widget build(BuildContext context) {
    final total = (senegal + opponent).clamp(0.0001, 999.0);
    final s = (senegal / total).clamp(.0, 1.0);
    final o = 1 - s;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 14,
        child: Row(
          children: [
            Expanded(
              flex: (s * 1000).round(),
              child: Container(color: gaindeGreen),
            ),
            Expanded(
              flex: (o * 1000).round(),
              child: Container(color: gaindeRed),
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

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final range = (maxV - minV).abs() < 1e-6 ? 1.0 : (maxV - minV);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - (values[i] - minV) / range);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final area = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}

class _MomentumPainter extends CustomPainter {
  final List<double> values;
  _MomentumPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axis,
    );

    if (values.isEmpty) return;
    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (0.5 - 0.5 * values[i].clamp(-1, 1));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..color = gaindeGreen
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final area = Path.from(path)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height / 2)
      ..close();
    final fill = Paint()
      ..shader = LinearGradient(
        colors: [gaindeGreen.withOpacity(.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(area, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MomentumPainter old) => old.values != values;
}

class _PostMatchStatsTab extends StatelessWidget {
  const _PostMatchStatsTab();

  @override
  Widget build(BuildContext context) {
    final heat = List.generate(
      10,
      (x) => List.generate(7, (y) {
        final dx = (x - 7).abs().toDouble();
        final dy = (y - 3).abs().toDouble();
        return (1.2 - (dx + dy) / 12).clamp(0.0, 1.0);
      }),
    );

    final sen = [0.72, 0.64, 0.58, 0.80, 0.66];
    final opp = [0.45, 0.40, 0.52, 0.35, 0.48];

    final keyPasses = const [
      ('Mané', 'Sarr', "Passe clé dans le demi-espace droit"),
      ('Ndiaye', 'Dia', "Remise et frappe en pivot"),
      ('Jakobs', 'Mané', "Centre tendu au second poteau"),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.local_fire_department_outlined,
                title: 'Heatmap (SEN)',
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 3 / 4,
                child: CustomPaint(
                  painter: _HeatmapPainter(heat),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.alt_route_rounded,
                title: 'Passes clés',
              ),
              const SizedBox(height: 8),
              for (final (from, to, desc) in keyPasses)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.arrow_right_alt_rounded,
                    color: gaindeGreen,
                  ),
                  title: Text(
                    '$from → $to',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(desc),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(
                icon: Icons.pentagon_outlined,
                title: 'Radar comparatif',
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: _RadarPainter(sen: sen, opp: opp),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 6),
              const Wrap(
                spacing: 12,
                children: [
                  _LegendDot(color: gaindeGreen, label: 'SEN'),
                  _LegendDot(color: gaindeRed, label: 'OPP'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  final List<List<double>> v;
  _HeatmapPainter(this.v);

  @override
  void paint(Canvas canvas, Size size) {
    final cols = v.length;
    final rows = v[0].length;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    final border = Paint()
      ..color = gaindeInk.withOpacity(.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(14),
      ),
      border,
    );

    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        final val = v[x][y];
        final color = Color.lerp(Colors.white, gaindeRed, val)!.withOpacity(.9);
        final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(x * cellW + 1, y * cellH + 1, cellW - 2, cellH - 2),
          const Radius.circular(6),
        );
        final p = Paint()..color = color;
        canvas.drawRRect(r, p);
      }
    }
    final mid = Paint()
      ..color = gaindeInk.withOpacity(.15)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      mid,
    );
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter old) => true;
}

class _RadarPainter extends CustomPainter {
  final List<double> sen;
  final List<double> opp;
  _RadarPainter({required this.sen, required this.opp});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide * .38;
    final n = sen.length;
    final angles = List.generate(n, (i) => -90.0 + i * 360.0 / n);

    Offset pt(double radius, double deg) {
      final rad = deg * 3.14159265 / 180.0;
      return Offset(
        center.dx + radius * cos(rad),
        center.dy + radius * sin(rad),
      );
    }

    final grid = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke;
    for (int k = 1; k <= 4; k++) {
      final rr = r * k / 4;
      final path = Path();
      for (int i = 0; i < n; i++) {
        final p = pt(rr, angles[i]);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, grid);
    }

    final axis = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1;
    for (int i = 0; i < n; i++) {
      canvas.drawLine(center, pt(r, angles[i]), axis);
    }

    Path poly(List<double> vals, Color c) {
      final path = Path();
      for (int i = 0; i < n; i++) {
        final p = pt(r * vals[i].clamp(0, 1), angles[i]);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      final fill = Paint()..color = c.withOpacity(.22);
      final stroke = Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
      return path;
    }

    poly(sen, gaindeGreen);
    poly(opp, gaindeRed);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) => true;
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
