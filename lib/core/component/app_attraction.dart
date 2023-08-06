import 'package:disney_app/core/theme/app_color_style.dart';
import 'package:disney_app/core/theme/app_text_style.dart';
import 'package:disney_app/l10n/l10n.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColorStyle.appColor),
          borderRadius: BorderRadius.circular(5),
        ),
        tileColor: Colors.white,
        title: !isSelected
            ? Text(
                l10n.attraction,
                style: AppTextStyle.appBold15TextStyle,
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                  attractionName,
                  style: AppTextStyle.appBold15TextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      ),
    );
  }
}
