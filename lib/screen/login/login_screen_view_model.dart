import 'package:disney_app/core/services/authentication.dart';
import 'package:disney_app/core/usecase/user_usecase.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isAutoLogin = false;

  Loading get loading => ref.read(loadingProvider.notifier);

  void fetch() {
    readFromStorage();
  }

  Future<void> checkLogin(BuildContext context) async {
    final prefs = await _prefs;
    isAutoLogin = prefs.getBool('IS_AUTO_LOGIN') ?? false;
    if (isAutoLogin) {
      loading.isLoading = true;
      final email = await storage.read(key: 'KEY_USERNAME') ?? '';
      final password = await storage.read(key: 'KEY_PASSWORD') ?? '';
      if (email != '' && password != '') {
        final result = await Authentication.signIn(
          email: email,
          pass: password,
        );
        if (result is UserCredential) {
          final result0 =
              await ref.read(userUsecaseProvider).getUser(result.user!.uid);

          if (result0 == true) {
            await Future<void>.delayed(const Duration(seconds: 1)).then((_) {
              loading.isLoading = false;
              return NavigationUtils.tabScreen(context);
            });
          }
          return;
        }
      }
    }
    loading.isLoading = false;
    return;
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
    final prefs = await _prefs;
    await storage.write(key: 'KEY_USERNAME', value: emailController.text);
    await storage.write(key: 'KEY_PASSWORD', value: passwordController.text);
    await prefs.setBool('IS_AUTO_LOGIN', true);
  }

  Future<void> login(BuildContext context, WidgetRef ref) async {
    loading.isLoading = true;
    final result = await Authentication.signIn(
      email: emailController.text,
      pass: passwordController.text,
    );
    if (result is UserCredential) {
      final result0 =
          await ref.read(userUsecaseProvider).getUser(result.user!.uid);
      if (result0 == true) {
        await store();
        await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
          loading.isLoading = false;
          return NavigationUtils.tabScreen(context);
        });
      }
    } else {
      await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
        final errorMessage = FunctionUtils().checkLoginError(
          result.toString(),
          context,
        );
        loading.isLoading = false;
        SnackBarUtils.snackBar(context, errorMessage);
      });
    }
  }

  void createAccountScreen(BuildContext context) {
    NavigationUtils.createAccountScreen(context);
  }

  void passwordResetScreen(BuildContext context) {
    NavigationUtils.passwordResetScreen(context);
  }
}
