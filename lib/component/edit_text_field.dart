import 'package:flutter/material.dart';

class EditTextField extends StatelessWidget {
  const EditTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.maxLine,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        maxLines: maxLine,
        decoration: InputDecoration(
          hintText: hintText,
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
