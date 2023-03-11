import 'package:flutter/material.dart';

class CreateAccountTextField extends StatelessWidget {
  const CreateAccountTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF4A67AD),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF4A67AD),
            ),
          ),
          labelText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
