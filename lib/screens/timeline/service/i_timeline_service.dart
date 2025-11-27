import 'package:fanexp/screens/timeline/entity/Comment_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_detail_entity.dart';
import 'package:fanexp/screens/timeline/entity/post_entity.dart';

abstract class ITimelineService {
  Future<List<PostEntity>> getAllPosts();
  Future<PostDetailEntity> getPostDetail(int postId);
  Future<bool> toggleLike(int postId);
  Future<CommentEntity> addComment(int postId, String content);
}
