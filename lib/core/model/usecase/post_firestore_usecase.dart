import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/repository/post_firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postUsecaseProvider = Provider.autoDispose<PostFireStoreUsecase>(
  (ref) => PostFireStoreUsecase(
    PostFirestoreRepository(),
  ),
);

class PostFireStoreUsecase {
  final PostFirestoreRepository firestoreRepository;

  PostFireStoreUsecase(this.firestoreRepository);

  Future<dynamic> addPost(Post newPost) async {
    return await firestoreRepository.addPost(newPost);
  }

  Future<List<Post>?> getPostsFromIds(List<String> ids) async {
    return await firestoreRepository.getPostsFromIds(ids);
  }

  Future<List<Post>?> getPosts(List<String> ids) async {
    return await firestoreRepository.getPostsFromIds(ids);
  }

  Future<dynamic> deleteAllPosts(String accountId) async {
    return await firestoreRepository.deleteAllPosts(accountId);
  }

  Future<dynamic> deletePost(String accountId, Post newPost) async {
    return await firestoreRepository.deletePost(accountId, newPost);
  }
}