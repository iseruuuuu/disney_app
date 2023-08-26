import 'package:disney_app/core/firebase/firebase.dart';

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

  static String exceptionMessage(FirebaseAuthResultStatus result) {
    var message = '';
    switch (result) {
      case FirebaseAuthResultStatus.invalidEmail:
        message = 'メールアドレスが間違っています。';
        break;

      case FirebaseAuthResultStatus.wrongPassword:
        message = 'パスワードが間違っています。';
        break;

      case FirebaseAuthResultStatus.userNotFound:
        message = 'このアカウントは存在しません。';
        break;

      case FirebaseAuthResultStatus.userDisabled:
        message = 'このメールアドレスは無効になっています。';
        break;

      case FirebaseAuthResultStatus.tooManyRequests:
        message = '回線が混雑しています。もう一度試してみてください。';
        break;

      case FirebaseAuthResultStatus.operationNotAllowed:
        message = 'メールアドレスとパスワードでのログインは有効になっていません。';
        break;

      case FirebaseAuthResultStatus.emailAlreadyExists:
        message = 'このメールアドレスはすでに登録されています。';
        break;
    }
    return message;
  }
}

enum FirebaseAuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}
