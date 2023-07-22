import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userFirestoreUsecaseProvider = Provider.autoDispose<UserFirestoreUsecase>(
  (ref) => UserFirestoreUsecase(
    UserFirestoreRepository(),
  ),
);

class UserFirestoreUsecase {
  UserFirestoreUsecase(this.firestoreRepository);

  final UserFirestoreRepository firestoreRepository;

  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String myAccountId) {
    return firestoreRepository.stream(myAccountId);
  }

  Future<dynamic> setUser(Account newAccount) async {
    return firestoreRepository.setUser(newAccount);
  }

  Future<dynamic> getUser(String uid) async {
    return firestoreRepository.getUser(uid);
  }

  Future<dynamic> updateUser(Account updateAccount) async {
    return firestoreRepository.updateUser(updateAccount);
  }

  Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async {
    return firestoreRepository.getPostUserMap(accountIds);
  }

  Future<dynamic> deleteUser(
    String accountId,
    String filePath,
    WidgetRef ref,
  ) async {
    return firestoreRepository.deleteUser(accountId, filePath, ref);
  }
}
