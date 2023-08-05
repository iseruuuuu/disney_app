import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/repository/post_firestore_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fake/fake_post.dart';
import 'post_firestore_repository.mocks.dart';

@GenerateMocks([
  PostFirestoreAPI,
  PostFirestoreRepository,
  DocumentSnapshot,
  WidgetRef,
  Reference,
  DocumentReference,
])
void main() {
  late PostFirestoreRepository postFirestoreRepository;
  late MockPostFirestoreAPI mockPostFirestoreAPI;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockWidgetRef mockWidgetRef;
  late MockReference mockReference;
  late MockPostFirestoreRepository mockPostFirestoreRepository;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockPostFirestoreAPI = MockPostFirestoreAPI();
    mockPostFirestoreRepository = MockPostFirestoreRepository();
    postFirestoreRepository = PostFirestoreRepository(
      mockPostFirestoreAPI,
    );
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockWidgetRef = MockWidgetRef();
    mockReference = MockReference();
    mockDocumentReference = MockDocumentReference();
  });

  final fakePost = FakePost().post();
  final fakeMockIds = FakePost().mockIds;
  final fakeMockPosts = FakePost().mockPosts;
  final fakeMockAccountId = FakePost().mockAccountId;

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
      when(mockDocumentReference.id).thenReturn('testPostId');
      when(mockPostFirestoreAPI.addUserPost(any, any, any))
          .thenAnswer((_) async {});
      final result = await postFirestoreRepository.addPost(fakePost);
      verify(mockPostFirestoreAPI.addPost(any)).called(1);
      verify(
        mockPostFirestoreAPI.addUserPost(fakePost.postAccountId, 'testPostId', {
          'post_id': 'testPostId',
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
        'content': 'test content',
        'post_account_id': 'testAccountId',
        'created_time': Timestamp.now(),
        'rank': 5,
        'attraction_name': 'test attraction',
        'is_spoiler': false,
      });
      when(mockDocumentSnapshot.id).thenReturn('testPostId');
      final result =
          await postFirestoreRepository.getPostsFromIds(['id1', 'id2']);
      verify(mockPostFirestoreAPI.getPost('id1')).called(1);
      verify(mockPostFirestoreAPI.getPost('id2')).called(1);
      expect(result!.length, 2);
      expect(result[0].id, 'testPostId');
      expect(result[1].id, 'testPostId');
    });

    test('get posts from ids FirebaseException', () async {
      when(mockPostFirestoreAPI.getPost(any)).thenThrow(
        FirebaseException(plugin: 'test', message: 'test exception'),
      );
      final result =
          await postFirestoreRepository.getPostsFromIds(['id1', 'id2']);
      verify(mockPostFirestoreAPI.getPost('id1')).called(1);
      verifyNever(mockPostFirestoreAPI.getPost('id2'));
      expect(result, null);
    });
  });
}
