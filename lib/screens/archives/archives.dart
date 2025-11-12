import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';

class ArchivesEphemeridesPage extends StatefulWidget {
  const ArchivesEphemeridesPage({super.key});

  @override
  State<ArchivesEphemeridesPage> createState() =>
      _ArchivesEphemeridesPageState();
}

class _ArchivesEphemeridesPageState extends State<ArchivesEphemeridesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _repo = _Repo();

  String _query = '';
  String? _category;
  int? _year;

  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final years = _repo.availableYears;
    final categories = _repo.availableCategories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archives & Éphémérides'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: gaindeGreen,
          labelColor: gaindeInk,
          tabs: const [
            Tab(text: 'Archives'),
            Tab(text: 'Éphémérides'),
          ],
        ),
      ),

      floatingActionButton: _ChatFloatingButton(
        onOpen: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const _ChatbotSheet(),
          );
        },
      ),

      body: TabBarView(
        controller: _tab,
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    children: [
                      _SearchField(
                        hint: 'Rechercher un titre, un mot-clé…',
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      const SizedBox(height: 10),
                      _FilterRow(
                        years: years,
                        categories: categories,
                        selectedYear: _year,
                        selectedCategory: _category,
                        onYearTap: (y) =>
                            setState(() => _year = (_year == y) ? null : y),
                        onCategoryTap: (c) => setState(
                          () => _category = (_category == c) ? null : c,
                        ),
                        onReset: () => setState(() {
                          _year = null;
                          _category = null;
                          _query = '';
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: _repo
                    .filterArchives(
                      query: _query,
                      category: _category,
                      year: _year,
                    )
                    .length,
                itemBuilder: (_, i) {
                  final item = _repo.filterArchives(
                    query: _query,
                    category: _category,
                    year: _year,
                  )[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: _ArchiveCard(
                      item: item,
                      onOpen: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _ArchiveDetailsPage(item: item),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),

          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ce jour-là…',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: gaindeInk,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _fmtDay(_selectedDay),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: gaindeInk,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Changer la date',
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDay,
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (picked != null) {
                                  setState(() => _selectedDay = picked);
                                }
                              },
                              icon: const Icon(Icons.event_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: _EphemerisTimeline(
                    events: _repo.eventsForDay(
                      month: _selectedDay.month,
                      day: _selectedDay.day,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  child: _MonthArchiveSuggest(
                    month: _selectedDay.month,
                    archives: _repo.archivesForMonth(_selectedDay.month),
                    onOpen: (it) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => _ArchiveDetailsPage(item: it),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmtDay(DateTime d) {
    const months = [
      'janv.',
      'févr.',
      'mars',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sept.',
      'oct.',
      'nov.',
      'déc.',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final List<int> years;
  final List<String> categories;
  final int? selectedYear;
  final String? selectedCategory;
  final ValueChanged<int> onYearTap;
  final ValueChanged<String> onCategoryTap;
  final VoidCallback onReset;

  const _FilterRow({
    required this.years,
    required this.categories,
    required this.selectedYear,
    required this.selectedCategory,
    required this.onYearTap,
    required this.onCategoryTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilterChip(
          label: const Text('Réinitialiser'),
          onSelected: (_) => onReset(),
          side: const BorderSide(color: gaindeInk, width: .2),
        ),
        ...years.map(
          (y) => ChoiceChip(
            label: Text('$y'),
            selected: selectedYear == y,
            onSelected: (_) => onYearTap(y),
            selectedColor: gaindeGreen.withOpacity(.12),
            side: BorderSide(
              color: (selectedYear == y ? gaindeGreen : gaindeInk).withOpacity(
                .25,
              ),
            ),
            labelStyle: TextStyle(
              color: selectedYear == y ? gaindeGreen : gaindeInk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...categories.map(
          (c) => ChoiceChip(
            label: Text(c),
            selected: selectedCategory == c,
            onSelected: (_) => onCategoryTap(c),
            selectedColor: gaindeGold.withOpacity(.12),
            side: BorderSide(
              color: (selectedCategory == c ? gaindeGold : gaindeInk)
                  .withOpacity(.25),
            ),
            labelStyle: TextStyle(
              color: selectedCategory == c ? gaindeGold : gaindeInk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  final ArchiveItem item;
  final VoidCallback onOpen;
  const _ArchiveCard({required this.item, required this.onOpen});

  IconData _iconForType(String type) {
    return switch (type.toLowerCase()) {
      'pdf' || 'document' || 'rapport' => Icons.picture_as_pdf_rounded,
      'communiqué' || 'article' => Icons.newspaper_rounded,
      'photo' || 'image' => Icons.image_outlined,
      'données' || 'csv' || 'xlsx' => Icons.table_chart_rounded,
      _ => Icons.insert_drive_file_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: gaindeGreenSoft,
              child: Icon(_iconForType(item.type), color: gaindeGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: gaindeInk,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Opacity(
                    opacity: .8,
                    child: Text(
                      '${item.category} • ${item.date.year}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _ArchiveDetailsPage extends StatelessWidget {
  final ArchiveItem item;
  const _ArchiveDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: gaindeInk,
                ),
              ),
              const SizedBox(height: 6),
              Opacity(
                opacity: .8,
                child: Text(
                  '${item.category} • ${item.type} • ${item.date.year}',
                ),
              ),
              const SizedBox(height: 10),
              Text(item.description ?? '—', textAlign: TextAlign.start),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ouverture du fichier…')),
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Ouvrir la pièce'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EphemerisTimeline extends StatelessWidget {
  final List<EphemerisEvent> events;
  const _EphemerisTimeline({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return GlassCard(
        child: Row(
          children: const [
            Icon(Icons.info_outline_rounded, color: gaindeInk),
            SizedBox(width: 8),
            Expanded(
              child: Text('Aucun événement ce jour-là dans les archives.'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: events
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DotYear(year: e.date.year),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: gaindeInk,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Opacity(
                            opacity: .8,
                            child: Text(e.description ?? '—'),
                          ),
                          if (e.archive != null) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          _ArchiveDetailsPage(item: e.archive!),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.link_rounded, size: 18),
                                label: const Text('Voir l’archive liée'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DotYear extends StatelessWidget {
  final int year;
  const _DotYear({required this.year});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: gaindeGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text('$year', style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _MonthArchiveSuggest extends StatelessWidget {
  final int month;
  final List<ArchiveItem> archives;
  final ValueChanged<ArchiveItem> onOpen;

  const _MonthArchiveSuggest({
    required this.month,
    required this.archives,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (archives.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Archives du mois',
          style: TextStyle(fontWeight: FontWeight.w800, color: gaindeInk),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: archives.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => SizedBox(
              width: 260,
              child: _ArchiveCard(
                item: archives[i],
                onOpen: () => onOpen(archives[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArchiveItem {
  final String id;
  final String title;
  final String category;
  final String type;
  final DateTime date;
  final String? description;
  final String? fileUrl;
  const ArchiveItem({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.date,
    this.description,
    this.fileUrl,
  });
}

class EphemerisEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final ArchiveItem? archive;
  const EphemerisEvent({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    this.archive,
  });
}

class _Repo {
  final _archives = <ArchiveItem>[
    ArchiveItem(
      id: 'a1',
      title: 'Communiqué — Lancement FanExp',
      category: 'Communiqué',
      type: 'article',
      date: DateTime(2023, 11, 4),
      description: 'Annonce officielle du lancement de la plateforme FanExp.',
      fileUrl: null,
    ),
    ArchiveItem(
      id: 'a2',
      title: 'Rapport annuel 2024',
      category: 'Rapport',
      type: 'pdf',
      date: DateTime(2024, 3, 15),
      description: 'Bilan des activités et performances.',
    ),
    ArchiveItem(
      id: 'a3',
      title: 'Données billetterie T1 2025',
      category: 'Données',
      type: 'csv',
      date: DateTime(2025, 1, 31),
      description: 'Export CSV ventes & affluence.',
    ),
    ArchiveItem(
      id: 'a4',
      title: 'Album photos — Match Sénégal vs Brésil',
      category: 'Photo',
      type: 'image',
      date: DateTime(2022, 11, 4),
      description: 'Sélection des meilleurs clichés.',
    ),
  ];

  final _events = <EphemerisEvent>[];

  _Repo() {
    final a1 = _archives.firstWhere((x) => x.id == 'a1');
    final a4 = _archives.firstWhere((x) => x.id == 'a4');
    _events.addAll([
      EphemerisEvent(
        id: 'e1',
        title: 'Signature du partenariat FanExp',
        description: 'Accord stratégique pour la fan-experience.',
        date: DateTime(2021, 11, 4),
        archive: a1,
      ),
      EphemerisEvent(
        id: 'e2',
        title: 'Victoire 2-1 vs Brésil',
        description: 'Match amical — ambiance exceptionnelle.',
        date: DateTime(2022, 11, 4),
        archive: a4,
      ),
      EphemerisEvent(
        id: 'e3',
        title: 'Ouverture boutique officielle',
        description: 'Lancement des produits dérivés.',
        date: DateTime(2020, 11, 4),
      ),
    ]);
  }

  List<int> get availableYears =>
      _archives.map((a) => a.date.year).toSet().toList()
        ..sort((a, b) => b.compareTo(a));

  List<String> get availableCategories =>
      _archives.map((a) => a.category).toSet().toList()..sort();

  List<ArchiveItem> filterArchives({
    String? query,
    String? category,
    int? year,
  }) {
    Iterable<ArchiveItem> it = _archives;
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      it = it.where(
        (a) =>
            a.title.toLowerCase().contains(q) ||
            (a.description ?? '').toLowerCase().contains(q),
      );
    }
    if (category != null) {
      it = it.where((a) => a.category == category);
    }
    if (year != null) {
      it = it.where((a) => a.date.year == year);
    }
    return it.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  List<EphemerisEvent> eventsForDay({required int month, required int day}) {
    return _events
        .where((e) => e.date.month == month && e.date.day == day)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<ArchiveItem> archivesForMonth(int month) {
    return _archives.where((a) => a.date.month == month).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}

class _ChatFloatingButton extends StatelessWidget {
  final VoidCallback onOpen;
  const _ChatFloatingButton({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onOpen,
      label: const Text('Aide'),
      icon: const Icon(Icons.chat_bubble_outline_rounded),
      backgroundColor: gaindeGreen,
      foregroundColor: Colors.white,
      extendedIconLabelSpacing: 6,
    );
  }
}

class _ChatbotSheet extends StatefulWidget {
  const _ChatbotSheet();

  @override
  State<_ChatbotSheet> createState() => _ChatbotSheetState();
}

class _ChatbotSheetState extends State<_ChatbotSheet> {
  final _controller = _SimpleChatController();
  final _scrollCtrl = ScrollController();
  final _inputCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _controller.addUser(text);
    _inputCtrl.clear();
    _jumpToBottomSoon();

    final reply = await _controller.getAssistantReply(text);

    _controller.addAssistant(reply);
    _jumpToBottomSoon();
    if (mounted) setState(() => _sending = false);
  }

  void _jumpToBottomSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sheet = DraggableScrollableSheet(
      initialChildSize: 0.82,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: gaindeGreen.withOpacity(.15),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: gaindeGreen,
                  ),
                ),
                title: const Text(
                  'GG Assistant',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: const Text(
                  'Archives, éphémérides, billetterie, aide…',
                ),
                trailing: IconButton(
                  tooltip: 'Fermer',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  itemCount: _controller.messages.length,
                  itemBuilder: (_, i) {
                    final m = _controller.messages[i];
                    final isMe = m.role == ChatRole.user;
                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 420),
                        decoration: BoxDecoration(
                          color: isMe
                              ? gaindeGreen.withOpacity(.12)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: (isMe ? gaindeGreen : gaindeInk).withOpacity(
                              .18,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(m.text, style: const TextStyle(height: 1.35)),
                            const SizedBox(height: 4),
                            Opacity(
                              opacity: .6,
                              child: Text(
                                _fmtTime(m.timestamp),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_sending)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [SizedBox(width: 16), _TypingDots()],
                  ),
                ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _inputCtrl,
                          minLines: 1,
                          maxLines: 6,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: 'Pose ta question…',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: gaindeInk.withOpacity(.18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _sending ? null : _send,
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(gaindeGreen),
                        ),
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        tooltip: 'Envoyer',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    return sheet;
  }

  String _fmtTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
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
      builder: (_, __) {
        final v = _c.value;
        double o1 = (v < .33) ? 1 : .3;
        double o2 = (v >= .33 && v < .66) ? 1 : .3;
        double o3 = (v >= .66) ? 1 : .3;
        return Row(
          children: [
            _dot(o1),
            const SizedBox(width: 4),
            _dot(o2),
            const SizedBox(width: 4),
            _dot(o3),
          ],
        );
      },
    );
  }

  Widget _dot(double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: gaindeInk,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;
  final DateTime timestamp;
  ChatMessage(this.role, this.text) : timestamp = DateTime.now();
}

class _SimpleChatController {
  final List<ChatMessage> messages = [
    ChatMessage(
      ChatRole.assistant,
      'Bonjour 👋 Je peux t’aider à retrouver une archive, un match dans les éphémérides, ou t’orienter dans l’app.',
    ),
  ];

  void addUser(String text) {
    messages.add(ChatMessage(ChatRole.user, text));
  }

  void addAssistant(String text) {
    messages.add(ChatMessage(ChatRole.assistant, text));
  }

  Future<String> getAssistantReply(String userText) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final lower = userText.toLowerCase();

    if (lower.contains('archive') ||
        lower.contains('rapport') ||
        lower.contains('pdf')) {
      return "Tu peux filtrer par **Année** et **Catégorie** en haut. Tape un mot-clé (ex: *rapport billetterie*). Besoin que je te pré-filtre ?";
    }
    if (lower.contains('éphém') ||
        lower.contains('date') ||
        lower.contains('aujourd')) {
      return "Dans l’onglet **Éphémérides**, choisis une date (icône calendrier). Je peux aussi te dire les événements du jour.";
    }
    if (lower.contains('billet') ||
        lower.contains('stade') ||
        lower.contains('prix')) {
      return "Billetterie ➜ choisis une **catégorie** (VIP, Cat.1, Cat.2…), puis ta **tribune**. Je peux calculer le total selon la quantité.";
    }
    if (lower.contains('bug') ||
        lower.contains('probl') ||
        lower.contains('erreur')) {
      return "Désolé pour ça 😅 Peux-tu me dire l’écran et ce qui ne marche pas ? Je te propose une correction.";
    }

    return "Compris. Précise si c’est pour *Archives*, *Éphémérides* ou *Billetterie*, et je t’accompagne pas à pas.";
  }
}
