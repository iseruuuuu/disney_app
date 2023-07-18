import 'package:flutter/material.dart';
import 'package:disney_app/core/theme/app_color_style.dart';

class AppAttraction extends StatelessWidget {
  const AppAttraction({
    Key? key,
    required this.onTap,
    required this.attractionName,
    required this.isSelected,
  }) : super(key: key);

  final VoidCallback onTap;
  final String attractionName;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
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
            ? const Text(
                'アトラクション',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                  attractionName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      ),
    );
  }
}
