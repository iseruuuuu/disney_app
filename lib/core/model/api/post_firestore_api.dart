import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postSnapshotsProvider = StreamProvider<QuerySnapshot<Object?>>((ref) {
  final posts = ref.watch(firebaseFirestoreProvider).collection('post');
  //TODO 1回で何件取得するのかを考える。
  final data =
      posts.orderBy('created_time', descending: true).limit(100).snapshots();
  return data;
});

final postSnapshotWithAccountIdFamily =
    StreamProvider.family<QuerySnapshot<Object?>, String>((ref, id) {
  final posts = ref.watch(firebaseFirestoreProvider).collection('post');
  final data = posts
      .where('post_account_id', isEqualTo: id)
      // .orderBy('created_time', descending: true)
      .snapshots();
  return data;
});

class PostFirestoreAPI {
  PostFirestoreAPI({required this.firebaseInstance});

  final FirebaseFirestore firebaseInstance;

  CollectionReference get posts => firebaseInstance.collection('post');

  CollectionReference _userPosts(String accountId) => firebaseInstance
      .collection('users')
      .doc(accountId)
      .collection('my_posts');

  Future<DocumentReference> addPost(Map<String, dynamic> postData) {
    return posts.add(postData);
  }

  Future<void> addUserPost(
    String accountId,
    String postId,
    Map<String, dynamic> userPostData,
  ) {
    return _userPosts(accountId).doc(postId).set(userPostData);
  }

  Future<DocumentSnapshot> getPost(String postId) {
    return posts.doc(postId).get();
  }

  Future<QuerySnapshot> getUserPosts(String accountId) {
    return _userPosts(accountId).get();
  }

  Future<void> deletePost(String postId) {
    return posts.doc(postId).delete();
  }

  Future<void> deleteUserPost(String accountId, String postId) {
    return _userPosts(accountId).doc(postId).delete();
  }
}
