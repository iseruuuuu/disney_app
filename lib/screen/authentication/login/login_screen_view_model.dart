import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/core/usecase/user_usecase.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/utils/error_handling.dart';
import 'package:disney_app/utils/navigation_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
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
  final Ref ref;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
    final prefs = await _prefs;
    await storage.write(key: 'KEY_USERNAME', value: emailController.text);
    await storage.write(key: 'KEY_PASSWORD', value: passwordController.text);
    await prefs.setBool('IS_AUTO_LOGIN', true);
  }

  Future<void> login(BuildContext context, WidgetRef ref) async {
    loading.isLoading = true;
    final result = await ref.read(authenticationServiceProvider).signIn(
          email: emailController.text,
          pass: passwordController.text,
        );
    if (result is UserCredential) {
      final result0 =
          await ref.read(userUsecaseProvider).getUser(result.user!.uid);
      if (result0 == true) {
        await store();
        await Future<void>.delayed(const Duration(seconds: 1)).then((_) {
          loading.isLoading = false;
          return NavigationUtils.tabScreen(context);
        });
      }
      return;
    } else {
      await Future<void>.delayed(Duration.zero).then((_) {
        final errorMessage = ErrorHandling.exceptionMessage(result);
        loading.isLoading = false;
        SnackBarUtils.snackBar(context, errorMessage);
      });
    }
    return;
  }

  void createAccountScreen(BuildContext context) {
    NavigationUtils.createAccountScreen(context);
  }

  void passwordResetScreen(BuildContext context) {
    NavigationUtils.passwordResetScreen(context);
  }

  Future<void> checkLogin(BuildContext context, WidgetRef ref) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      await Future<void>.delayed(Duration.zero).then((_) {
        return NavigationUtils.loginScreen(context);
      });
    } else if (!currentUser.emailVerified) {
      await Future<void>.delayed(Duration.zero).then((_) {
        return NavigationUtils.loginScreen(context);
      });
    } else {
      final result =
          await ref.read(userUsecaseProvider).getUser(currentUser.uid);
      if (result == false) {
        await Future<void>.delayed(Duration.zero).then((_) {
          return NavigationUtils.loginScreen(context);
        });
      } else {
        await Future<void>.delayed(Duration.zero).then((_) {
          return NavigationUtils.tabScreen(context);
        });
      }
    }
  }
}
