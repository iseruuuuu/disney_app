import 'package:disney_app/core/model/usecase/user_firestore_usecase.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/loading_provider.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final loginScreenViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginScreenViewModel>(
  (ref) {
    return LoginScreenViewModel(ref);
  },
);

class LoginScreenViewModel extends ChangeNotifier {
  LoginScreenViewModel(this.ref) {
    fetch();
  }

  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AutoDisposeChangeNotifierProviderRef ref;

  Loading get loading => ref.read(loadingProvider.notifier);

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
    emailController.text = await storage.read(key: 'KEY_USERNAME') ?? '';
    passwordController.text = await storage.read(key: 'KEY_PASSWORD') ?? '';
  }

  Future<void> store() async {
    await storage.write(key: 'KEY_USERNAME', value: emailController.text);
    await storage.write(key: 'KEY_PASSWORD', value: passwordController.text);
  }

  Future<void> login(BuildContext context, WidgetRef ref) async {
    loading.isLoading = true;
    final result = await Authentication.signIn(
      email: emailController.text,
      pass: passwordController.text,
    );
    if (result is UserCredential) {
      final result0 = await ref
          .read(userFirestoreUsecaseProvider)
          .getUser(result.user!.uid);

      if (result0 == true) {
        loading.isLoading = false;
        await store();
        await Future<void>.delayed(Duration.zero).then((_) {
          return NavigationUtils.tabScreen(context);
        });
      }
    } else {
      loading.isLoading = false;
      final errorMessage = FunctionUtils().checkLoginError(result.toString());
      await Future<void>.delayed(const Duration(seconds: 1)).then((_) {
        SnackBarUtils.snackBar(context, errorMessage);
      });
    }
  }

  void createAccountScreen(BuildContext context) {
    NavigationUtils.createAccountScreen(context);
  }
}
