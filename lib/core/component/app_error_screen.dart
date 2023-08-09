import 'package:disney_app/core/component/app_text_button.dart';
import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AppErrorScreen extends StatelessWidget {
  const AppErrorScreen({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/images/empty.png',
            ),
          ),
          Text(
            l10n.error_screen,
            style: AppTextStyle.appBold17TextStyle,
          ),
          AppTextButton(
            onPressed: () {},
            title: l10n.retry,
            color: AppColorStyle.appColor,
          ),
        ],
      ),
    );
  }
}
