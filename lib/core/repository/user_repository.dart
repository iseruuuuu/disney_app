import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/repository/post_repository.dart';
import 'package:disney_app/core/services/authentication.dart';
import 'package:disney_app/core/services/user_firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersFamily =
    FutureProvider.autoDispose.family<Account, String>((ref, uid) {
  return ref.watch(userSnapShotsFamily(uid).future).then((event) {
    final dataMap = event.data();
    final data = dataMap! as Map<String, dynamic>;
    final myAccount = Account.fromMap(data, uid);
    return myAccount;
  });
});

final postUsersFamily =
    FutureProvider.autoDispose.family<Account, String>((ref, accountId) {
  return ref.watch(userSnapShotsFamily(accountId).future).then((event) {
    final dataMap = event.data();
    final data = dataMap! as Map<String, dynamic>;
    final myAccount = Account.fromMap(data, accountId);
    return myAccount;
  });
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref);
});

class UserRepository {
  UserRepository(ProviderRef<UserRepository> ref) {
    firestoreAPI = ref.read(userFirestoreServiceProvider);
    firestoreRepository = ref.read(postRepositoryProvider);
  }

  late final UserFirestoreService firestoreAPI;
  late final PostRepository firestoreRepository;

  Future<dynamic> setUser(Account newAccount) async {
    try {
      await firestoreAPI.setUserDocument(newAccount.id, {
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'update_time': Timestamp.now(),
      });
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<dynamic> getUser(String uid) async {
    try {
      final documentSnapshot = await firestoreAPI.getUserDocument(uid);
      final data = documentSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        final myAccount = Account(
          id: uid,
          name: data['name'],
          userId: data['user_id'],
          selfIntroduction: data['self_introduction'],
          imagePath: data['image_path'],
          createdTime: data['created_time'],
          updateTime: data['updated_time'],
        );

        Authentication.myAccount = myAccount;
        return true;
      } else {
        throw Exception('Document does not exist.');
      }
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<dynamic> updateUser(Account updateAccount) async {
    try {
      await firestoreAPI.updateUserDocument(updateAccount.id, {
        'name': updateAccount.name,
        'image_path': updateAccount.imagePath,
        'user_id': updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'updated_time': Timestamp.now(),
      });
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<dynamic> deleteUser(
    Account myAccount,
    WidgetRef ref,
  ) async {
    try {
      await firestoreAPI.deleteUserDocument(myAccount.id);
      await firestoreRepository.deleteAllPosts(myAccount.id);
      final storageReference = firestoreAPI.refFromURL(myAccount.imagePath);
      await storageReference.delete();
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}
