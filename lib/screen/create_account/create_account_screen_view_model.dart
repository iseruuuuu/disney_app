import 'dart:io';

import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/core/usecase/user_usecase.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final createAccountScreenViewModelProvider =
    StateNotifierProvider<CreateAccountScreenViewModel, File?>(
  (ref) {
    return CreateAccountScreenViewModel(
      FunctionUtils(),
      null,
      ref,
    );
  },
);

class CreateAccountScreenViewModel extends StateNotifier<File?> {
  CreateAccountScreenViewModel(this._functionUtils, super._state, this.ref);

  final Ref ref;

  final FunctionUtils _functionUtils;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? image;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Loading get loading => ref.read(loadingProvider.notifier);

  Future<void> selectImage() async {
    final XFile? result = await _functionUtils.getImageFromGallery();
    if (result != null) {
      image = File(result.path);
      state = File(result.path);
    }
  }

  Future<void> createAccount(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = L10n.of(context)!;
    loading.isLoading = true;
    FocusScope.of(context).unfocus();
    if (nameController.text.isNotEmpty &&
        userIdController.text.isNotEmpty &&
        selfIntroductionController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        image != null) {
      final result = await ref.read(authenticationServiceProvider).signIn(
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
        final result0 = await ref.read(userUsecaseProvider).setUser(newAccount);
        if (result0 == true) {
          if (!mounted) {
            return;
          }
          await Future<void>.delayed(const Duration(seconds: 1))
              .then((_) async {
            loading.isLoading = false;
            await FunctionUtils().createAccountDialog(
              context: context,
              onTap: () async {
                loading.isLoading = false;
                Navigator.pop(context);
                Navigator.pop(context);
                final prefs = await _prefs;
                await prefs.setBool('IS_AUTO_LOGIN', true);
              },
            );
          });
        }
      } else {
        loading.isLoading = false;
        if (!mounted) {
          return;
        }
        final errorMessage = FunctionUtils().checkRegisterError(
          result.toString(),
          context,
        );
        SnackBarUtils.snackBar(context, errorMessage);
      }
    } else {
      loading.isLoading = false;
      SnackBarUtils.snackBar(context, l10n.error_empty_register);
    }
  }
}
