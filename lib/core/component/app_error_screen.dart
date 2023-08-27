import 'package:disney_app/core/component/component.dart';
import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/images/empty.png',
            ),
          ),
          const SizedBox(height: 30),
          Text(
            l10n.error_screen,
            style: AppTextStyle.appBoldBlack18TextStyle,
          ),
          const SizedBox(height: 10),
          AppTextButton(
            onPressed: onPressed,
            title: l10n.retry,
            color: AppColorStyle.appColor,
          ),
        ],
      ),
    );
  }
}
