import 'package:disney_app/model/account.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp({
    required String email,
    required String pass,
  }) async {
    try {
      UserCredential newAccount =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return newAccount;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  static Future<dynamic> signIn({
    required String email,
    required String pass,
  }) async {
    try {
      final UserCredential result =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      currentFirebaseUser = result.user;
      return result;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async {
    await currentFirebaseUser!.delete();
  }
}
