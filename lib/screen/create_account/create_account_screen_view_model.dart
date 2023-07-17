import 'dart:io';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/firestore/user_firestore.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createAccountScreenViewModelProvider =
    StateNotifierProvider<CreateAccountScreenViewModel, ImageProvider?>(
  (ref) {
    return CreateAccountScreenViewModel(
      state: const AssetImage('assets/images/image_empty.png'),
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
      return const AssetImage('assets/images/image_empty.png');
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

  void createAccount(BuildContext context) async {
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
        var result0 = await UserFireStore.setUser(newAccount);
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
