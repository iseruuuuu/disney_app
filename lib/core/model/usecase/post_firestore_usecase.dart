import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/repository/post_firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postUsecaseProvider = Provider.autoDispose<PostFireStoreUsecase>(
  (ref) => PostFireStoreUsecase(
    PostFirestoreRepository(
      PostFirestoreAPI(
        firebaseInstance: FirebaseFirestore.instance,
      ),
    ),
  ),
);

class PostFireStoreUsecase {
  PostFireStoreUsecase(this.firestoreRepository);

  final PostFirestoreRepository firestoreRepository;

  Stream<QuerySnapshot<Object?>> stream() {
    return firestoreRepository.stream();
  }

  Future<dynamic> addPost(Post newPost) async {
    return firestoreRepository.addPost(newPost);
  }

  Future<List<Post>?> getPostsFromIds(List<String> ids) async {
    return firestoreRepository.getPostsFromIds(ids);
  }

  Future<List<Post>?> getPosts(List<String> ids) async {
    return firestoreRepository.getPostsFromIds(ids);
  }

  Future<dynamic> deleteAllPosts(String accountId) async {
    return firestoreRepository.deleteAllPosts(accountId);
  }

  Future<dynamic> deletePost(String accountId, Post newPost) async {
    return firestoreRepository.deletePost(accountId, newPost);
  }
}
