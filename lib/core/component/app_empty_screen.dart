import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:flutter/material.dart';

class AppEmptyScreen extends StatelessWidget {
  const AppEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.no_post,
            style: AppTextStyle.appBoldBlack25TextStyle,
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
      ),
    );
  }
}
