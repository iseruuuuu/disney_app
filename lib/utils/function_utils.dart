import 'dart:io';

import 'package:disney_app/core/constants/account.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils {
  Future<dynamic> getImageFromGallery() async {
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
    final l10n = L10n.of(context)!;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTextStyle.appBold17TextStyle,
            textAlign: TextAlign.center,
          ),
          content: Text(
            content,
            style: AppTextStyle.appBold15TextStyle,
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextButton(
                child: Text(
                  l10n.dialog_cancel,
                  style: AppTextStyle.cancelTextStyle,
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
                child: Text(
                  l10n.dialog_ok,
                  style: AppTextStyle.okTextStyle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool checkMasterAccount(String id) {
    if (id == MasterAccount.masterAccount) {
      return true;
    } else {
      return false;
    }
  }

  String checkRegisterError(String error, BuildContext context) {
    final l10n = L10n.of(context)!;
    switch (error) {
      case '[firebase_auth/invalid-email] The email address is badly formatted.':
        return l10n.error_badly_formatted;
      case '[firebase_auth/weak-password] Password should be at least 6 characters':
        return l10n.error_6_characters;
      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        return l10n.error_already;
    }
    return l10n.error_other;
  }

  String checkLoginError(String error, BuildContext context) {
    final l10n = L10n.of(context)!;
    switch (error) {
      case '[firebase_auth/invalid-email] The email address is badly formatted.':
        return l10n.error_badly_formatted;
      case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
        return l10n.error_password;
      case '[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.':
        return l10n.error_disabled;
      case '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
        return l10n.error_no_user;
    }
    return l10n.error_no_mail;
  }

  Future<void> createAccountDialog({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    final l10n = L10n.of(context)!;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.dialog_register_account_title,
            style: AppTextStyle.appBold18TextStyle,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.dialog_register_account_content,
                style: AppTextStyle.appBold15TextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  onPressed: onTap,
                  child: Text(
                    l10n.dialog_ok,
                    style: AppTextStyle.okTextStyle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
