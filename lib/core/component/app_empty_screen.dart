import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class AppEmptyScreen extends StatelessWidget {
  const AppEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.no_post,
          style: AppTextStyle.noPostTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              'assets/images/empty.png',
            ),
          ),
        ),
      ],
    );
  }
}
