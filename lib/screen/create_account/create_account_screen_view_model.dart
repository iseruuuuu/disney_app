// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';

final createAccountScreenViewModelProvider = StateNotifierProvider.autoDispose<
    CreateAccountScreenViewModel, ImageProvider?>(
  (ref) {
    return CreateAccountScreenViewModel(
      state: AssetImage(Assets.images.imageEmpty.path),
    );
  },
);

class CreateAccountScreenViewModel extends StateNotifier<ImageProvider?> {
  CreateAccountScreenViewModel({required ImageProvider state}) : super(state);

  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? image;

  ImageProvider getImage() {
    if (image == null) {
      return AssetImage(Assets.images.imageEmpty.path);
    } else {
      return FileImage(image!);
    }
  }

  void selectImage() async {
    var result = await FunctionUtils.getImageFromGallery();
    if (result != null) {
      image = File(result.path);
      state = getImage();
    }
  }

  void createAccount(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    if (nameController.text.isNotEmpty &&
        userIdController.text.isNotEmpty &&
        selfIntroductionController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        image != null) {
      var result = await Authentication.signUp(
        email: emailController.text,
        pass: passwordController.text,
      );
      if (result is UserCredential) {
        String imagePath = await FunctionUtils.uploadImage(
          result.user!.uid,
          image!,
        );
        Account newAccount = Account(
          id: result.user!.uid,
          name: nameController.text,
          userId: userIdController.text,
          selfIntroduction: selfIntroductionController.text,
          imagePath: imagePath,
        );

        var result0 =
            await ref.read(userFirestoreUsecaseProvider).setUser(newAccount);
        if (result0 == true) {
          if (!mounted) return;
          Navigator.pop(context);
        }
      } else {
        final errorMessage =
            FunctionUtils().checkRegisterError(result.toString());
        if (!mounted) return;
        SnackBarUtils.snackBar(context, errorMessage);
      }
    } else {
      SnackBarUtils.snackBar(context, '登録してた内容に不備があります');
    }
  }
}
