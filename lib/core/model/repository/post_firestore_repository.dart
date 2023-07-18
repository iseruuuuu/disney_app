import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/post.dart';

class PostFirestoreRepository {
  static final firebaseInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = firebaseInstance.collection('post');

  Stream<QuerySnapshot<Map<String, dynamic>>> stream() {
    return FirebaseFirestore.instance
        .collection('post')
        .orderBy('created_time', descending: true)
        .snapshots();
  }

  Future<dynamic> addPost(Post newPost) async {
    try {
      final CollectionReference userPosts = firebaseInstance
          .collection('users')
          .doc(newPost.postAccountId)
          .collection('my_posts');
      final result = await posts.add({
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
        'rank': newPost.rank,
        'attraction_name': newPost.attractionName,
      });
      await userPosts.doc(result.id).set({
        'post_id': result.id,
        'created_time': Timestamp.now(),
      });
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<List<Post>?> getPostsFromIds(List<String> ids) async {
    final postList = <Post>[];
    try {
      await Future.forEach(ids, (String id) async {
        final doc = await posts.doc(id).get();
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final post = Post(
            id: doc.id,
            content: data['content'],
            postAccountId: data['post_account_id'],
            createdTime: data['created_time'],
            rank: data['rank'],
            attractionName: data['attraction_name'],
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
    final CollectionReference userPosts = firebaseInstance
        .collection('users')
        .doc(accountId)
        .collection('my_posts');

    final snapshot = await userPosts.get();
    await Future.forEach(snapshot.docs, (doc) async {
      await posts.doc(doc.id).delete();
      await userPosts.doc(doc.id).delete();
    });
  }

  Future<dynamic> deletePost(String accountId, Post newPost) async {
    final CollectionReference userPost = firebaseInstance
        .collection('users')
        .doc(newPost.postAccountId)
        .collection('my_posts');
    await posts.doc(accountId).delete();
    await userPost.doc(accountId).delete();
  }
}
