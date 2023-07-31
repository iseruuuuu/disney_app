import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_user.dart';
import 'user_firestore_usecase_test.mocks.dart';

@GenerateMocks([
  UserFirestoreRepository,
  WidgetRef,
])
//TODO やること
// モックの呼び出しの検証

void main() {
  group('User FireStore Usecase Test', () {
    late MockUserFirestoreRepository mockUserFirestoreRepository;
    late UserFirestoreUsecase userFireStoreUsecase;
    late MockWidgetRef mockWidgetRef;
    setUp(() {
      mockUserFirestoreRepository = MockUserFirestoreRepository();
      userFireStoreUsecase = UserFirestoreUsecase(mockUserFirestoreRepository);
      mockWidgetRef = MockWidgetRef();
    });
    final fakeUser = FakeUser().mockAccount();
    final fakeMockIds = FakeUser().mockIds;
    final fakeMockAccountId = FakeUser().mockAccountId;
    final fakeMockImage = FakeUser().mockImage;
    final accountMap = <String, Account>{
      FakeUser().account1.id: FakeUser().account1,
      FakeUser().account2.id: FakeUser().account2,
    };
    test('stream', () {
      final controller =
          StreamController<QuerySnapshot<Map<String, dynamic>>>();
      when(mockUserFirestoreRepository.stream(fakeMockAccountId))
          .thenAnswer((_) => controller.stream);
      final result = userFireStoreUsecase.stream(fakeMockAccountId);
      verify(mockUserFirestoreRepository.stream(fakeMockAccountId)).called(1);
      expect(result, isA<Stream<QuerySnapshot<Map<String, dynamic>>>>());
      controller.close();
    });

    test('Set User', () async {
      when(mockUserFirestoreRepository.setUser(fakeUser)).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.setUser(fakeUser),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserFirestoreRepository.setUser(fakeUser))
          .thenAnswer((_) async => 'Success');
      final result = await userFireStoreUsecase.setUser(fakeUser);
      verify(mockUserFirestoreRepository.setUser(fakeUser)).called(2);
      expect(result, 'Success');
    });

    test('Get User', () async {
      when(mockUserFirestoreRepository.getUser(fakeMockAccountId)).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.getUser(fakeMockAccountId),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserFirestoreRepository.getUser(fakeMockAccountId)).thenAnswer(
        (_) async => 'Success',
      );
      final result = await userFireStoreUsecase.getUser(fakeMockAccountId);
      verify(mockUserFirestoreRepository.getUser(fakeMockAccountId)).called(2);
      expect(result, 'Success');
    });

    test('Update User', () async {
      when(mockUserFirestoreRepository.updateUser(fakeUser)).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.updateUser(fakeUser),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserFirestoreRepository.updateUser(fakeUser)).thenAnswer(
        (_) async => 'Success',
      );
      final result = await userFireStoreUsecase.updateUser(fakeUser);
      verify(mockUserFirestoreRepository.updateUser(fakeUser)).called(2);
      expect(result, 'Success');
    });

    test('GetPostUserMap', () async {
      when(mockUserFirestoreRepository.getPostUserMap(fakeMockIds)).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.getPostUserMap(fakeMockIds),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserFirestoreRepository.getPostUserMap(fakeMockIds)).thenAnswer(
        (_) async => accountMap,
      );
      final result = await userFireStoreUsecase.getPostUserMap(fakeMockIds);
      verify(mockUserFirestoreRepository.getPostUserMap(fakeMockIds)).called(2);
      expect(result, accountMap);
    });

    test('Delete User', () async {
      when(mockUserFirestoreRepository.deleteUser(
        fakeMockAccountId,
        fakeMockImage,
        mockWidgetRef,
      )).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.deleteUser(
          fakeMockAccountId,
          fakeMockImage,
          mockWidgetRef,
        ),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserFirestoreRepository.deleteUser(
        fakeMockAccountId,
        fakeMockImage,
        mockWidgetRef,
      )).thenAnswer(
        (_) async => 'Success',
      );
      final result = await userFireStoreUsecase.deleteUser(
        fakeMockAccountId,
        fakeMockImage,
        mockWidgetRef,
      );
      verify(
        mockUserFirestoreRepository.deleteUser(
          fakeMockAccountId,
          fakeMockImage,
          mockWidgetRef,
        ),
      ).called(2);
      expect(result, 'Success');
    });
  });
}
