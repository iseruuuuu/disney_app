import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:flutter/material.dart';

class AppAttraction extends StatelessWidget {
  const AppAttraction({
    super.key,
    required this.onTap,
    required this.attractionName,
    required this.isSelected,
  });

  final VoidCallback onTap;
  final String attractionName;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColorStyle.appColor),
        borderRadius: BorderRadius.circular(5),
      ),
      tileColor: Colors.white,
      title: !isSelected
          ? Text(
              l10n.attraction,
              style: AppTextStyle.appBoldBlue15TextStyle,
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Text(
                attractionName,
                style: AppTextStyle.appBoldBlue15TextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
  }
}
