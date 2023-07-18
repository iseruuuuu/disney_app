// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/usecase/post_firestore_usecase.dart';
import 'package:disney_app/utils/authentication.dart';

class UserFirestoreRepository {
  static final firebaseStoreInstance = FirebaseFirestore.instance;
  static CollectionReference users = firebaseStoreInstance.collection('users');

  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String myAccountId) {
    return users
        .doc(myAccountId)
        .collection('my_posts')
        .orderBy(
          'created_time',
          descending: true,
        )
        .snapshots();
  }

  Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
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
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
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
    } on FirebaseException catch (_) {
      return false;
    }
  }

  Future<dynamic> updateUser(Account updateAccount) async {
    try {
      await users.doc(updateAccount.id).update({
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
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          selfIntroduction: data['self_introduction'],
          createdTime: data['created_time'],
          updateTime: data['update_time'],
        );
        map[accountId] = postAccount;
      });
      return map;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  Future<dynamic> deleteUser(String accountId, WidgetRef ref) async {
    users.doc(accountId).delete();
    ref.read(postUsecaseProvider).deleteAllPosts(accountId);
  }
}
