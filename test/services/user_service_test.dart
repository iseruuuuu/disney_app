import 'package:disney_app/core/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_user.dart';
import 'post_service_test.mocks.dart';
import 'user_service_test.mocks.dart';

@GenerateMocks([FirebaseStorage])
void main() {
  group('UserServiceTest', () {
    final ref = MockProviderRef<UserService>();
    final api = UserService(ref);
    final storage = MockFirebaseStorage();
    final firestore = MockFirebaseFirestore();
    final uid = FakeUser().uid;
    final docData = FakeUser().mockData;
    final filePath = FakeUser().filePath;

    setUp(() {});

    test('get user document', () async {
      await api.getUserDocument(uid);
      verify(firestore.collection('users').doc(uid).get()).called(1);
    });

    test('set user document', () async {
      await api.setUserDocument(uid, docData);
      verify(firestore.collection('users').doc(uid).set(docData)).called(1);
    });

    test('update user document', () async {
      await api.updateUserDocument(uid, docData);
      verify(firestore.collection('users').doc(uid).update(docData)).called(1);
    });

    test('delete user document', () async {
      await api.deleteUserDocument(uid);
      verify(firestore.collection('users').doc(uid).delete()).called(1);
    });

    test('get storage reference', () {
      api.getStorageReference(filePath);
      verify(storage.ref(filePath)).called(1);
    });

    test('ref from URL', () {
      api.refFromURL(filePath);
      verify(storage.refFromURL(filePath)).called(1);
    });
  });
}
