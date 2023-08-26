import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/gen/l10n.dart';
import 'package:flutter/cupertino.dart';

class ErrorHandling {
  ErrorHandling();

  static FirebaseAuthResultStatus handleException(FirebaseAuthException e) {
    FirebaseAuthResultStatus result;
    switch (e.code) {
      case 'invalid-email':
        result = FirebaseAuthResultStatus.invalidEmail;
        break;

      case 'wrong-password':
        result = FirebaseAuthResultStatus.wrongPassword;
        break;

      case 'user-not-found':
        result = FirebaseAuthResultStatus.userNotFound;
        break;

      case 'user-disabled':
        result = FirebaseAuthResultStatus.userDisabled;
        break;

      case 'too-many-requests':
        result = FirebaseAuthResultStatus.tooManyRequests;
        break;

      case 'operation-not-allowed':
        result = FirebaseAuthResultStatus.operationNotAllowed;
        break;

      case 'email-already-in-use':
        result = FirebaseAuthResultStatus.emailAlreadyExists;
        break;

      default:
        result = FirebaseAuthResultStatus.undefined;
        break;
    }
    return result;
  }

  static String exceptionMessage(
    FirebaseAuthResultStatus result,
    BuildContext context,
  ) {
    final l10n = L10n.of(context)!;
    var message = '';
    switch (result) {
      case FirebaseAuthResultStatus.invalidEmail:
        message = l10n.error_invalid_email;
        break;

      case FirebaseAuthResultStatus.wrongPassword:
        message = l10n.error_wrong_password;
        break;

      case FirebaseAuthResultStatus.userNotFound:
        message = l10n.error_user_not_found;
        break;

      case FirebaseAuthResultStatus.userDisabled:
        message = l10n.error_user_disabled;
        break;

      case FirebaseAuthResultStatus.tooManyRequests:
        message = l10n.error_too_many_requests;
        break;

      case FirebaseAuthResultStatus.operationNotAllowed:
        message = l10n.error_operation_not_allowed;
        break;

      case FirebaseAuthResultStatus.emailAlreadyExists:
        message = l10n.error_email_already_exists;
        break;

      case FirebaseAuthResultStatus.undefined:
        message = l10n.error_undefined;
        break;
    }
    return message;
  }
}

enum FirebaseAuthResultStatus {
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}
