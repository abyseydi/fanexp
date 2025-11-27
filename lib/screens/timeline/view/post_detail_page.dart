import 'package:fanexp/screens/timeline/controller/post_detail_controller.dart';
import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatefulWidget {
  final VoidCallback? onCommentAdded;

  const PostDetailPage({super.key, this.onCommentAdded});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  Future<void> _addComment(PostDetailController controller) async {
    if (_commentController.text.trim().isEmpty) return;

    try {
      await controller.addComment(_commentController.text.trim());
      _commentController.clear();
      _commentFocus.unfocus();

      widget.onCommentAdded?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Commentaire ajouté'),
            backgroundColor: gaindeGreen,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
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
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: gaindeInk),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Commentaires',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: gaindeInk,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send_outlined, color: gaindeInk, size: 22),
          ),
        ],
      ),
      body: Consumer<PostDetailController>(
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: gaindeRed),
                  const SizedBox(height: 16),
                  Text(
                    controller.error!,
                    style: TextStyle(color: gaindeInk.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: controller.loadPostDetail,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gaindeGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.post == null) {
            return const Center(
              child: Text(
                'Post introuvable',
                style: TextStyle(color: gaindeInk),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Post principal
                    SliverToBoxAdapter(
                      child: _PostDetailCard(
                        post: controller.post!,
                        onLike: controller.toggleLike,
                      ),
                    ),

                    // Divider
                    const SliverToBoxAdapter(
                      child: Divider(height: 1, thickness: 0.5),
                    ),

                    // Liste des commentaires
                    if (controller.post!.commentaires.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: gaindeInk.withOpacity(0.2),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun commentaire',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: gaindeInk.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Soyez le premier à commenter',
                                style: TextStyle(
                                  color: gaindeInk.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => CommentItem(
                            comment: controller.post!.commentaires[index],
                          ),
                          childCount: controller.post!.commentaires.length,
                        ),
                      ),
                  ],
                ),
              ),

              // Barre de saisie
              CommentInputBar(
                controller: _commentController,
                focusNode: _commentFocus,
                isLoading: controller.isAddingComment,
                onSubmit: () => _addComment(controller),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ==========================================
// POST DETAIL CARD
// ==========================================

class _PostDetailCard extends StatefulWidget {
  final dynamic post;
  final Future<void> Function() onLike;

  const _PostDetailCard({required this.post, required this.onLike});

  @override
  State<_PostDetailCard> createState() => _PostDetailCardState();
}

class _PostDetailCardState extends State<_PostDetailCard>
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
      await widget.onLike();
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

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final timeAgo = timeago.format(post.dateCreation, locale: 'fr');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [gaindeGold, gaindeGreen, gaindeRed],
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
                child: Row(
                  children: [
                    Text(
                      post.auteurUsername,
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
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: gaindeInk),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Image
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: gaindeBg,
              child: const Icon(
                Icons.image_not_supported,
                size: 48,
                color: Colors.grey,
              ),
            ),
          ),
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ScaleTransition(
                scale: _likeScaleAnim,
                child: IconButton(
                  onPressed: _handleLike,
                  icon: Icon(
                    post.utilisateurADejalike
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post.utilisateurADejalike ? gaindeRed : gaindeInk,
                    size: 28,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble, color: gaindeInk, size: 26),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
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

        // Likes
        if (post.nbrLikes > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${post.nbrLikes} J\'aime${post.nbrLikes > 1 ? 's' : ''}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: gaindeInk,
              ),
            ),
          ),

        // Caption
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 2),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: gaindeInk,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: post.auteurUsername,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (post.title.isNotEmpty) ...[
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: post.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
                if (post.description.isNotEmpty) ...[
                  const TextSpan(text: ' '),
                  TextSpan(text: post.description),
                ],
              ],
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
    );
  }
}

// ==========================================
// COMMENT ITEM
// ==========================================

class CommentItem extends StatelessWidget {
  final CommentEntity comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final timeAgo = timeago.format(comment.dateCommentaire, locale: 'fr');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: gaindeGreen,
            child: Icon(Icons.person, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: gaindeInk,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: comment.auteurUsername,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: comment.content),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: gaindeInk.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Répondre',
                      style: TextStyle(
                        fontSize: 12,
                        color: gaindeInk.withOpacity(0.4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border,
              size: 16,
              color: gaindeInk.withOpacity(0.6),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// COMMENT INPUT BAR
// ==========================================

class CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final VoidCallback onSubmit;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: gaindeInk.withOpacity(0.1), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: gaindeGreen,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(fontSize: 14, color: gaindeInk),
                decoration: InputDecoration(
                  hintText: 'Ajouter un commentaire...',
                  hintStyle: TextStyle(
                    color: gaindeInk.withOpacity(0.4),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: gaindeGreen,
                ),
              )
            else
              GestureDetector(
                onTap: onSubmit,
                child: Text(
                  'Publier',
                  style: TextStyle(
                    color: controller.text.isEmpty
                        ? gaindeGreen.withOpacity(0.4)
                        : gaindeGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
