import 'package:fanexp/screens/timeline/controller/timeline_controller.dart';
import 'package:fanexp/screens/timeline/repository/timeline_repository.dart';
import 'package:fanexp/screens/timeline/service/timeline_service.dart';
import 'package:fanexp/screens/timeline/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final repository = TimelineRepository();
        final service = TimelineService(repository);
        return TimelineController(service)..loadPosts();
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Gaïndé',
              style: TextStyle(
                fontFamily: 'Josefin Sans',
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: gaindeInk,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                  color: gaindeInk,
                  size: 26,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: gaindeInk,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: gaindeGreen,
                  indicatorWeight: 2,
                  labelColor: gaindeInk,
                  unselectedLabelColor: gaindeInk.withOpacity(0.4),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                  tabs: const [
                    Tab(text: 'GAÏNDÉ'),
                    Tab(text: 'TRAINING'),
                    Tab(text: 'IA RÉSUMÉS'),
                  ],
                ),
              ),
            ),
          ),
          body: Consumer<TimelineController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: gaindeGreen,
                    strokeWidth: 2,
                  ),
                );
              }

              if (controller.error != null) {
                return _ErrorView(
                  error: controller.error!,
                  onRetry: controller.loadPosts,
                );
              }

              return TabBarView(
                children: [
                  _GaindeFeedTab(controller: controller),
                  const _InsideTrainingTab(),
                  const _AISummariesTab(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GaindeFeedTab extends StatelessWidget {
  final TimelineController controller;

  const _GaindeFeedTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 80,
              color: gaindeInk.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun post disponible',
              style: TextStyle(
                color: gaindeInk.withOpacity(0.4),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les posts apparaîtront ici',
              style: TextStyle(color: gaindeInk.withOpacity(0.3), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadPosts,
      color: gaindeGreen,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 0, bottom: 80),
        itemCount: controller.posts.length,
        itemBuilder: (ctx, i) => PostCard(post: controller.posts[i]),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: gaindeRed),
            const SizedBox(height: 16),
            Text(
              'Oups !',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: gaindeInk,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(color: gaindeInk.withOpacity(0.6), fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Réessayer',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: gaindeGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tabs placeholder
class _InsideTrainingTab extends StatelessWidget {
  const _InsideTrainingTab();
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.fitness_center, size: 64, color: gaindeGreen),
        const SizedBox(height: 16),
        Text(
          'Training',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: gaindeInk,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bientôt disponible',
          style: TextStyle(color: gaindeInk.withOpacity(0.5)),
        ),
      ],
    ),
  );
}

class _AISummariesTab extends StatelessWidget {
  const _AISummariesTab();
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.auto_awesome, size: 64, color: gaindeGold),
        const SizedBox(height: 16),
        Text(
          'IA Résumés',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: gaindeInk,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bientôt disponible',
          style: TextStyle(color: gaindeInk.withOpacity(0.5)),
        ),
      ],
    ),
  );
}
