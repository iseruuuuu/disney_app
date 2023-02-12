import 'package:flutter/material.dart';

class CommentTextField extends StatelessWidget {
  const CommentTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}
