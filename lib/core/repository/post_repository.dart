import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsProvider = StreamProvider<List<Post>>((ref) {
  return ref.watch(postSnapshotsProvider.stream).map((event) {
    return event.docs.map((doc) {
      final dataMap = doc.data();
      final data = dataMap! as Map<String, dynamic>;
      return Post.fromMap(data, doc.id);
    }).toList();
  });
});

final postsWithAccountIdFamily =
    FutureProvider.family<List<Post>, String>((ref, id) {
  return ref.watch(postSnapshotWithAccountIdFamily(id).future).then((event) {
    return event.docs.map((doc) {
      final dataMap = doc.data();
      final data = dataMap! as Map<String, dynamic>;
      return Post.fromMap(data, id);
    }).toList();
  });
});

class PostRepository {
  PostRepository(this.postFirestoreAPI);

  final PostFirestoreAPI postFirestoreAPI;

  Future<dynamic> addPost(Post newPost) async {
    try {
      final postData = {
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'post_id': 'post_id',
        'created_time': Timestamp.now(),
        'rank': newPost.rank,
        'attraction_name': newPost.attractionName,
        'is_spoiler': newPost.isSpoiler,
      };
      final result = await postFirestoreAPI.addPost(postData);
      await updatePosts(result.id, {'post_id': result.id});
      final userPostData = {
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'post_id': result.id,
        'created_time': Timestamp.now(),
        'rank': newPost.rank,
        'attraction_name': newPost.attractionName,
        'is_spoiler': newPost.isSpoiler,
      };
      await postFirestoreAPI.addUserPost(
        newPost.postAccountId,
        result.id,
        userPostData,
      );
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<void> updatePosts(String postId, Map<String, dynamic> data) async {
    return postFirestoreAPI.posts.doc(postId).update(data);
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
      await postFirestoreAPI.deletePost(post.postId);
      await postFirestoreAPI.deleteUserPost(accountId, post.postId);
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}
