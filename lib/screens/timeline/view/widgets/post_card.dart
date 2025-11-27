// Assurez-vous que ces fichiers existent et définissent les classes/variables nécessaires
import 'package:fanexp/screens/timeline/controller/post_detail_controller.dart';
import 'package:fanexp/screens/timeline/controller/timeline_controller.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';
import 'package:fanexp/screens/timeline/repository/timeline_repository.dart';
import 'package:fanexp/screens/timeline/service/timeline_service.dart';
import 'package:fanexp/screens/timeline/view/post_detail_page.dart';
// NOTE: Vous devez définir 'gainde_theme.dart' avec les couleurs comme gaindeRed, gaindeInk, etc.
// import 'package:fanexp/theme/gainde_theme.dart'; // Commenté car les constantes sont définies ci-dessous
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

// Valeurs par défaut pour les couleurs (en l'absence de gainde_theme.dart)
const Color gaindeRed = Colors.red;
const Color gaindeInk = Colors.black;
const Color gaindeBg = Color(0xFFEFEFEF);
const Color gaindeGreen = Color(0xFF4CAF50);
const Color gaindeGold = Color(0xFFE5B800); // Ajouté pour la cohérence

// Constante pour l'opacité des textes gris
const double _subtleOpacity = 0.65;
// Constante pour la taille des icônes d'action
const double _iconSize = 28.0;

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
      padding: const EdgeInsets.all(1.0),
      // Ajout d'une bordure colorée (Gainde) pour l'esthétique
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Utilisation du vert/or ou simplement vert comme dans le thème
        border: Border.all(color: gaindeGreen, width: 1.5),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover, // Assure que l'image remplit le cercle
          errorBuilder: (context, error, stackTrace) {
            // Placeholder en cas d'erreur de chargement
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

// --- DÉBUT DE LA CLASSE PRINCIPALE PostCard ---
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

  // Indique si l'animation du cœur au centre de l'image est en cours
  bool _isShowingDoubleTapLike = false;
  bool _isExpanded =
      false; // Pour la fonctionnalité "Voir plus" de la description

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Animation de type "ressort" (elasticOut) pour un effet de like smooth à la Instagram
    _likeScaleAnim = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.elasticOut),
    );
    // Initialisation du support des messages en français pour timeago
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------
  // 🎯 LOGIQUE DE GESTION DES LIKES
  // -----------------------------------------------------------------

  /// Gère l'action de like par double-tap sur l'image.
  /// **IMPÉRATIF : Cela DOIT UNIQUEMENT LIKER si le post n'est pas déjà liké.**
  Future<void> _handleDoubleTapLike() async {
    // Si le post n'est PAS déjà liké, on effectue l'action de like + animation.
    if (!widget.post.utilisateurADejalike) {
      // 1. Déclenche l'animation du cœur au centre de l'image
      _likeAnimController.forward().then((_) => _likeAnimController.reverse());

      // 2. Met à jour l'état pour afficher le cœur blanc au centre
      setState(() => _isShowingDoubleTapLike = true);

      try {
        // Tente de liker le post
        await context.read<TimelineController>().toggleLike(widget.post.id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Erreur lors du like par double-tap :('),
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
        // Masque le cœur blanc après la fin de l'animation
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) setState(() => _isShowingDoubleTapLike = false);
      }
    }
    // Si le post est déjà liké, le double-tap est ignoré (pas de unlike).
  }

  /// Gère l'action de like/unlike par le bouton cœur sous l'image.
  /// **IMPÉRATIF : Ce bouton doit gérer la bascule complète (Like OU Unlike).**
  Future<void> _handleButtonToggleLike() async {
    try {
      // Appelle la fonction de bascule pour liker ou unliker
      await context.read<TimelineController>().toggleLike(widget.post.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Erreur lors du changement de statut de like :(',
            ),
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

  // -----------------------------------------------------------------
  // 🎨 AUTRES FONCTIONS
  // -----------------------------------------------------------------

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

  void _toggleDescriptionExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = timeago.format(
      widget.post.dateCreation,
      locale: 'fr_short',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. Header ---
        const SizedBox(height: 5),
        _PostHeader(
          username: widget.post.auteurUsername,
          location: "Dakar, Sénégal",
          onMoreTap: () => _showOptions(context),
        ),

        // --- 2. Image et Double-Tap Like ---
        GestureDetector(
          onDoubleTap: _handleDoubleTapLike,
          child: Stack(
            children: [
              // Image principale : Gestion de la taille
              Container(
                color: gaindeBg, // Couleur de fond si l'image n'est pas carrée
                child: AspectRatio(
                  aspectRatio: 1, // Format carré
                  child: Image.network(
                    widget.post.imageUrl,
                    // 💡 CORRECTION : Utiliser BoxFit.contain pour s'assurer que toute l'image est visible,
                    // laissant des barres de couleur `gaindeBg` si nécessaire.
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      color: gaindeBg,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
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
              ),
              // Animation double-tap like (cœur blanc)
              if (_isShowingDoubleTapLike)
                Positioned.fill(
                  child: Center(
                    child: ScaleTransition(
                      scale: _likeScaleAnim,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white.withOpacity(0.9),
                        size: 100,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // --- 3. Actions ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Bouton Like (Permet le Like et le Unlike)
              IconButton(
                onPressed: _handleButtonToggleLike,
                icon: Icon(
                  widget.post.utilisateurADejalike
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  // 💡 COULEUR ROUGE SI LIKÉ
                  color: widget.post.utilisateurADejalike
                      ? gaindeRed
                      : gaindeInk,
                  size: _iconSize,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              // Bouton Commentaire
              IconButton(
                onPressed: _handleComment,
                icon: const Icon(
                  CupertinoIcons.chat_bubble,
                  color: gaindeInk,
                  size: _iconSize,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              // Bouton Partage
              IconButton(
                onPressed: _handleShare,
                icon: const Icon(
                  CupertinoIcons.paperplane,
                  color: gaindeInk,
                  size: _iconSize,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // --- 4. Nombre de likes ---
        if (widget.post.nbrLikes > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Aimé par ${widget.post.nbrLikes} personnes',
              style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: gaindeInk,
              ),
            ),
          ),

        // --- 5. Caption (Auteur + Titre + Description) avec "Voir plus" ---
        if (widget.post.title.isNotEmpty || widget.post.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: GestureDetector(
              onTap: _toggleDescriptionExpansion,
              child: RichText(
                maxLines: _isExpanded ? 100 : 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: theme.textTheme.bodyMedium!.copyWith(
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
                    // Affiche "... voir plus" si le texte est tronqué et non encore développé
                    if (!_isExpanded &&
                        (widget.post.description.length +
                                widget.post.title.length +
                                widget.post.auteurUsername.length) >
                            80)
                      TextSpan(
                        text: '... voir plus',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: gaindeInk.withOpacity(_subtleOpacity),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

        // --- 6. Voir les commentaires ---
        if (widget.post.nbrComments > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: GestureDetector(
              onTap: _handleComment,
              child: Text(
                'Voir les ${widget.post.nbrComments} commentaire${widget.post.nbrComments > 1 ? 's' : ''}',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: gaindeInk.withOpacity(_subtleOpacity),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // --- 7. Date ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Text(
            timeAgo.toUpperCase(),
            style: theme.textTheme.bodySmall!.copyWith(
              color: gaindeInk.withOpacity(0.4),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Fonctions de support (Bottom Sheet et Option Tile)

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            _buildOptionTile(
              context,
              icon: CupertinoIcons.bookmark,
              title: 'Enregistrer',
              onTap: () => Navigator.pop(context),
            ),
            _buildOptionTile(
              context,
              icon: CupertinoIcons.link,
              title: 'Copier le lien',
              onTap: () => Navigator.pop(context),
            ),
            _buildOptionTile(
              context,
              icon: CupertinoIcons.volume_mute,
              title: 'Masquer l\'utilisateur',
              onTap: () => Navigator.pop(context),
            ),
            const Divider(height: 1),
            _buildOptionTile(
              context,
              icon: CupertinoIcons.flag,
              title: 'Signaler',
              color: gaindeRed,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = gaindeInk,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

// --- DÉBUT DE LA CLASSE _PostHeader (MISE À JOUR) ---

class _PostHeader extends StatelessWidget {
  final String username;
  final String location;
  final VoidCallback onMoreTap;

  const _PostHeader({
    required this.username,
    required this.location,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // 💡 AVATAR : Utilisé FederationAvatar
          const FederationAvatar(size: 40),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: gaindeInk,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Badge de vérification (reste inchangé pour indiquer un compte officiel)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: gaindeGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ],
                ),
                // Emplacement de la localisation
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Bouton 'Plus'
          IconButton(
            onPressed: onMoreTap,
            icon: const Icon(
              CupertinoIcons.ellipsis_vertical,
              color: gaindeInk,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
