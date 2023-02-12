import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/model/post.dart';

class PostFirestore {
  static final firebaseInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = firebaseInstance.collection('post');

  static Future<dynamic> addPost(Post newPost) async {
    try {
      final CollectionReference userPosts = firebaseInstance
          .collection('users')
          .doc(newPost.postAccountId)
          .collection('my_posts');
      var result = await posts.add({
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
        'rank': newPost.rank,
        'attraction_name': newPost.attractionName,
      });
      userPosts.doc(result.id).set({
        'post_id': result.id,
        'created_time': Timestamp.now(),
      });
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  static Future<List<Post>?> getPostsFromIds(List<String> ids) async {
    List<Post> postList = [];
    try {
      await Future.forEach(ids, (String id) async {
        var doc = await posts.doc(id).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Post post = Post(
          id: doc.id,
          content: data['content'],
          postAccountId: data['post_account_id'],
          createdTime: data['created_time'],
          rank: data['rank'],
          attractionName: data['attraction_name'],
        );
        postList.add(post);
      });
      return postList;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  static Future<dynamic> deletePosts(String accountId) async {
    final CollectionReference userPosts = firebaseInstance
        .collection('users')
        .doc(accountId)
        .collection('my_posts');

    var snapshot = await userPosts.get();
    snapshot.docs.forEach((doc) async {
      await posts.doc(doc.id).delete();
      userPosts.doc(doc.id).delete();
    });
  }
}
