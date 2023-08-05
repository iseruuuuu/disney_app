import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_user.dart';
import 'post_firestore_api_test.mocks.dart';
import 'user_firestore_api_test.mocks.dart';

@GenerateMocks([FirebaseStorage])
void main() {
  late UserFirestoreAPI api;
  late MockFirebaseFirestore firestore;
  late MockFirebaseStorage storage;
  final uid = FakeUser().uid;
  final docData = FakeUser().mockData;
  final filePath = FakeUser().filePath;

  setUp(() {
    firestore = MockFirebaseFirestore();
    storage = MockFirebaseStorage();
    api = UserFirestoreAPI();
  });

  test('getUserDocument', () async {
    await api.getUserDocument(uid);
    verify(firestore.collection('users').doc(uid).get()).called(1);
  });

  test('setUserDocument', () async {
    await api.setUserDocument(uid, docData);
    verify(firestore.collection('users').doc(uid).set(docData)).called(1);
  });

  test('updateUserDocument', () async {
    await api.updateUserDocument(uid, docData);
    verify(firestore.collection('users').doc(uid).update(docData)).called(1);
  });

  test('deleteUserDocument', () async {
    await api.deleteUserDocument(uid);
    verify(firestore.collection('users').doc(uid).delete()).called(1);
  });

  test('getStorageReference', () {
    api.getStorageReference(filePath);
    verify(storage.ref(filePath)).called(1);
  });

  test('refFromURL', () {
    api.refFromURL(filePath);
    verify(storage.refFromURL(filePath)).called(1);
  });

  test('stream', () {
    api.stream(uid);
    verify(
      firestore
          .collection('users')
          .doc(uid)
          .collection('my_posts')
          .orderBy('created_time', descending: true)
          .snapshots(),
    ).called(1);
  });
}
