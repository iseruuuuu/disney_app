import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/core/firebase/firebase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postSnapshotsProvider =
    StreamProvider.autoDispose<QuerySnapshot<Object?>>((ref) {
  final posts = ref.watch(firebaseFirestoreProvider).collection('post');
  final data =
      posts.orderBy('created_time', descending: true).limit(100).snapshots();
  return data;
});

final postSnapshotWithAccountIdFamily = StreamProvider.autoDispose
    .family<QuerySnapshot<Object?>, String>((ref, id) {
  final posts = ref.watch(firebaseFirestoreProvider).collection('post');
  final data = posts
      .where('post_account_id', isEqualTo: id)
      .orderBy('created_time', descending: true)
      .snapshots();
  return data;
});

final postSnapshotWithAttractionNameFamily = StreamProvider.autoDispose
    .family<QuerySnapshot<Object?>, String>((ref, attractionName) {
  final posts = ref.watch(firebaseFirestoreProvider).collection('post');
  final data = posts
      .where('attraction_name', isEqualTo: attractionName)
      .orderBy('created_time', descending: true)
      .snapshots();
  return data;
});

final postServiceProvider = Provider<PostService>((ref) {
  return PostService(ref);
});

class PostService {
  PostService(ProviderRef<PostService> ref) {
    firebaseInstance = ref.read(firebaseFirestoreProvider);
  }

  late final FirebaseFirestore firebaseInstance;

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
