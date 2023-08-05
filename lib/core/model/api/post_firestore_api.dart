import 'package:cloud_firestore/cloud_firestore.dart';

class PostFirestoreAPI {
  PostFirestoreAPI({required this.firebaseInstance});

  final FirebaseFirestore firebaseInstance;

  CollectionReference get posts => firebaseInstance.collection('post');

  CollectionReference userPosts(String accountId) => firebaseInstance
      .collection('users')
      .doc(accountId)
      .collection('my_posts');

  Stream<QuerySnapshot<Object?>> streamPosts() {
    return posts.orderBy('created_time', descending: true).snapshots();
  }

  Future<DocumentReference> addPost(Map<String, dynamic> postData) {
    return posts.add(postData);
  }

  Future<void> addUserPost(
    String accountId,
    String postId,
    Map<String, dynamic> userPostData,
  ) {
    return userPosts(accountId).doc(postId).set(userPostData);
  }

  Future<DocumentSnapshot> getPost(String postId) {
    return posts.doc(postId).get();
  }

  Future<QuerySnapshot> getUserPosts(String accountId) {
    return userPosts(accountId).get();
  }

  Future<void> deletePost(String postId) {
    return posts.doc(postId).delete();
  }

  Future<void> deleteUserPost(String accountId, String postId) {
    return userPosts(accountId).doc(postId).delete();
  }
}
