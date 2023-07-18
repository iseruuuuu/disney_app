import 'package:flutter/material.dart';

class SnackBarUtils {
  SnackBarUtils();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    BuildContext context,
    String message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
