// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Project imports:
import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';

final loginScreenViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginScreenViewModel>(
  (ref) {
    return LoginScreenViewModel();
  },
);

class LoginScreenViewModel extends ChangeNotifier {
  LoginScreenViewModel() {
    fetch();
  }

  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void fetch() {
    readFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> readFromStorage() async {
    emailController.text = await storage.read(key: "KEY_USERNAME") ?? '';
    passwordController.text = await storage.read(key: "KEY_PASSWORD") ?? '';
  }

  store() async {
    await storage.write(key: "KEY_USERNAME", value: emailController.text);
    await storage.write(key: "KEY_PASSWORD", value: passwordController.text);
  }

  void login(BuildContext context, WidgetRef ref) async {
    var result = await Authentication.signIn(
      email: emailController.text,
      pass: passwordController.text,
    );
    if (result is UserCredential) {
      var result0 = await ref
          .read(userFirestoreUsecaseProvider)
          .getUser(result.user!.uid);

      if (result0 == true) {
        store();
        Future.delayed(const Duration(seconds: 0)).then((_) {
          NavigationUtils.tabScreen(context);
        });
      }
    } else {
      final errorMessage = FunctionUtils().checkLoginError(result.toString());
      Future.delayed(const Duration(seconds: 1)).then((_) {
        SnackBarUtils.snackBar(context, errorMessage);
      });
    }
  }

  void createAccountScreen(BuildContext context) {
    NavigationUtils.createAccountScreen(context);
  }
}
