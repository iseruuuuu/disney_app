import 'dart:io';

import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/gen/assets.gen.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

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

  final storage = const FlutterSecureStorage();
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

  Future<void> selectImage() async {
    final XFile? result = await FunctionUtils.getImageFromGallery();
    if (result != null) {
      image = File(result.path);
      state = getImage();
    }
  }

  Future<void> createAccount(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    if (nameController.text.isNotEmpty &&
        userIdController.text.isNotEmpty &&
        selfIntroductionController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        image != null) {
      final result = await Authentication.signUp(
        email: emailController.text,
        pass: passwordController.text,
      );
      if (result is UserCredential) {
        final imagePath = await FunctionUtils.uploadImage(
          result.user!.uid,
          image!,
        );
        final newAccount = Account(
          id: result.user!.uid,
          name: nameController.text,
          userId: userIdController.text,
          selfIntroduction: selfIntroductionController.text,
          imagePath: imagePath,
        );
        final result0 =
            await ref.read(userFirestoreUsecaseProvider).setUser(newAccount);
        if (result0 == true) {
          if (!mounted) {
            return;
          }
          await Future<void>.delayed(const Duration(seconds: 1))
              .then((_) async {
            return login(context, ref);
          });
        }
      } else {
        final errorMessage =
            FunctionUtils().checkRegisterError(result.toString());
        if (!mounted) {
          return;
        }
        SnackBarUtils.snackBar(context, errorMessage);
      }
    } else {
      SnackBarUtils.snackBar(context, '登録してた内容に不備があります');
    }
  }

  Future<void> login(BuildContext context, WidgetRef ref) async {
    final result = await Authentication.signIn(
      email: emailController.text,
      pass: passwordController.text,
    );
    if (result is UserCredential) {
      final result0 = await ref
          .read(userFirestoreUsecaseProvider)
          .getUser(result.user!.uid);

      if (result0 == true) {
        await store();
        await Future<void>.delayed(Duration.zero).then((_) {
          Navigator.pop(context);
          return NavigationUtils.tabScreen(context);
        });
      }
    } else {
      final errorMessage = FunctionUtils().checkLoginError(result.toString());
      await Future<void>.delayed(const Duration(seconds: 1)).then((_) {
        SnackBarUtils.snackBar(context, errorMessage);
      });
    }
  }

  Future<void> store() async {
    await storage.write(key: 'KEY_USERNAME', value: emailController.text);
    await storage.write(key: 'KEY_PASSWORD', value: passwordController.text);
  }
}
