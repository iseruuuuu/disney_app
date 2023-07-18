// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:disney_app/core/theme/app_color_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
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
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        autocorrect: false,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColorStyle.appColor),
          contentPadding: const EdgeInsets.all(15),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColorStyle.appColor,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColorStyle.appColor,
            ),
          ),
          alignLabelWithHint: true,
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
