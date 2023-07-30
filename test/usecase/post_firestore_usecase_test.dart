import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/repository/post_firestore_repository.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_post.dart';
import 'post_firestore_usecase_test.mocks.dart';

@GenerateMocks([PostFirestoreRepository])
void main() {
  group('Post FireStore Usecase Test', () {
    late MockPostFirestoreRepository mockPostFirestoreRepository;
    late PostFireStoreUsecase postFireStoreUsecase;

    setUp(() {
      mockPostFirestoreRepository = MockPostFirestoreRepository();
      postFireStoreUsecase = PostFireStoreUsecase(mockPostFirestoreRepository);
    });

    final fakePost = FakePost().post();
    final fakeMockIds = FakePost().mockIds;
    final fakeMockPosts = FakePost().mockPosts;
    final fakeMockAccountId = FakePost().mockAccountId;

    test('Stream', () {
      final controller =
          StreamController<QuerySnapshot<Map<String, dynamic>>>();

      when(mockPostFirestoreRepository.stream())
          .thenAnswer((_) => controller.stream);

      final result = postFireStoreUsecase.stream();

      expect(result, isA<Stream<QuerySnapshot<Map<String, dynamic>>>>());

      controller.close();
    });

    test('Add Post', () async {
      when(mockPostFirestoreRepository.addPost(fakePost))
          .thenAnswer((_) async => 'Success');

      final result = await postFireStoreUsecase.addPost(fakePost);

      verify(mockPostFirestoreRepository.addPost(fakePost)).called(1);
      expect(result, 'Success');
    });

    test('getPostsFromIds', () async {
      when(mockPostFirestoreRepository.getPostsFromIds(fakeMockIds)).thenAnswer(
        (_) async => fakeMockPosts,
      );
      final result = await postFireStoreUsecase.getPostsFromIds(fakeMockIds);

      expect(result, fakeMockPosts);
    });

    test('deleteAllPosts', () async {
      when(mockPostFirestoreRepository.deleteAllPosts(fakeMockAccountId))
          .thenAnswer((_) async => null);

      await postFireStoreUsecase.deleteAllPosts(fakeMockAccountId);

      verify(mockPostFirestoreRepository.deleteAllPosts(fakeMockAccountId));
    });

    test('Delete Post', () async {
      when(mockPostFirestoreRepository.deletePost('accountId', fakePost))
          .thenAnswer((_) async => 'Success');

      final result =
          await postFireStoreUsecase.deletePost('accountId', fakePost);

      verify(mockPostFirestoreRepository.deletePost('accountId', fakePost))
          .called(1);
      expect(result, 'Success');
    });
  });
}
