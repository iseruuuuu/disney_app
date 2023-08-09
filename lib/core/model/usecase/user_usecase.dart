import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/api/post_firestore_api.dart';
import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:disney_app/core/model/repository/post_repository.dart';
import 'package:disney_app/core/model/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userUsecaseProvider = Provider.autoDispose<UserUsecase>(
  (ref) => UserUsecase(
    UserRepository(
      UserFirestoreAPI(),
      PostRepository(
        PostFirestoreAPI(firebaseInstance: FirebaseFirestore.instance),
      ),
    ),
  ),
);

class UserUsecase {
  UserUsecase(this.userRepository);

  final UserRepository userRepository;

  Future<dynamic> setUser(Account newAccount) async {
    return userRepository.setUser(newAccount);
  }

  Future<dynamic> getUser(String uid) async {
    return userRepository.getUser(uid);
  }

  Future<dynamic> updateUser(Account updateAccount) async {
    return userRepository.updateUser(updateAccount);
  }

  Future<dynamic> deleteUser(
    Account myAccount,
    WidgetRef ref,
  ) async {
    return userRepository.deleteUser(myAccount, ref);
  }
}
