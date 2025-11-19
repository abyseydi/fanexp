import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onEdit;
  const ProfileHeader({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 360;

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -36),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage('assets/img/avatar.jpg'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Transform.translate(
                        offset: const Offset(0, -20),
                        child: const _NameAndStats(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Modifier'),
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Transform.translate(
                offset: const Offset(0, -36),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/img/avatar.jpg'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: _ShiftedNameAndStats()),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: FilledButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Flexible(
                    child: Text(
                      'Modifier',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ShiftedNameAndStats extends StatelessWidget {
  const _ShiftedNameAndStats();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: const _NameAndStats(),
    );
  }
}

class _NameAndStats extends StatelessWidget {
  const _NameAndStats();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Poulo SEYDI',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        Opacity(
          opacity: .7,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.location_on_outlined, size: 16),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Dakar • SEN',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const _MiniStatsWrap(),
      ],
    );
  }
}

class _MiniStatsWrap extends StatelessWidget {
  const _MiniStatsWrap();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: const [
        _MiniStat(label: 'Badges', value: '12'),
        _MiniStat(label: 'Points', value: '1 480'),
        _MiniStat(label: 'Rang', value: '#27'),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(opacity: .7, child: Text(label)),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}
