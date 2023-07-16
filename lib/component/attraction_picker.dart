import 'package:disney_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AttractionPicker extends StatelessWidget {
  const AttractionPicker({
    Key? key,
    required this.onTap,
    required this.attractionName,
  }) : super(key: key);

  final Function() onTap;
  final String attractionName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 50),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ColorConstants.appColor),
          borderRadius: BorderRadius.circular(5),
        ),
        tileColor: Colors.white,
        title: const Text(
          'アトラクション',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.black,
          ),
        ),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width - 160,
          child: Text(
            //TODO テキストの全て出したい
            attractionName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
