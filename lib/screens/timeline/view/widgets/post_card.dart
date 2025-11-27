import 'package:fanexp/screens/timeline/controller/post_detail_controller.dart';
import 'package:fanexp/screens/timeline/controller/timeline_controller.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';
import 'package:fanexp/screens/timeline/repository/timeline_repository.dart';
import 'package:fanexp/screens/timeline/service/timeline_service.dart';
import 'package:fanexp/screens/timeline/view/post_detail_page.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnim;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _likeScaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.elasticOut),
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

    _likeAnimController.forward().then((_) => _likeAnimController.reverse());

    try {
      await context.read<TimelineController>().toggleLike(widget.post.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors du like'),
            backgroundColor: gaindeRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLiking = false);
    }
  }

  void _handleComment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) {
            final repository = TimelineRepository();
            final service = TimelineService(repository);
            return PostDetailController(service, widget.post.id)
              ..loadPostDetail();
          },
          child: PostDetailPage(
            onCommentAdded: () {
              context.read<TimelineController>().incrementCommentCount(
                widget.post.id,
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleShare() {
    Share.share(
      '${widget.post.title}\n\n${widget.post.description}\n\n📸 Via Gaïndé App',
      subject: widget.post.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = timeago.format(widget.post.dateCreation, locale: 'fr');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _PostHeader(
            username: widget.post.auteurUsername,
            timeAgo: timeAgo,
            onMoreTap: () => _showOptions(context),
          ),

          // Image (style Instagram - pleine largeur, pas de padding)
          GestureDetector(
            onDoubleTap: _handleLike,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    widget.post.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: gaindeBg,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: gaindeBg,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: gaindeGreen,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Animation double-tap like
                if (_isLiking)
                  Positioned.fill(
                    child: Center(
                      child: ScaleTransition(
                        scale: _likeScaleAnim,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: gaindeRed,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Actions (style Instagram)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _likeScaleAnim,
                  child: IconButton(
                    onPressed: _handleLike,
                    icon: Icon(
                      widget.post.utilisateurADejalike
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.post.utilisateurADejalike
                          ? gaindeRed
                          : gaindeInk,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _handleComment,
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: gaindeInk,
                    size: 26,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _handleShare,
                  icon: const Icon(
                    Icons.send_outlined,
                    color: gaindeInk,
                    size: 26,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: gaindeInk,
                    size: 26,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Nombre de likes
          if (widget.post.nbrLikes > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${widget.post.nbrLikes} J\'aime${widget.post.nbrLikes > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: gaindeInk,
                ),
              ),
            ),

          // Titre + Description
          if (widget.post.title.isNotEmpty ||
              widget.post.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: gaindeInk,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: widget.post.auteurUsername,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (widget.post.title.isNotEmpty) ...[
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: widget.post.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                    if (widget.post.description.isNotEmpty) ...[
                      const TextSpan(text: ' '),
                      TextSpan(text: widget.post.description),
                    ],
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Voir les commentaires
          if (widget.post.nbrComments > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: GestureDetector(
                onTap: _handleComment,
                child: Text(
                  'Voir les ${widget.post.nbrComments} commentaire${widget.post.nbrComments > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: gaindeInk.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Date
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
            child: Text(
              timeAgo.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: gaindeInk.withOpacity(0.4),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border, color: gaindeInk),
              title: const Text(
                'Enregistrer',
                style: TextStyle(color: gaindeInk),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.link, color: gaindeInk),
              title: const Text(
                'Copier le lien',
                style: TextStyle(color: gaindeInk),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: gaindeRed),
              title: const Text('Signaler', style: TextStyle(color: gaindeRed)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Header style Instagram
class _PostHeader extends StatelessWidget {
  final String username;
  final String timeAgo;
  final VoidCallback onMoreTap;

  const _PostHeader({
    required this.username,
    required this.timeAgo,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Avatar avec border gradient
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [gaindeGold, gaindeGreen, gaindeRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: gaindeGreen,
                child: Icon(Icons.shield, color: Colors.white, size: 18),
              ),
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
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: gaindeInk,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: gaindeGreen, size: 14),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMoreTap,
            icon: const Icon(Icons.more_vert, color: gaindeInk, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
