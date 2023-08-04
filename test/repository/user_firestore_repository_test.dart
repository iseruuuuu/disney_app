import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fake/fake_user.dart';
import 'user_firestore_repository_test.mocks.dart';

@GenerateMocks([UserFirestoreAPI])
void main() {
  late UserFirestoreRepository userFirestoreRepository;
  late MockUserFirestoreAPI mockUserFirestoreAPI;

  setUp(() {
    mockUserFirestoreAPI = MockUserFirestoreAPI();
    userFirestoreRepository = UserFirestoreRepository(mockUserFirestoreAPI);
  });
  final fakeUser = FakeUser().mockAccount();
  final fakeMockIds = FakeUser().mockIds;
  final fakeMockAccountId = FakeUser().mockAccountId;
  final fakeMockImage = FakeUser().mockImage;
  final accountMap = <String, Account>{
    FakeUser().account1.id: FakeUser().account1,
    FakeUser().account2.id: FakeUser().account2,
  };

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
      final mockAccount = Account(
        id: 'testID',
        name: 'testName',
        userId: 'testUserId',
        selfIntroduction: 'testIntroduction',
        imagePath: 'testImagePath',
        createdTime: Timestamp.now(),
        updateTime: Timestamp.now(),
      );

      when(mockUserFirestoreAPI.setUserDocument(any, any))
          .thenAnswer((_) async => true);

      final result = await userFirestoreRepository.setUser(mockAccount);

      expect(result, true);
    });
  });
}
