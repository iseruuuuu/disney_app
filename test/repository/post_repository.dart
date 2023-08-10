import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/repository/post_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_post.dart';
import 'post_repository.mocks.dart';

@GenerateMocks([
  PostFirestoreAPI,
  DocumentReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late PostRepository postFirestoreRepository;
  late MockPostFirestoreAPI mockPostFirestoreAPI;
  late MockDocumentReference mockDocumentReference;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;

  setUp(() {
    mockPostFirestoreAPI = MockPostFirestoreAPI();
    postFirestoreRepository = PostRepository(mockPostFirestoreAPI);
    mockDocumentReference = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
  });

  final fakePost = FakePost().post();
  final fakeMockAccountId = FakePost().mockAccountId;

  group('post firestore repository', () {
    group('Add Post', () {
      test('add post', () async {
        when(mockPostFirestoreAPI.addPost(any))
            .thenAnswer((_) async => mockDocumentReference);
        when(mockDocumentReference.id).thenReturn(fakeMockAccountId);
        when(mockPostFirestoreAPI.addUserPost(any, any, any))
            .thenAnswer((_) async {});
        final result = await postFirestoreRepository.addPost(fakePost);
        verify(mockPostFirestoreAPI.addPost(any)).called(1);
        verify(
          mockPostFirestoreAPI
              .addUserPost(fakePost.postAccountId, fakeMockAccountId, {
            'post_id': fakeMockAccountId,
            'created_time': isA<Timestamp>(),
          }),
        ).called(1);
        expect(result, true);
      });

      test('addPost throws FirebaseException', () async {
        when(mockPostFirestoreAPI.addPost(any)).thenThrow(
          FirebaseException(plugin: 'test', message: 'test exception'),
        );
        final result = await postFirestoreRepository.addPost(fakePost);
        verifyNever(mockPostFirestoreAPI.addUserPost(any, any, any));
        expect(result, false);
      });
    });

    group('Delete all posts', () {
      test('delete all posts', () async {
        when(mockPostFirestoreAPI.getUserPosts(any))
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.id).thenReturn(fakePost.postAccountId);
        final result =
            await postFirestoreRepository.deleteAllPosts(fakeMockAccountId);
        verify(mockPostFirestoreAPI.getUserPosts(fakeMockAccountId)).called(1);
        verify(mockPostFirestoreAPI.deletePost(fakePost.postAccountId))
            .called(1);
        verify(
          mockPostFirestoreAPI.deleteUserPost(
            fakeMockAccountId,
            fakePost.postAccountId,
          ),
        ).called(1);
        expect(result, true);
      });

      test('delete all posts throws FirebaseException', () async {
        when(mockPostFirestoreAPI.getUserPosts(any)).thenThrow(
          FirebaseException(plugin: 'test', message: 'test exception'),
        );
        final result =
            await postFirestoreRepository.deleteAllPosts(fakeMockAccountId);
        verify(mockPostFirestoreAPI.getUserPosts(fakeMockAccountId)).called(1);
        verifyNever(mockPostFirestoreAPI.deletePost(any));
        verifyNever(mockPostFirestoreAPI.deleteUserPost(any, any));
        expect(result, false);
      });
    });

    group('Delete post', () {
      test('delete post', () async {
        when(mockPostFirestoreAPI.deletePost(any))
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.id).thenReturn(fakePost.postAccountId);
        final result = await postFirestoreRepository.deletePost(
          fakeMockAccountId,
          fakePost,
        );
        verify(mockPostFirestoreAPI.deletePost(any)).called(1);
        verifyNever(mockPostFirestoreAPI.deletePost(any));
        expect(result, true);
      });

      test('delete post throws FirebaseException', () async {
        when(mockPostFirestoreAPI.deletePost(any)).thenThrow(
          FirebaseException(plugin: 'test', message: 'test exception'),
        );
        final result = await postFirestoreRepository.deletePost(
          fakeMockAccountId,
          fakePost,
        );
        verify(mockPostFirestoreAPI.deletePost(any)).called(1);
        verifyNever(mockPostFirestoreAPI.deletePost(any));
        expect(result, false);
      });
    });
  });
}
