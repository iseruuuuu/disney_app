import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/repository/user_repository.dart';
import 'package:disney_app/core/model/usecase/user_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../fake/fake_user.dart';
import 'user_firestore_usecase_test.mocks.dart';

@GenerateMocks([
  UserRepository,
  WidgetRef,
])
void main() {
  group('User FireStore Usecase Test', () {
    late MockUserRepository mockUserRepository;
    late UserUsecase userFireStoreUsecase;
    late MockWidgetRef mockWidgetRef;
    setUp(() {
      mockUserRepository = MockUserRepository();
      userFireStoreUsecase = UserUsecase(mockUserRepository);
      mockWidgetRef = MockWidgetRef();
    });
    final fakeUser = FakeUser().mockAccount();
    final fakeMockAccountId = FakeUser().mockAccountId;

    test('Set User', () async {
      when(mockUserRepository.setUser(fakeUser)).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.setUser(fakeUser),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserRepository.setUser(fakeUser))
          .thenAnswer((_) async => 'Success');
      final result = await userFireStoreUsecase.setUser(fakeUser);
      verify(mockUserRepository.setUser(fakeUser)).called(2);
      expect(result, 'Success');
    });

    test('Get User', () async {
      when(mockUserRepository.getUser(fakeMockAccountId)).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.getUser(fakeMockAccountId),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserRepository.getUser(fakeMockAccountId)).thenAnswer(
        (_) async => 'Success',
      );
      final result = await userFireStoreUsecase.getUser(fakeMockAccountId);
      verify(mockUserRepository.getUser(fakeMockAccountId)).called(2);
      expect(result, 'Success');
    });

    test('Update User', () async {
      when(mockUserRepository.updateUser(fakeUser)).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.updateUser(fakeUser),
        throwsA(isA<FirebaseException>()),
      );
      when(mockUserRepository.updateUser(fakeUser)).thenAnswer(
        (_) async => 'Success',
      );
      final result = await userFireStoreUsecase.updateUser(fakeUser);
      verify(mockUserRepository.updateUser(fakeUser)).called(2);
      expect(result, 'Success');
    });

    test('Delete User', () async {
      when(
        mockUserRepository.deleteUser(
          fakeUser,
          mockWidgetRef,
        ),
      ).thenAnswer(
        (_) => Future.error(
          FirebaseException(message: 'Error occurred', plugin: 'plugin'),
        ),
      );
      expect(
        userFireStoreUsecase.deleteUser(
          fakeUser,
          mockWidgetRef,
        ),
        throwsA(isA<FirebaseException>()),
      );
      when(
        mockUserRepository.deleteUser(
          fakeUser,
          mockWidgetRef,
        ),
      ).thenAnswer(
        (_) async => 'Success',
      );
      final result = await userFireStoreUsecase.deleteUser(
        fakeUser,
        mockWidgetRef,
      );
      verify(
        mockUserRepository.deleteUser(
          fakeUser,
          mockWidgetRef,
        ),
      ).called(2);
      expect(result, 'Success');
    });
  });
}
