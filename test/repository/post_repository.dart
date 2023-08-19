import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/services/post_firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_post.dart';
import 'post_repository.mocks.dart';

@GenerateMocks([
  PostFirestoreService,
  DocumentReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
  ProviderRef<PostRepository>,
])
void main() {
  late PostRepository postFirestoreRepository;
  late MockPostFirestoreService mockPostFirestoreService;
  late MockDocumentReference mockDocumentReference;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockProviderRef<PostRepository> ref;

  setUp(() {
    mockPostFirestoreService = MockPostFirestoreService();
    ref = MockProviderRef<PostRepository>();
    postFirestoreRepository = PostRepository(ref);
    mockDocumentReference = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
  });

  final fakePost = FakePost().post();
  final fakeMockAccountId = FakePost().mockAccountId;

  group('post firestore repository', () {
    group('Add Post', () {
      test('add post', () async {
        when(mockPostFirestoreService.addPost(any))
            .thenAnswer((_) async => mockDocumentReference);
        when(mockDocumentReference.id).thenReturn(fakeMockAccountId);
        when(mockPostFirestoreService.addUserPost(any, any, any))
            .thenAnswer((_) async {});
        final result = await postFirestoreRepository.addPost(fakePost);
        verify(mockPostFirestoreService.addPost(any)).called(1);
        verify(
          mockPostFirestoreService
              .addUserPost(fakePost.postAccountId, fakeMockAccountId, {
            'post_id': fakeMockAccountId,
            'created_time': isA<Timestamp>(),
          }),
        ).called(1);
        expect(result, true);
      });

      test('addPost throws FirebaseException', () async {
        when(mockPostFirestoreService.addPost(any)).thenThrow(
          FirebaseException(plugin: 'test', message: 'test exception'),
        );
        final result = await postFirestoreRepository.addPost(fakePost);
        verifyNever(mockPostFirestoreService.addUserPost(any, any, any));
        expect(result, false);
      });
    });

    group('Delete all posts', () {
      test('delete all posts', () async {
        when(mockPostFirestoreService.getUserPosts(any))
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.id).thenReturn(fakePost.postAccountId);
        final result =
            await postFirestoreRepository.deleteAllPosts(fakeMockAccountId);
        verify(mockPostFirestoreService.getUserPosts(fakeMockAccountId))
            .called(1);
        verify(mockPostFirestoreService.deletePost(fakePost.postAccountId))
            .called(1);
        verify(
          mockPostFirestoreService.deleteUserPost(
            fakeMockAccountId,
            fakePost.postAccountId,
          ),
        ).called(1);
        expect(result, true);
      });

      test('delete all posts throws FirebaseException', () async {
        when(mockPostFirestoreService.getUserPosts(any)).thenThrow(
          FirebaseException(plugin: 'test', message: 'test exception'),
        );
        final result =
            await postFirestoreRepository.deleteAllPosts(fakeMockAccountId);
        verify(mockPostFirestoreService.getUserPosts(fakeMockAccountId))
            .called(1);
        verifyNever(mockPostFirestoreService.deletePost(any));
        verifyNever(mockPostFirestoreService.deleteUserPost(any, any));
        expect(result, false);
      });
    });

    group('Delete post', () {
      test('delete post', () async {
        when(mockPostFirestoreService.deletePost(any))
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.id).thenReturn(fakePost.postAccountId);
        final result = await postFirestoreRepository.deletePost(
          fakeMockAccountId,
          fakePost,
        );
        verify(mockPostFirestoreService.deletePost(any)).called(1);
        verifyNever(mockPostFirestoreService.deletePost(any));
        expect(result, true);
      });

      test('delete post throws FirebaseException', () async {
        when(mockPostFirestoreService.deletePost(any)).thenThrow(
          FirebaseException(plugin: 'test', message: 'test exception'),
        );
        final result = await postFirestoreRepository.deletePost(
          fakeMockAccountId,
          fakePost,
        );
        verify(mockPostFirestoreService.deletePost(any)).called(1);
        verifyNever(mockPostFirestoreService.deletePost(any));
        expect(result, false);
      });
    });
  });
}
