import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/model/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postUsecaseProvider = Provider.autoDispose<PostUsecase>(
  (ref) => PostUsecase(
    PostRepository(
      PostFirestoreAPI(
        firebaseInstance: FirebaseFirestore.instance,
      ),
    ),
  ),
);

class PostUsecase {
  PostUsecase(this.postRepository);

  final PostRepository postRepository;

  Future<dynamic> addPost(Post newPost) async {
    return postRepository.addPost(newPost);
  }

  Future<dynamic> deleteAllPosts(String accountId) async {
    return postRepository.deleteAllPosts(accountId);
  }

  Future<dynamic> deletePost(String accountId, Post newPost) async {
    return postRepository.deletePost(accountId, newPost);
  }
}
