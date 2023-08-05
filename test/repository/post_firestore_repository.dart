import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/repository/post_firestore_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_post.dart';
import 'post_firestore_repository.mocks.dart';

@GenerateMocks([
  PostFirestoreAPI,
  DocumentSnapshot,
  DocumentReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late PostFirestoreRepository postFirestoreRepository;
  late MockPostFirestoreAPI mockPostFirestoreAPI;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockDocumentReference mockDocumentReference;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;

  setUp(() {
    mockPostFirestoreAPI = MockPostFirestoreAPI();
    postFirestoreRepository = PostFirestoreRepository(
      mockPostFirestoreAPI,
    );
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockDocumentReference = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
  });

  //TODO できるだけこの値を使えるようにしたい！！
  final fakePost = FakePost().post();
  final fakeMockIds = FakePost().mockIds;
  final fakeMockPosts = FakePost().mockPosts;
  final fakeMockAccountId = FakePost().mockAccountId;
  final fakeMockGetPostsFromIds = FakePost().mockGetPostsFromIds;

  group('post firestore repository', () {
    test('stream', () {
      final controller =
          StreamController<QuerySnapshot<Map<String, dynamic>>>();
      when(mockPostFirestoreAPI.streamPosts())
          .thenAnswer((_) => controller.stream);
      final result = postFirestoreRepository.stream();
      expect(result, isA<Stream<QuerySnapshot<Map<String, dynamic>>>>());
      controller.close();
    });

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

    test('get posts from ids', () async {
      when(mockPostFirestoreAPI.getPost(any))
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.data()).thenReturn({
        'content': fakePost.content,
        'post_account_id': fakePost.postAccountId,
        'created_time': Timestamp.now(),
        'rank': 5,
        'attraction_name': fakePost.attractionName,
        'is_spoiler': false,
      });
      when(mockDocumentSnapshot.id).thenReturn(fakeMockAccountId);
      final result = await postFirestoreRepository
          .getPostsFromIds(fakeMockGetPostsFromIds);
      verify(mockPostFirestoreAPI.getPost(fakeMockGetPostsFromIds[0]))
          .called(1);
      verify(mockPostFirestoreAPI.getPost(fakeMockGetPostsFromIds[1]))
          .called(1);
      expect(result!.length, 2);
      expect(result[0].id, fakeMockAccountId);
      expect(result[1].id, fakeMockAccountId);
    });

    test('get posts from ids FirebaseException', () async {
      when(mockPostFirestoreAPI.getPost(any)).thenThrow(
        FirebaseException(plugin: 'test', message: 'test exception'),
      );
      final result = await postFirestoreRepository
          .getPostsFromIds(fakeMockGetPostsFromIds);
      verify(mockPostFirestoreAPI.getPost(fakeMockGetPostsFromIds[0]))
          .called(1);
      verifyNever(mockPostFirestoreAPI.getPost(fakeMockGetPostsFromIds[1]));
      expect(result, null);
    });
  });

  test('delete all posts', () async {
    when(mockPostFirestoreAPI.getUserPosts(any))
        .thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    when(mockQueryDocumentSnapshot.id).thenReturn('testPostId');
    final result =
        await postFirestoreRepository.deleteAllPosts('testAccountId');
    verify(mockPostFirestoreAPI.getUserPosts('testAccountId')).called(1);
    verify(mockPostFirestoreAPI.deletePost('testPostId')).called(1);
    verify(mockPostFirestoreAPI.deleteUserPost('testAccountId', 'testPostId'))
        .called(1);
    expect(result, true);
  });

  test('deleteAllPosts throws FirebaseException', () async {
    when(mockPostFirestoreAPI.getUserPosts(any)).thenThrow(
      FirebaseException(plugin: 'test', message: 'test exception'),
    );
    final result =
        await postFirestoreRepository.deleteAllPosts('testAccountId');
    verify(mockPostFirestoreAPI.getUserPosts('testAccountId')).called(1);
    verifyNever(mockPostFirestoreAPI.deletePost(any));
    verifyNever(mockPostFirestoreAPI.deleteUserPost(any, any));
    expect(result, false);
  });

  test('delete post', () async {
    when(mockPostFirestoreAPI.deletePost(any))
        .thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
    when(mockQueryDocumentSnapshot.id).thenReturn('testPostId');
    final result =
        await postFirestoreRepository.deletePost('accountId', fakePost);
    verify(mockPostFirestoreAPI.deletePost(any)).called(1);
    verifyNever(mockPostFirestoreAPI.deletePost(any));
    expect(result, true);
  });

  test('delete post throws FirebaseException', () async {
    when(mockPostFirestoreAPI.deletePost(any)).thenThrow(
      FirebaseException(plugin: 'test', message: 'test exception'),
    );
    final result =
        await postFirestoreRepository.deletePost('accountId', fakePost);
    verify(mockPostFirestoreAPI.deletePost(any)).called(1);
    verifyNever(mockPostFirestoreAPI.deletePost(any));
    expect(result, false);
  });
}
