import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:flutter/material.dart';

class AppSearchElevatedButton extends StatelessWidget {
  const AppSearchElevatedButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorStyle.appColor,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          splashFactory: InkRipple.splashFactory,
        ),
        onPressed: onTap,
        child: Text(title),
      ),
    );
  }
}
