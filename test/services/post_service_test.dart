import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/firebase/firebase_provider.dart';
import 'package:disney_app/core/services/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_post.dart';
import 'post_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
])
void main() {
  group('PostFirestoreAPI', () {
    late PostService postService;
    late MockFirebaseFirestore mockFirebaseFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
    late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
    final fakeAccountId = FakePost().mockAccountId;
    final fakePostId = FakePost().mockPostId;
    final fakeUserPostData = FakePost().userPostData;
    late ProviderContainer container;

    setUp(() {
      mockFirebaseFirestore = MockFirebaseFirestore();
      mockDocumentReference = MockDocumentReference();
      mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
      when(mockFirebaseFirestore.collection(any))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      container = ProviderContainer(
        overrides: [
          firebaseFirestoreProvider.overrideWithValue(mockFirebaseFirestore),
        ],
      );
      postService = container.read(postServiceProvider);
    });

    test('addPost calls Firestore with correct path and data', () async {
      when(mockCollectionReference.add(fakeUserPostData))
          .thenAnswer((_) async => mockDocumentReference);
      final result = await postService.addPost(fakeUserPostData);
      expect(result, mockDocumentReference);
      verify(mockCollectionReference.add(fakeUserPostData)).called(1);
    });

    test('add user post', () async {
      await postService.addUserPost(
        fakeAccountId,
        fakePostId,
        fakeUserPostData,
      );
      verify(mockCollectionReference.doc(fakePostId).set(fakeUserPostData))
          .called(1);
    });

    test('get user posts', () async {
      await postService.getUserPosts(fakeAccountId);
      verify(mockCollectionReference.get()).called(1);
    });

    test('get post', () async {
      await postService.getPost(fakePostId);
      verify(mockCollectionReference.doc(fakePostId).get()).called(1);
    });

    test('delete post', () async {
      await postService.deletePost(fakePostId);
      verify(mockCollectionReference.doc(fakePostId).delete()).called(1);
    });

    test('delete user post', () async {
      await postService.deleteUserPost(fakeAccountId, fakePostId);
      verify(mockCollectionReference.doc(fakePostId).delete()).called(1);
    });

    tearDown(() {
      container.dispose();
    });
  });
}
