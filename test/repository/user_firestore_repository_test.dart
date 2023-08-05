import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:disney_app/core/model/repository/post_firestore_repository.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';
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
  PostFirestoreRepository,
])
void main() {
  late UserFirestoreRepository userFirestoreRepository;
  late MockUserFirestoreAPI mockUserFirestoreAPI;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockWidgetRef mockWidgetRef;
  late MockReference mockReference;
  late MockPostFirestoreRepository mockPostFirestoreRepository;

  setUp(() {
    mockUserFirestoreAPI = MockUserFirestoreAPI();
    mockPostFirestoreRepository = MockPostFirestoreRepository();
    userFirestoreRepository = UserFirestoreRepository(
      mockUserFirestoreAPI,
      mockPostFirestoreRepository,
    );
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockWidgetRef = MockWidgetRef();
    mockReference = MockReference();
  });
  final fakeUser = FakeUser().mockAccount();
  final fakeMockAccountId = FakeUser().mockAccountId;
  final fakeMockIds = FakeUser().fakeMockIds;
  final fakeMockData = FakeUser().mockData;

  group('user firestore repository', () {
    test('stream', () {
      final controller =
          StreamController<QuerySnapshot<Map<String, dynamic>>>();
      when(mockUserFirestoreAPI.stream(fakeMockAccountId))
          .thenAnswer((_) => controller.stream);
      final result = userFirestoreRepository.stream(fakeMockAccountId);
      verify(mockUserFirestoreAPI.stream(fakeMockAccountId)).called(1);
      expect(result, isA<Stream<QuerySnapshot<Map<String, dynamic>>>>());
      controller.close();
    });

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

    test('get post user map', () async {
      when(mockDocumentSnapshot.data()).thenReturn(fakeMockData);
      for (final id in fakeMockIds) {
        when(mockUserFirestoreAPI.getUserDocument(id))
            .thenAnswer((_) async => mockDocumentSnapshot);
      }
      final result = await userFirestoreRepository.getPostUserMap(fakeMockIds);
      expect(result, isA<Map<String, Account>>());
    });

    test('delete user', () async {
      // Arrange
      when(mockUserFirestoreAPI.deleteUserDocument(fakeUser.id))
          .thenAnswer((_) async {});
      when(mockPostFirestoreRepository.deleteAllPosts(fakeUser.id))
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
      verify(mockPostFirestoreRepository.deleteAllPosts(fakeUser.id)).called(1);
      verify(mockUserFirestoreAPI.refFromURL(fakeUser.imagePath)).called(1);
      verify(mockReference.delete()).called(1);
      expect(result, true);
    });
  });
}
