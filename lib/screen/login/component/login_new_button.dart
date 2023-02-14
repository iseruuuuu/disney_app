import 'package:flutter/material.dart';

class LoginNewButton extends StatelessWidget {
  const LoginNewButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF4A67AD),
          width: 2,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          '新規登録',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
