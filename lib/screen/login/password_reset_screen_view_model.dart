import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/utils/authentication.dart';
import 'package:disney_app/utils/function_utils.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final passwordResetScreenViewModelProvider =
    ChangeNotifierProvider.autoDispose<PasswordResetScreenViewModel>(
  (ref) {
    return PasswordResetScreenViewModel(ref);
  },
);

class PasswordResetScreenViewModel extends ChangeNotifier {
  PasswordResetScreenViewModel(this.ref);

  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  AutoDisposeChangeNotifierProviderRef<PasswordResetScreenViewModel> ref;

  Loading get loading => ref.read(loadingProvider.notifier);

  Future<void> sendEmail(BuildContext context) async {
    if (emailController.text.isNotEmpty) {
      loading.isLoading = true;
      try {
        await Authentication.resetPassword(emailController.text);
        await Future<void>.delayed(Duration.zero).then((_) {
          SnackBarUtils.snackBar(context, 'メールを送信しました。');
        });
        await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
          loading.isLoading = false;
          Navigator.pop(context);
        });
      } on FirebaseAuthException catch (e) {
        loading.isLoading = false;
        final errorMessage = FunctionUtils().checkLoginError(e.toString());
        SnackBarUtils.snackBar(context, errorMessage);
      }
    } else {
      await Future<void>.delayed(Duration.zero).then((_) {
        SnackBarUtils.snackBar(context, 'メールアドレスを入力してください');
      });
    }
  }
}
