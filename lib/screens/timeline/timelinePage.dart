import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_detail_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';
import 'package:fanexp/screens/timeline/service/impl/timeline_service.dart';
import 'package:fanexp/widgets/gaindeAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TimeLineService _service = TimeLineService();
  List<PostEntity> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final posts = await _service.getAllPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: gaindeBg,
        appBar: const GaindeAppBar(title: 'Timeline'),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: gaindeGreen))
            : _error != null
            ? _ErrorView(error: _error!, onRetry: _loadPosts)
            : TabBarView(
                children: [
                  _GaindeFeedTab(posts: _posts, onRefresh: _loadPosts),
                  const _InsideTrainingTab(),
                  const _AISummariesTab(),
                ],
              ),
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
            const Icon(Icons.error_outline, size: 64, color: gaindeRed),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: FilledButton.styleFrom(backgroundColor: gaindeGreen),
            ),
          ],
        ),
      ),
    );
  }
}

class _GaindeFeedTab extends StatelessWidget {
  final List<PostEntity> posts;
  final Future<void> Function() onRefresh;

  const _GaindeFeedTab({required this.posts, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun post disponible',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: gaindeGreen,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (ctx, i) => _PostCard(post: posts[i]),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final PostEntity post;

  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  late PostEntity _currentPost;
  final TimeLineService _service = TimeLineService();
  bool _isLiking = false;
  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnim;

  @override
  void initState() {
    super.initState();
    _currentPost = widget.post;
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

  Future<void> _handleLike() async {
    if (_isLiking) return;

    setState(() => _isLiking = true);

    final wasLiked = _currentPost.utilisateurADejalike;

    // Animation optimiste
    setState(() {
      _currentPost = _currentPost.copyWith(
        utilisateurADejalike: !wasLiked,
        nbrLikes: wasLiked
            ? _currentPost.nbrLikes - 1
            : _currentPost.nbrLikes + 1,
      );
    });

    _likeAnimController.forward().then((_) => _likeAnimController.reverse());

    try {
      await _service.toggleLike(_currentPost.id);
    } catch (e) {
      // Rollback en cas d'erreur
      setState(() {
        _currentPost = _currentPost.copyWith(
          utilisateurADejalike: wasLiked,
          nbrLikes: wasLiked
              ? _currentPost.nbrLikes + 1
              : _currentPost.nbrLikes - 1,
        );
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors du like'),
            backgroundColor: gaindeRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isLiking = false);
    }
  }

  void _handleComment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PostDetailPage(postId: _currentPost.id),
      ),
    );
  }

  void _handleShare() {
    Share.share(
      '${_currentPost.title}\n\n${_currentPost.description}\n\n📸 Via Gaïndé App',
      subject: _currentPost.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final timeAgo = timeago.format(_currentPost.dateCreation, locale: 'fr');

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [gaindeGold, gaindeGreen],
                  ),
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: gaindeBg,
                  child: Icon(Icons.shield, color: gaindeGold, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _currentPost.auteurUsername,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: gaindeGreen,
                          size: 16,
                        ),
                      ],
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(.55),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showOptions(context),
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Titre et description
          if (_currentPost.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                _currentPost.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (_currentPost.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _currentPost.description,
                style: TextStyle(
                  color: cs.onSurface.withOpacity(.85),
                  height: 1.4,
                ),
              ),
            ),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(
                _currentPost.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: gaindeGreenSoft,
                  child: const Icon(Icons.image_not_supported, size: 48),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: gaindeGreenSoft,
                    child: const Center(
                      child: CircularProgressIndicator(color: gaindeGreen),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Stats (likes, comments, shares)
          Row(
            children: [
              _StatChip(
                icon: Icons.favorite,
                count: _currentPost.nbrLikes,
                color: gaindeRed,
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.chat_bubble,
                count: _currentPost.nbrComments,
                color: gaindeGreen,
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.share,
                count: _currentPost.nbrShares,
                color: gaindeGold,
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: _currentPost.utilisateurADejalike
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: 'J\'aime',
                  color: _currentPost.utilisateurADejalike ? gaindeRed : null,
                  onTap: _handleLike,
                  scale: _likeScaleAnim,
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Commenter',
                  onTap: _handleComment,
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Partager',
                  onTap: _handleShare,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: gaindeBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_border, color: gaindeGreen),
              title: const Text('Enregistrer'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: gaindeRed),
              title: const Text('Signaler'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  final Animation<double>? scale;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final btnColor = color ?? cs.onSurface.withOpacity(.7);

    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: btnColor, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: btnColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );

    if (scale != null) {
      return ScaleTransition(scale: scale!, child: button);
    }
    return button;
  }
}

// Page de détail du post
class _PostDetailPage extends StatefulWidget {
  final int postId;

  const _PostDetailPage({required this.postId});

  @override
  State<_PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<_PostDetailPage> {
  final TimeLineService _service = TimeLineService();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  PostDetailEntity? _post;
  bool _isLoading = true;
  bool _isAddingComment = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPostDetail();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  Future<void> _loadPostDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final post = await _service.getPostDetail(widget.postId);
      setState(() {
        _post = post;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty || _isAddingComment) return;

    setState(() => _isAddingComment = true);

    try {
      final newComment = await _service.addComment(
        widget.postId,
        _commentController.text.trim(),
      );

      setState(() {
        _post = PostDetailEntity(
          id: _post!.id,
          title: _post!.title,
          description: _post!.description,
          imageUrl: _post!.imageUrl,
          category: _post!.category,
          dateCreation: _post!.dateCreation,
          nbrLikes: _post!.nbrLikes,
          nbrComments: _post!.nbrComments + 1,
          nbrShares: _post!.nbrShares,
          auteurUsername: _post!.auteurUsername,
          utilisateurADejalike: _post!.utilisateurADejalike,
          commentaires: [..._post!.commentaires, newComment],
        );
        _commentController.clear();
      });

      _commentFocus.unfocus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commentaire ajouté'),
            backgroundColor: gaindeGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: gaindeRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() => _isAddingComment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gaindeBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Post'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: gaindeGreen))
          : _error != null
          ? Center(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.white70),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _PostCard(post: _post!),
                      const SizedBox(height: 24),
                      Text(
                        'Commentaires (${_post!.commentaires.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._post!.commentaires.map(
                        (c) => _CommentItem(comment: c),
                      ),
                      if (_post!.commentaires.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'Aucun commentaire pour le moment',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _CommentInputBar(
                  controller: _commentController,
                  focusNode: _commentFocus,
                  isLoading: _isAddingComment,
                  onSubmit: _addComment,
                ),
              ],
            ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final CommentEntity comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    final timeAgo = timeago.format(comment.dateCommentaire, locale: 'fr');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: gaindeGreen,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        comment.auteurUsername,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _CommentInputBar({
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gaindeBg.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Ajouter un commentaire...',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: gaindeGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: isLoading ? null : onSubmit,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Onglets "Inside Training" et "AI Summaries" conservés
class _InsideTrainingTab extends StatelessWidget {
  const _InsideTrainingTab();

  @override
  Widget build(BuildContext context) {
    final clips = [
      (
        "Entraînement à Diamniadio",
        "Séquence pressing + transitions",
        'assets/img/train.avif',
      ),
      (
        "Jeu de position 7v7",
        "Focus couloir droit / circuits",
        'assets/img/conference.jpeg',
      ),
      (
        "Travail des CPA",
        "Corners rentrants • variations",
        'assets/img/team.jpeg',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: clips.length,
      itemBuilder: (ctx, i) {
        final (title, subtitle, thumb) = clips[i];
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: gaindeGreen,
                    child: Icon(Icons.videocam, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Inside • $title",
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(thumb, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white.withOpacity(.7)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AISummariesTab extends StatelessWidget {
  const _AISummariesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        GlassCard(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.auto_awesome, size: 48, color: gaindeGold),
                SizedBox(height: 12),
                Text(
                  'Résumés IA bientôt disponibles',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
