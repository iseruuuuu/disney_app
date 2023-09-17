import 'package:disney_app/core/firebase/firebase.dart';
import 'package:disney_app/core/firebase/firebase_provider.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/utils/error_handling.dart';
import 'package:disney_app/utils/log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService(ref);
});

class AuthenticationService {
  AuthenticationService(ProviderRef<AuthenticationService> ref) {
    firebaseAuth = ref.read(firebaseAuthProvider);
  }

  late final FirebaseAuth firebaseAuth;
  static User? currentFirebaseUser;
  static Account? myAccount;

  Future<dynamic> signUp({
    required String email,
    required String pass,
  }) async {
    try {
      final newAccount = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      await firebaseAuth.currentUser?.sendEmailVerification();
      return newAccount;
    } on FirebaseAuthException catch (error) {
      Log.e(error);
      return ErrorHandling.handleException(error);
    }
  }

  Future<dynamic> signIn({
    required String email,
    required String pass,
  }) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final isVerified = firebaseAuth.currentUser?.emailVerified;
      if (!isVerified!) {
        await firebaseAuth.currentUser?.sendEmailVerification();
        return;
      }
      currentFirebaseUser = result.user;
      return result;
    } on FirebaseAuthException catch (error) {
      Log.e(error);
      return ErrorHandling.handleException(error);
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> deleteAuth() async {
    await currentFirebaseUser!.delete();
  }

  Future<void> resetPassword(String email) async {
    return firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
