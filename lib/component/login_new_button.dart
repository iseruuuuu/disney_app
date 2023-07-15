import 'package:flutter/material.dart';

class LoginNewButton extends StatelessWidget {
  const LoginNewButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        '新規登録はこちら',
        style: TextStyle(
          color: Colors.lightBlue,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
