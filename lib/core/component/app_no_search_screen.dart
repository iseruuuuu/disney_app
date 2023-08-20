import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:flutter/material.dart';

class AppNoSearchScreen extends StatelessWidget {
  const AppNoSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.no_post,
            style: AppTextStyle.noPostTextStyle,
          ),
          const Text(
            '🎢',
            style: AppTextStyle.iconTextStyle,
          ),
        ],
      ),
    );
  }
}
