import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_user.dart';
import 'user_firestore_usecase_test.mocks.dart';

@GenerateMocks([UserFirestoreRepository])
void main() {
  group('User FireStore Usecase Test', () {
    late MockUserFirestoreRepository mockUserFirestoreRepository;
    late UserFirestoreUsecase userFireStoreUsecase;

    setUp(() {
      mockUserFirestoreRepository = MockUserFirestoreRepository();
      userFireStoreUsecase = UserFirestoreUsecase(mockUserFirestoreRepository);
    });

    final fakeUser = FakeUser().mockAccount();
    final fakeMockIds = FakeUser().mockIds;
    final fakeMockUsers = FakeUser().mockUsers;
    final fakeMockAccountId = FakeUser().mockAccountId;
    final fakeMockImage = FakeUser().mockImage;

    final account1 = FakeUser().account1;
    final account2 = FakeUser().account2;

    final accountMap = <String, Account>{
      account1.id: FakeUser().account1,
      account2.id: FakeUser().account2,
    };

    test('stream', () {
      final controller =
          StreamController<QuerySnapshot<Map<String, dynamic>>>();

      when(mockUserFirestoreRepository.stream(fakeMockAccountId))
          .thenAnswer((_) => controller.stream);

      final result = userFireStoreUsecase.stream(fakeMockAccountId);

      expect(result, isA<Stream<QuerySnapshot<Map<String, dynamic>>>>());

      controller.close();
    });

    test('Set User', () async {
      when(mockUserFirestoreRepository.setUser(fakeUser))
          .thenAnswer((_) async => 'Success');

      final result = await userFireStoreUsecase.setUser(fakeUser);

      verify(mockUserFirestoreRepository.setUser(fakeUser)).called(1);

      expect(result, 'Success');
    });

    test('Get User', () async {
      when(mockUserFirestoreRepository.getUser(fakeMockAccountId)).thenAnswer(
        (_) async => 'Success',
      );

      final result = await userFireStoreUsecase.getUser(fakeMockAccountId);

      verify(mockUserFirestoreRepository.getUser(fakeMockAccountId)).called(1);

      expect(result, 'Success');
    });

    test('Update User', () async {
      when(mockUserFirestoreRepository.updateUser(fakeUser)).thenAnswer(
        (_) async => 'Success',
      );

      final result = await userFireStoreUsecase.updateUser(fakeUser);

      expect(result, 'Success');
    });

    test('GetPostUserMap', () async {
      when(mockUserFirestoreRepository.getPostUserMap(fakeMockIds)).thenAnswer(
        (_) async => accountMap,
      );

      final result = await userFireStoreUsecase.getPostUserMap(fakeMockIds);

      expect(result, accountMap);
    });
  });
}
