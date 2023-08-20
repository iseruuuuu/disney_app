import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userUsecaseProvider = Provider<UserUsecase>((ref) {
  return UserUsecase(ref);
});

class UserUsecase {
  UserUsecase(ProviderRef<UserUsecase> ref) {
    userRepository = ref.read(userRepositoryProvider);
  }

  late final UserRepository userRepository;

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
