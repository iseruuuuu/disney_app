import 'package:disney_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
  });

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
        style: AppTextStyle.appBoldBlack17TextStyle,
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
          labelStyle: AppTextStyle.appBoldGrey17TextStyle,
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
