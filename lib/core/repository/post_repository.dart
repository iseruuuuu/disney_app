import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/core/services/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  return ref.watch(postSnapshotsProvider.stream).map((event) {
    return event.docs.map((doc) {
      final dataMap = doc.data();
      final data = dataMap! as Map<String, dynamic>;
      return Post.fromMap(data, doc.id);
    }).toList();
  });
});

final postsWithAccountIdFamily =
    StreamProvider.autoDispose.family<List<Post>, String>((ref, id) {
  return ref.watch(postSnapshotWithAccountIdFamily(id).stream).map((event) {
    return event.docs.map((doc) {
      final dataMap = doc.data();
      final data = dataMap! as Map<String, dynamic>;
      return Post.fromMap(data, id);
    }).toList();
  });
});

final postWithAttractionNameFamily = StreamProvider.autoDispose
    .family<List<Post>, String>((ref, attractionName) {
  return ref
      .watch(postSnapshotWithAttractionNameFamily(attractionName).stream)
      .map((event) {
    return event.docs.map((doc) {
      final dataMap = doc.data();
      final data = dataMap! as Map<String, dynamic>;
      final myAccount = AuthenticationService.myAccount!;
      return Post.fromMap(data, myAccount.id);
    }).toList();
  });
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(ref);
});

class PostRepository {
  PostRepository(ProviderRef<PostRepository> ref) {
    postFirestoreService = ref.read(postServiceProvider);
  }

  late final PostService postFirestoreService;

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
        'heart': newPost.heart,
        'super_good': newPost.superGood,
      };
      final result = await postFirestoreService.addPost(postData);
      await updatePosts(result.id, {'post_id': result.id});
      final userPostData = {
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'post_id': result.id,
        'created_time': Timestamp.now(),
        'rank': newPost.rank,
        'attraction_name': newPost.attractionName,
        'is_spoiler': newPost.isSpoiler,
        'heart': newPost.heart,
        'super_good': newPost.superGood,
      };
      await postFirestoreService.addUserPost(
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
    return postFirestoreService.updatePost(postId, data);
  }

  Future<void> updateUserPost(
    String accountId,
    String postId,
    Map<String, dynamic> data,
  ) {
    return postFirestoreService.updateUserPost(accountId, postId, data);
  }

  Future<dynamic> deleteAllPosts(String accountId) async {
    try {
      final snapshot = await postFirestoreService.getUserPosts(accountId);
      await Future.forEach(snapshot.docs, (doc) async {
        await postFirestoreService.deletePost(doc.id);
        await postFirestoreService.deleteUserPost(accountId, doc.id);
      });
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<dynamic> deletePost(String accountId, Post post) async {
    try {
      await postFirestoreService.deletePost(post.postId);
      await postFirestoreService.deleteUserPost(accountId, post.postId);
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}
