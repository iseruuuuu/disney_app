import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:disney_app/core/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fake/fake_user.dart';
import 'user_repository_test.mocks.dart';

@GenerateMocks([
  UserService,
  DocumentSnapshot,
  WidgetRef,
  Reference,
  PostRepository,
  ProviderRef<UserRepository>,
])
void main() {
  late UserRepository userFirestoreRepository;
  late MockUserFirestoreService mockUserFirestoreService;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockWidgetRef mockWidgetRef;
  late MockReference mockReference;
  late MockPostRepository mockPostRepository;
  late MockProviderRef<UserRepository> ref;

  setUp(() {
    mockUserFirestoreService = MockUserFirestoreService();
    ref = MockProviderRef<UserRepository>();
    mockPostRepository = MockPostRepository();
    userFirestoreRepository = UserRepository(ref);
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockWidgetRef = MockWidgetRef();
    mockReference = MockReference();
  });
  final fakeUser = FakeUser().mockAccount();
  final fakeMockAccountId = FakeUser().mockAccountId;
  final fakeMockData = FakeUser().mockData;

  group('user firestore repository', () {
    test('set user', () async {
      when(mockUserFirestoreService.setUserDocument(any, any))
          .thenAnswer((_) async => true);
      final result = await userFirestoreRepository.setUser(fakeUser);
      expect(result, true);
    });

    test('get user', () async {
      when(mockDocumentSnapshot.data()).thenReturn(fakeMockData);
      when(mockUserFirestoreService.getUserDocument(any))
          .thenAnswer((_) async => mockDocumentSnapshot);
      final result = await userFirestoreRepository.getUser(fakeMockAccountId);
      expect(result, true);
    });

    test('update user', () async {
      when(mockUserFirestoreService.updateUserDocument(fakeUser.id, any))
          .thenAnswer((_) async {});
      final result = await userFirestoreRepository.updateUser(fakeUser);
      verify(
        mockUserFirestoreService.updateUserDocument(fakeUser.id, {
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
      when(mockUserFirestoreService.deleteUserDocument(fakeUser.id))
          .thenAnswer((_) async {});
      when(mockPostRepository.deleteAllPosts(fakeUser.id))
          .thenAnswer((_) async {});
      when(mockUserFirestoreService.refFromURL(fakeUser.imagePath))
          .thenReturn(mockReference);
      when(mockReference.delete()).thenAnswer((_) async {});

      // Act
      final result = await userFirestoreRepository.deleteUser(
        fakeUser,
        mockWidgetRef,
      );
      // Assert
      verify(mockUserFirestoreService.deleteUserDocument(fakeUser.id))
          .called(1);
      verify(mockPostRepository.deleteAllPosts(fakeUser.id)).called(1);
      verify(mockUserFirestoreService.refFromURL(fakeUser.imagePath)).called(1);
      verify(mockReference.delete()).called(1);
      expect(result, true);
    });
  });
}
