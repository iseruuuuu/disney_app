import 'package:flutter/material.dart';

class AccountContainer extends StatelessWidget {
  const AccountContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF4A67AD),
            width: 3,
          ),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '投稿',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
