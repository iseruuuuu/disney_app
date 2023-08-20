import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/usecase/post_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_post.dart';
import '../repository/user_repository_test.mocks.dart';

@GenerateMocks([
  PostRepository,
  ProviderRef<PostUsecase>,
])
void main() {
  group('Post FireStore Usecase Test', () {
    late MockPostRepository mockPostRepository;
    late PostUsecase postFireStoreUsecase;
    late MockProviderRef<PostUsecase> ref;

    setUp(() {
      mockPostRepository = MockPostRepository();
      ref = MockProviderRef<PostUsecase>();
      postFireStoreUsecase = PostUsecase(ref);
    });

    final fakePost = FakePost().post();
    final fakeMockAccountId = FakePost().mockAccountId;

    test('Add Post', () async {
      when(mockPostRepository.addPost(fakePost))
          .thenAnswer((_) async => 'Success');

      final result = await postFireStoreUsecase.addPost(fakePost);

      verify(mockPostRepository.addPost(fakePost)).called(1);
      expect(result, 'Success');
    });

    test('deleteAllPosts', () async {
      when(mockPostRepository.deleteAllPosts(fakeMockAccountId))
          .thenAnswer((_) async => null);

      await postFireStoreUsecase.deleteAllPosts(fakeMockAccountId);

      verify(mockPostRepository.deleteAllPosts(fakeMockAccountId));
    });

    test('Delete Post', () async {
      when(mockPostRepository.deletePost('accountId', fakePost))
          .thenAnswer((_) async => 'Success');

      final result =
          await postFireStoreUsecase.deletePost('accountId', fakePost);

      verify(mockPostRepository.deletePost('accountId', fakePost)).called(1);
      expect(result, 'Success');
    });
  });
}
