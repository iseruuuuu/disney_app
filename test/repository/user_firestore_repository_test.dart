import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_firestore_repository_test.mocks.dart';

@GenerateMocks([UserFirestoreAPI])
void main() {
  late UserFirestoreRepository userFirestoreRepository;
  late MockUserFirestoreAPI mockUserFirestoreAPI;

  setUp(() {
    mockUserFirestoreAPI = MockUserFirestoreAPI();
    userFirestoreRepository = UserFirestoreRepository(mockUserFirestoreAPI);
  });

  group('user firestore repository', () {
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
