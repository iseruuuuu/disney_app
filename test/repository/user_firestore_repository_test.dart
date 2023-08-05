import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';
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
])
void main() {
  late UserFirestoreRepository userFirestoreRepository;
  late MockUserFirestoreAPI mockUserFirestoreAPI;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockWidgetRef mockWidgetRef;

  setUp(() {
    mockUserFirestoreAPI = MockUserFirestoreAPI();
    userFirestoreRepository = UserFirestoreRepository(mockUserFirestoreAPI);
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockWidgetRef = MockWidgetRef();
  });
  final fakeUser = FakeUser().mockAccount();
  final fakeMockAccountId = FakeUser().mockAccountId;
  final fakeMockImage = FakeUser().mockImage;
  final accountMap = <String, Account>{
    FakeUser().account1.id: FakeUser().account1,
    FakeUser().account2.id: FakeUser().account2,
  };
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

    test('get post user map', () async {
      when(mockDocumentSnapshot.data()).thenReturn(fakeMockData);
      for (final id in fakeMockIds) {
        when(mockUserFirestoreAPI.getUserDocument(id))
            .thenAnswer((_) async => mockDocumentSnapshot);
      }
      final result = await userFirestoreRepository.getPostUserMap(fakeMockIds);
      expect(result, isA<Map<String, Account>>());
    });
  });
}
