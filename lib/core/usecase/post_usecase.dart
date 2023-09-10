import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postUsecaseProvider = Provider<PostUsecase>((ref) {
  return PostUsecase(ref);
});

class PostUsecase {
  PostUsecase(ProviderRef<PostUsecase> ref) {
    postRepository = ref.read(postRepositoryProvider);
  }

  late final PostRepository postRepository;

  Future<dynamic> addPost(Post newPost) async {
    return postRepository.addPost(newPost);
  }

  Future<dynamic> deleteAllPosts(String accountId) async {
    return postRepository.deleteAllPosts(accountId);
  }

  Future<dynamic> deletePost(String accountId, Post newPost) async {
    return postRepository.deletePost(accountId, newPost);
  }

  Future<void> updatePosts(String postId, Map<String, dynamic> data) {
    return postRepository.updatePosts(postId, data);
  }

  Future<void> updateUserPost(
    String accountId,
    String postId,
    Map<String, dynamic> data,
  ) {
    return postRepository.updateUserPost(accountId, postId, data);
  }
}
