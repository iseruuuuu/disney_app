import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/post.dart';

class PostFirestoreRepository {
  PostFirestoreRepository(this.postFirestoreAPI);

  final PostFirestoreAPI postFirestoreAPI;

  Stream<QuerySnapshot<Object?>> stream() {
    return postFirestoreAPI.streamPosts();
  }

  Future<dynamic> addPost(Post newPost) async {
    try {
      final postData = {
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
        'rank': newPost.rank,
        'attraction_name': newPost.attractionName,
        'is_spoiler': newPost.isSpoiler,
      };
      final result = await postFirestoreAPI.addPost(postData);
      final userPostData = {
        'post_id': result.id,
        'created_time': Timestamp.now(),
      };
      await postFirestoreAPI.addUserPost(
          newPost.postAccountId, result.id, userPostData);
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<List<Post>?> getPostsFromIds(List<String> ids) async {
    final postList = <Post>[];
    try {
      await Future.forEach(ids, (String id) async {
        final doc = await postFirestoreAPI.getPost(id);
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final post = Post(
            id: doc.id,
            content: data['content'],
            postAccountId: data['post_account_id'],
            createdTime: data['created_time'],
            rank: data['rank'],
            attractionName: data['attraction_name'],
            isSpoiler: data['is_spoiler'],
          );
          postList.add(post);
        }
      });
      return postList;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  Future<dynamic> deleteAllPosts(String accountId) async {
    try {
      final snapshot = await postFirestoreAPI.getUserPosts(accountId);
      await Future.forEach(snapshot.docs, (doc) async {
        await postFirestoreAPI.deletePost(doc.id);
        await postFirestoreAPI.deleteUserPost(accountId, doc.id);
      });
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<dynamic> deletePost(String accountId, Post post) async {
    try {
      await postFirestoreAPI.deletePost(post.id);
      await postFirestoreAPI.deleteUserPost(accountId, post.id);
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}
