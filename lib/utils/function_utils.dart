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
            style: AppTextStyle.appBoldBlack17TextStyle,
            textAlign: TextAlign.center,
          ),
          content: Text(
            content,
            style: AppTextStyle.app500Black15TextStyle,
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextButton(
                child: Text(
                  l10n.dialog_cancel,
                  style: AppTextStyle.appBoldRed17TextStyle,
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
                  style: AppTextStyle.appBoldBlue17TextStyle,
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
            style: AppTextStyle.appBoldBlack18TextStyle,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.dialog_register_account_content,
                style: AppTextStyle.appBoldBlue15TextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  onPressed: onTap,
                  child: Text(
                    l10n.dialog_ok,
                    style: AppTextStyle.appBoldBlue17TextStyle,
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
