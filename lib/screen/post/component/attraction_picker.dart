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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.grey.shade200,
        child: Center(
          child: Text(attractionName),
        ),
      ),
    );
  }
}
