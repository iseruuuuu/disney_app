import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_post.dart';
import 'post_api_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  Query<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
])
void main() {
  group('PostFirestoreAPI', () {
    final mockFirestore = MockFirebaseFirestore();
    final mockCollectionReference =
        MockCollectionReference<Map<String, dynamic>>();
    final mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    final mockQuery = MockQuery<Map<String, dynamic>>();
    final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
    final postFirestoreAPI = PostFirestoreAPI(firebaseInstance: mockFirestore);
    final fakePost = FakePost().post();
    final fakeMockAccountId = FakePost().mockAccountId;
    final fakeMockUserPostData = FakePost().userPostData;

    setUp(() {
      when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection(any))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(
        mockCollectionReference.orderBy(
          any,
          descending: anyNamed('descending'),
        ),
      ).thenReturn(mockQuery);
      when(mockQuery.snapshots())
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockCollectionReference.add(any))
          .thenAnswer((_) async => mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) async => {});
      when(mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentReference.delete()).thenAnswer((_) async => {});
    });

    test('addPost calls Firestore with correct path and data', () async {
      await postFirestoreAPI.addPost(fakeMockUserPostData);
      verify(mockCollectionReference.add(fakeMockUserPostData)).called(1);
    });

    test('add user post', () async {
      await postFirestoreAPI.addUserPost(
        fakeMockAccountId,
        fakePost.postAccountId,
        fakeMockUserPostData,
      );
      verify(mockCollectionReference.doc(fakeMockAccountId)).called(1);
      verify(mockDocumentReference.collection('my_posts')).called(1);
      verify(mockCollectionReference.doc(fakePost.postAccountId)).called(1);
      verify(mockDocumentReference.set(fakeMockUserPostData)).called(1);
    });

    test('get user posts', () async {
      await postFirestoreAPI.getUserPosts(fakeMockAccountId);
      verify(mockCollectionReference.doc(fakeMockAccountId)).called(1);
      verify(mockDocumentReference.collection('my_posts')).called(1);
    });

    test('get post', () async {
      await postFirestoreAPI.getPost(fakePost.postAccountId);
      verify(mockCollectionReference.doc(fakePost.postAccountId)).called(1);
    });

    test('delete post', () async {
      await postFirestoreAPI.deletePost(fakePost.postAccountId);
      verify(mockCollectionReference.doc(fakePost.postAccountId)).called(1);
      verify(mockDocumentReference.delete()).called(1);
    });

    test('delete user post', () async {
      await postFirestoreAPI.deleteUserPost(
        fakeMockAccountId,
        fakePost.postAccountId,
      );
      verify(mockCollectionReference.doc(fakeMockAccountId)).called(1);
      verify(mockDocumentReference.collection('my_posts')).called(1);
      verify(mockCollectionReference.doc(fakePost.postAccountId)).called(1);
      verify(mockDocumentReference.delete()).called(1);
    });
  });
}
