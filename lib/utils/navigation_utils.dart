import 'package:disney_app/core/model/account.dart';
import 'package:disney_app/core/model/post.dart';
import 'package:disney_app/screen/create_account/create_account_screen.dart';
import 'package:disney_app/screen/detail/detail_account_screen.dart';
import 'package:disney_app/screen/detail/detail_screen.dart';
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
    String myAccount,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailAccountScreen(
          postAccount: postAccount,
          post: post,
        ),
      ),
    );
  }

  static Future<void> postScreen(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PostScreen(),
      ),
    );
  }

  static Future<void> tabScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const TabScreen(),
      ),
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
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  static Future<void> passwordResetScreen(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PasswordResetScreen(),
      ),
    );
  }
}
