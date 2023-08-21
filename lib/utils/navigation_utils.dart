import 'package:disney_app/core/component/app_animation.dart';
import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/screen/create_account/create_account_screen.dart';
import 'package:disney_app/screen/detail/detail_account_screen.dart';
import 'package:disney_app/screen/detail/detail_screen.dart';
import 'package:disney_app/screen/edit/edit_screen.dart';
import 'package:disney_app/screen/login/login_screen.dart';
import 'package:disney_app/screen/login/password_reset_screen.dart';
import 'package:disney_app/screen/post/post_screen.dart';
import 'package:disney_app/screen/tab/tab_screen.dart';
import 'package:flutter/material.dart';

class NavigationUtils {
  NavigationUtils();

  static Future<void> detailScreen(
    BuildContext context,
    Account postAccount,
    Post post,
    String myAccount,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          account: postAccount,
          post: post,
          myAccount: myAccount,
          onTapImage: () {
            detailAccountScreen(
              context,
              postAccount,
              post,
              myAccount,
            );
          },
        ),
      ),
    );
  }

  static Future<void> detailAccountScreen(
    BuildContext context,
    Account postAccount,
    Post post,
    String myAccountId,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailAccountScreen(
          postAccount: postAccount,
          post: post,
          myAccountId: myAccountId,
        ),
      ),
    );
  }

  static Future<void> postScreen(BuildContext context) {
    return Navigator.of(context).push(
      whiteOut(const PostScreen()),
    );
  }

  static Future<void> tabScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      blackOut(const TabScreen()),
    );
  }

  static Future<void> createAccountScreen(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateAccountScreen(),
      ),
    );
  }

  static Future<void> loginScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      blackOut(const LoginScreen()),
    );
  }

  static Future<void> passwordResetScreen(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PasswordResetScreen(),
      ),
    );
  }

  static dynamic editScreen(BuildContext context) {
    return Navigator.push(
      context,
      slideIn(const EditScreen()),
    );
  }
}
