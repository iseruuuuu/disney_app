import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:disney_app/core/model/repository/post_repository.dart';
import 'package:disney_app/core/model/repository/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fake/fake_user.dart';
import 'user_firestore_repository_test.mocks.dart';

@GenerateMocks([
  UserFirestoreAPI,
  DocumentSnapshot,
  WidgetRef,
  Reference,
  PostRepository,
])
void main() {
  late UserRepository userFirestoreRepository;
  late MockUserFirestoreAPI mockUserFirestoreAPI;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockWidgetRef mockWidgetRef;
  late MockReference mockReference;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockUserFirestoreAPI = MockUserFirestoreAPI();
    mockPostRepository = MockPostRepository();
    userFirestoreRepository = UserRepository(
      mockUserFirestoreAPI,
      mockPostRepository,
    );
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockWidgetRef = MockWidgetRef();
    mockReference = MockReference();
  });
  final fakeUser = FakeUser().mockAccount();
  final fakeMockAccountId = FakeUser().mockAccountId;
  final fakeMockData = FakeUser().mockData;

  group('user firestore repository', () {
    test('set user', () async {
      when(mockUserFirestoreAPI.setUserDocument(any, any))
          .thenAnswer((_) async => true);
      final result = await userFirestoreRepository.setUser(fakeUser);
      expect(result, true);
    });

    test('get user', () async {
      when(mockDocumentSnapshot.data()).thenReturn(fakeMockData);
      when(mockUserFirestoreAPI.getUserDocument(any))
          .thenAnswer((_) async => mockDocumentSnapshot);
      final result = await userFirestoreRepository.getUser(fakeMockAccountId);
      expect(result, true);
    });

    test('update user', () async {
      when(mockUserFirestoreAPI.updateUserDocument(fakeUser.id, any))
          .thenAnswer((_) async {});
      final result = await userFirestoreRepository.updateUser(fakeUser);
      verify(
        mockUserFirestoreAPI.updateUserDocument(fakeUser.id, {
          'name': fakeUser.name,
          'image_path': fakeUser.imagePath,
          'user_id': fakeUser.userId,
          'self_introduction': fakeUser.selfIntroduction,
          'updated_time': isA<Timestamp>(),
        }),
      ).called(1);
      expect(result, true);
    });

    test('delete user', () async {
      // Arrange
      when(mockUserFirestoreAPI.deleteUserDocument(fakeUser.id))
          .thenAnswer((_) async {});
      when(mockPostRepository.deleteAllPosts(fakeUser.id))
          .thenAnswer((_) async {});
      when(mockUserFirestoreAPI.refFromURL(fakeUser.imagePath))
          .thenReturn(mockReference);
      when(mockReference.delete()).thenAnswer((_) async {});

      // Act
      final result = await userFirestoreRepository.deleteUser(
        fakeUser,
        mockWidgetRef,
      );
      // Assert
      verify(mockUserFirestoreAPI.deleteUserDocument(fakeUser.id)).called(1);
      verify(mockPostRepository.deleteAllPosts(fakeUser.id)).called(1);
      verify(mockUserFirestoreAPI.refFromURL(fakeUser.imagePath)).called(1);
      verify(mockReference.delete()).called(1);
      expect(result, true);
    });
  });
}
