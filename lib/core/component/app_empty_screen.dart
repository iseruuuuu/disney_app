import 'package:flutter/material.dart';

class AppEmptyScreen extends StatelessWidget {
  const AppEmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '投稿がまだありません',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/images/empty.png',
            ),
          ),
        ),
      ],
    );
  }
}
