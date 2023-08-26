import 'package:disney_app/core/error/error_handling.dart';
import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/core/services/authentication_service.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:disney_app/provider/loading_provider.dart';
import 'package:disney_app/utils/snack_bar_utils.dart';
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
  final Ref ref;

  Loading get loading => ref.read(loadingProvider.notifier);

  Future<void> sendEmail(BuildContext context, WidgetRef ref) async {
    final l10n = L10n.of(context)!;
    if (emailController.text.isNotEmpty) {
      loading.isLoading = true;
      try {
        await ref
            .read(authenticationServiceProvider)
            .resetPassword(emailController.text);
        await Future<void>.delayed(Duration.zero).then((_) {
          SnackBarUtils.snackBar(context, l10n.send_message);
        });
        await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
          loading.isLoading = false;
          Navigator.pop(context);
        });
      } on FirebaseAuthException catch (e) {
        loading.isLoading = false;
        final error = ErrorHandling.handleException(e);
        final errorMessage = ErrorHandling.exceptionMessage(error);
        SnackBarUtils.snackBar(context, errorMessage);
      }
    } else {
      await Future<void>.delayed(Duration.zero).then((_) {
        SnackBarUtils.snackBar(context, l10n.error_empty_email);
      });
    }
  }
}
