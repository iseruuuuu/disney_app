import 'package:disney_app/core/theme/theme.dart';
import 'package:disney_app/gen/gen.dart';
import 'package:flutter/material.dart';

class AppAttraction extends StatelessWidget {
  const AppAttraction({
    super.key,
    required this.onTap,
    required this.attractionName,
    required this.isSelected,
    required this.style,
  });

  final VoidCallback onTap;
  final String attractionName;
  final bool isSelected;
  final TextStyle style;

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
              style: AppTextStyle.appBoldBlack16TextStyle,
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Text(
                attractionName,
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      trailing: const Icon(Icons.arrow_drop_down_sharp, size: 40),
    );
  }
}
