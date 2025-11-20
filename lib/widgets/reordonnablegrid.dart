import 'package:fanexp/screens/fanzone/fanprofile.dart' hide gaindeInk;
import 'package:fanexp/screens/home/homepage.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ModulesGridReorderable extends StatefulWidget {
  final List<ModuleTileData> tiles;
  final String prefsKey; // ex: 'modules_order_v1'

  const ModulesGridReorderable({
    required this.tiles,
    this.prefsKey = 'modules_order_v1',
  });

  @override
  State<ModulesGridReorderable> createState() => ModulesGridReorderableState();
}

class ModulesGridReorderableState extends State<ModulesGridReorderable> {
  late List<ModuleTileData> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.tiles);
    _restoreOrder();
  }

  Future<void> _restoreOrder() async {
    final sp = await SharedPreferences.getInstance();
    final saved = sp.getStringList(widget.prefsKey);
    if (saved == null || saved.isEmpty) return;

    final byId = {for (final t in widget.tiles) t.id: t};
    final restored = <ModuleTileData>[];

    for (final id in saved) {
      final t = byId[id];
      if (t != null) restored.add(t);
    }
    // Ajoute d’éventuels nouveaux items non encore sauvés
    for (final t in widget.tiles) {
      if (!restored.any((x) => x.id == t.id)) restored.add(t);
    }

    setState(() => _items = restored);
  }

  Future<void> _saveOrder() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(widget.prefsKey, _items.map((e) => e.id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, cons) {
        // même logique que ta grille d’origine
        const target = 138.0;
        int cols = (cons.maxWidth / target).floor().clamp(2, 4);
        if (cons.maxWidth > 950) cols = 5;

        return ReorderableGridView.count(
          // IMPORTANT: la grille ne doit pas scroller (tu es dans un CustomScrollView)
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 1.05,
          dragWidgetBuilder: (index, child) {
            // petit effet visuel pendant le drag
            return Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(16),
              child: child,
            );
          },
          onReorder: (oldIndex, newIndex) async {
            setState(() {
              final item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);
            });
            await _saveOrder();
          },
          children: [
            for (final item in _items)
              _DraggableModuleTile(key: ValueKey(item.id), data: item),
          ],
        );
      },
    );
  }
}

/// Tu peux garder ton _ModuleTile tel quel.
/// Ici, on ajoute juste un petit “handle” visuel (≡) pour indiquer que c’est déplaçable.
class _DraggableModuleTile extends StatelessWidget {
  final ModuleTileData data;
  const _DraggableModuleTile({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ta tuile existante
        Positioned.fill(child: _ModuleTile(data: data)),
        // poignée de drag en haut à droite (optionnelle)
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.28),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.drag_indicator_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final ModuleTileData data;
  const _ModuleTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final accent = data.accent ?? Colors.black.withOpacity(.28);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: data.onTap,
      child: GlassCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image plein cadre
              Image.asset(
                data.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: gaindeLine,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined, color: gaindeInk),
                ),
              ),
              // Voile dégradé pour lisibilité du label
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x40000000),
                      Color(0x66000000),
                    ],
                  ),
                ),
              ),
              // Contour léger à la couleur d’accent (optionnel)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: accent.withOpacity(.35)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              // Label en bas
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Text(
                  data.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
                  ),
                ),
              ),
              // Ripple propre
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(onTap: data.onTap),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
