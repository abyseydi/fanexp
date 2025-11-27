import 'package:fanexp/screens/timeline/controller/post_detail_controller.dart';
import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';
// import 'package:fanexp/theme/gainde_theme.dart'; // Commenté car les constantes sont définies ci-dessous
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

// ==========================================
// DÉFINITIONS DE COULEURS ET CONSTANTES
// ==========================================

// Valeurs par défaut pour les couleurs si 'gainde_theme.dart' n'est pas fourni
const Color gaindeRed = Colors.red;
const Color gaindeInk = Colors.black;
const Color gaindeGreen = Color(0xFF4CAF50);
const Color gaindeGold = Color(0xFFE5B800); // Jaune or

// Constante pour l'opacité des textes subtils
const double _subtleOpacity = 0.55;

// ==========================================
// 🦁 WIDGET : AVATAR DE LA FÉDÉRATION
// ==========================================

class FederationAvatar extends StatelessWidget {
  final double size;

  // Le chemin de l'asset FSF
  static const String assetPath = 'assets/img/fsf.png';

  const FederationAvatar({super.key, this.size = 34});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(1.0), // Padding optionnel
      // Ajout d'une bordure colorée (Gainde) pour l'esthétique
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: gaindeGreen, width: 1.5),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover, // Assure que l'image remplit le cercle
          errorBuilder: (context, error, stackTrace) {
            // Placeholder en cas d'erreur de chargement (très utile)
            return Container(
              color: Colors.grey.shade200,
              child: Icon(
                Icons.error_outline,
                size: size * 0.5,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// PAGE PRINCIPALE : PostDetailPage
// ==========================================

class PostDetailPage extends StatefulWidget {
  final VoidCallback? onCommentAdded;

  const PostDetailPage({super.key, this.onCommentAdded});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());

    _commentController.addListener(() {
      setState(() {
        _isComposing = _commentController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  Future<void> _addComment(PostDetailController controller) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (controller.isAddingComment) return;

    try {
      await controller.addComment(text);
      _commentController.clear();
      _commentFocus.unfocus();
      widget.onCommentAdded?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Oups ! Erreur lors de l\'envoi: $e'),
            backgroundColor: gaindeRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(10),
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
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Commentaires',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Colors.black,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.ellipsis_vertical,
              color: Colors.black,
            ),
            onPressed: () {
              // Logique de tri ou d'options
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<PostDetailController>(
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
                    return _buildErrorState(controller);
                  }

                  if (controller.post == null) {
                    return const Center(
                      child: Text('Publication introuvable.'),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      // Le Post d'origine (Caption et Image)
                      SliverToBoxAdapter(
                        child: _PostDetailCard(
                          post: controller.post!,
                          onLike: () => controller.toggleLike(),
                        ),
                      ),

                      // Séparateur de la section commentaires
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 4),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                            indent: 16,
                            endIndent: 16,
                          ),
                        ),
                      ),

                      // Liste des commentaires ou état vide
                      if (controller.post!.commentaires.isEmpty)
                        _buildEmptyState()
                      else
                        SliverPadding(
                          padding: const EdgeInsets.only(bottom: 20, top: 0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => CommentItem(
                                comment: controller.post!.commentaires[index],
                              ),
                              childCount: controller.post!.commentaires.length,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // Input Bar fixée en bas
            Consumer<PostDetailController>(
              builder: (context, controller, _) {
                return _CommentInputBar(
                  controller: _commentController,
                  focusNode: _commentFocus,
                  isComposing: _isComposing,
                  isLoading: controller.isAddingComment,
                  onSubmit: () => _addComment(controller),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(PostDetailController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.refresh_rounded, size: 50, color: gaindeRed),
          const SizedBox(height: 10),
          Text(controller.error!, style: const TextStyle(color: Colors.grey)),
          TextButton(
            onPressed: controller.loadPostDetail,
            child: const Text(
              'Réessayer',
              style: TextStyle(color: gaindeGreen, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.chat_bubble_2_fill,
              size: 60,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun commentaire pour l\'instant.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Lancez la discussion !',
              style: TextStyle(
                color: gaindeGreen,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// POST DETAIL CARD
// ==========================================

class _PostDetailCard extends StatefulWidget {
  final PostEntity post;
  final Future<void> Function() onLike;

  const _PostDetailCard({required this.post, required this.onLike});

  @override
  State<_PostDetailCard> createState() => _PostDetailCardState();
}

class _PostDetailCardState extends State<_PostDetailCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _animateLike() {
    _likeController.forward().then((_) => _likeController.reverse());
    widget.onLike();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final timeAgo = timeago.format(post.dateCreation, locale: 'fr_short');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // UTILISATION DU NOUVEL AVATAR DE LA FÉDÉRATION
              const FederationAvatar(size: 34),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        const Icon(
                          Icons.verified,
                          color: gaindeGreen,
                          size: 14,
                        ),
                      ],
                    ),
                    // Emplacement de la localisation
                    Text(
                      "Dakar, Sénégal",
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- Image ---
        GestureDetector(
          onDoubleTap: _animateLike,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey.shade100,
              width: double.infinity,
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),

        // --- Action Buttons ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              ScaleTransition(
                scale: _likeAnimation,
                child: GestureDetector(
                  onTap: _animateLike,
                  child: Icon(
                    post.utilisateurADejalike
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: post.utilisateurADejalike ? gaindeRed : Colors.black,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              const Icon(
                CupertinoIcons.chat_bubble,
                size: 26,
                color: Colors.black,
              ),
              const SizedBox(width: 18),
              const Icon(
                CupertinoIcons.paperplane,
                size: 26,
                color: Colors.black,
              ),
            ],
          ),
        ),

        // --- Likes Count ---
        if (post.nbrLikes > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
            child: Text(
              'Aimé par ${post.nbrLikes} personnes',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),

        // --- Caption (Description du Post d'origine) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: '${post.auteurUsername} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post.description),
              ],
            ),
          ),
        ),

        // --- Date ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Text(
            timeAgo.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
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
  static const int _commentMaxLines = 3;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final timeAgo = timeago.format(comment.dateCommentaire, locale: 'fr_short');

    // Logique pour déterminer si l'auteur est la FSF (basé sur le nom d'utilisateur)
    final bool isFederation =
        comment.auteurUsername.toLowerCase().contains('gaïndé') ||
        comment.auteurUsername.toLowerCase().contains('fsf');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          isFederation
              ? const FederationAvatar(size: 32) // Avatar FSF pour la Fédé
              : const CircleAvatar(
                  // Avatar générique pour les autres utilisateurs
                  radius: 16,
                  backgroundColor: Color(0xFFEEEEEE),
                  child: Icon(Icons.person, size: 18, color: Colors.grey),
                ),
          const SizedBox(width: 12),

          // Contenu (Nom d'utilisateur et Commentaire)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Nom d'utilisateur (En gras)
                Row(
                  children: [
                    Text(
                      comment.auteurUsername,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    // Afficher l'icône de vérification pour la FSF
                    if (isFederation)
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.verified,
                          color: gaindeGreen,
                          size: 14,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                // 2. Contenu du commentaire (limité en lignes)
                Text(
                  comment.content,
                  maxLines: _commentMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 6),
                // 3. Métadonnées (Date)
                Row(
                  children: [
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// INPUT BAR
// ==========================================

class _CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isComposing;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _CommentInputBar({
    required this.controller,
    required this.focusNode,
    required this.isComposing,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom > 0
            ? 8
            : MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar utilisateur courant
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            // AVATAR UTILISATEUR SIMPLE (petit, couleur GaindeGreen)
            child: CircleAvatar(
              radius: 14,
              backgroundColor: gaindeGreen,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ),

          const SizedBox(width: 12),

          // Champ texte
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: 5,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 14, color: gaindeInk),
                decoration: InputDecoration(
                  hintText: 'Ajouter un commentaire...',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Bouton Publier/Chargement
          Container(
            height: 40,
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: gaindeGreen,
                    ),
                  )
                : TextButton(
                    onPressed: isComposing ? onSubmit : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Publier',
                      style: TextStyle(
                        color: isComposing
                            ? gaindeGreen
                            : gaindeGreen.withOpacity(0.35),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
