import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils {
  static Future<dynamic> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<String> uploadImage(
    String uid,
    File image,
  ) async {
    final storageInstance = FirebaseStorage.instance;
    final ref = storageInstance.ref();
    await ref.child(uid).putFile(image);
    final downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    return downloadUrl;
  }

  static Future<void> openDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onTap,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            content,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onTap();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool checkMasterAccount(String id) {
    if (id == 'fuKP9kQcLUZe3ZgDDpVU5ZlPz5O2') {
      return true;
    } else {
      return false;
    }
  }

  String checkRegisterError(String error) {
    switch (error) {
      case '[firebase_auth/invalid-email] The email address is badly formatted.':
        return 'メールアドレスの形式が不正です。';
      case '[firebase_auth/weak-password] Password should be at least 6 characters':
        return 'パスワードは６文字以上に設定してください。';
      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        return 'このメールアドレスはすでに使用されています。';
    }
    return '不鮮明のエラーです。運営側にお伝えください。';
  }

  String checkLoginError(String error) {
    switch (error) {
      case '[firebase_auth/invalid-email] The email address is badly formatted.':
        return '入力されたメールアドレスの形式が正しくありません。';
      case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
        return 'パスワード or メールアドレスが間違っています';
      case '[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.':
        return 'ログイン試行過多により、アカウントが一時ロックされています。';
      case '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
        return 'アカウントが存在しない or 削除された可能性があります。';
    }
    return '未確認のエラーです。運営側にお伝えください。';
  }
}
