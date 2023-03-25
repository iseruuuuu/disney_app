import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils {
  static Future<dynamic> getImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<String> uploadImage(
    String uid,
    File image,
  ) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image);
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    return downloadUrl;
  }

  static Future<void> openDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function() onTap,
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
                  "Cancel",
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
                  "OK",
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
        return 'メールアドレスのフォーマットが間違っています';
      case '[firebase_auth/weak-password] Password should be at least 6 characters':
        return 'パスワードは６文字以上に設定してください';
      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        return 'このメールアドレスはすでに使用されています';
    }
    return '不鮮明のエラーです。運営側にお伝えください。';
  }

  String checkLoginError(int error) {
    switch (error) {
      case 489289217:
        return 'パスワード又はメールアドレスが間違っています';
      case 536596580:
        return 'パスワード又はメールアドレスが間違っています';
      case 498732620:
        return 'パスワード又はメールアドレスが間違っています';
    }
    return '不鮮明のエラーです。運営側にお伝えください。';
  }
}
