import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/api/user_firestore_api.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserFirestoreRepository {
  UserFirestoreRepository(this.firestoreAPI);

  final UserFirestoreAPI firestoreAPI;

  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String myAccountId) {
    return firestoreAPI.stream(myAccountId);
  }

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

  Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async {
    final map = <String, Account>{};
    try {
      for (final accountId in accountIds) {
        final doc = await firestoreAPI.getUserDocument(accountId);
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final postAccount = Account(
            id: accountId,
            name: data['name'],
            userId: data['user_id'],
            imagePath: data['image_path'],
            selfIntroduction: data['self_introduction'],
            createdTime: data['created_time'],
            updateTime: data['updated_time'],
          );
          map[accountId] = postAccount;
        }
      }
      return map;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  Future<dynamic> deleteUser(
    String accountId,
    String filePath,
    WidgetRef ref,
  ) async {
    try {
      await firestoreAPI.deleteUserDocument(accountId);
      await ref.read(postUsecaseProvider).deleteAllPosts(accountId);
      final storageReference = firestoreAPI.getStorageReference(filePath);
      await storageReference.delete();
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}
