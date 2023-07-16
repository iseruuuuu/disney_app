import 'package:disney_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AppAttraction extends StatelessWidget {
  const AppAttraction({
    Key? key,
    required this.onTap,
    required this.attractionName,
    required this.isSelected,
  }) : super(key: key);

  final Function() onTap;
  final String attractionName;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ColorConstants.appColor),
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
