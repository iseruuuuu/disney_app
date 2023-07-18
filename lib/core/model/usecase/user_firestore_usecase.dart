// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/repository/user_firestore_repository.dart';

final userFirestoreUsecaseProvider = Provider.autoDispose<UserFirestoreUsecase>(
  (ref) => UserFirestoreUsecase(
    UserFirestoreRepository(),
  ),
);

class UserFirestoreUsecase {
  final UserFirestoreRepository firestoreRepository;

  UserFirestoreUsecase(this.firestoreRepository);

  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String myAccountId) {
    return firestoreRepository.stream(myAccountId);
  }

  Future<dynamic> setUser(Account newAccount) async {
    return await firestoreRepository.setUser(newAccount);
  }

  Future<dynamic> getUser(String uid) async {
    return await firestoreRepository.getUser(uid);
  }

  Future<dynamic> updateUser(Account updateAccount) async {
    return await firestoreRepository.updateUser(updateAccount);
  }

  Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async {
    return await firestoreRepository.getPostUserMap(accountIds);
  }

  Future<dynamic> deleteUser(String accountId, WidgetRef ref) async {
    return await firestoreRepository.deleteUser(accountId, ref);
  }
}
