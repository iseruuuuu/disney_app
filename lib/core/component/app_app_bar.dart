import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget {
  const AppAppBar({
    super.key,
    required this.icon,
  });

  final String icon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        icon,
        style: AppTextStyle.iconAppBarStyle,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
