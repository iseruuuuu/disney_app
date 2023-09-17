import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:flutter/material.dart';

class AppSearchElevatedButton extends StatelessWidget {
  const AppSearchElevatedButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: isSelected ? AppColorStyle.appColor : Colors.grey,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width / 2.3,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.grey,
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColorStyle.appColor : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
