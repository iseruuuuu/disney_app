import 'package:flutter/material.dart';

class RankPicker extends StatelessWidget {
  const RankPicker({
    Key? key,
    required this.onTap,
    required this.rank,
  }) : super(key: key);

  final Function() onTap;
  final String rank;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        color: Colors.grey,
        child: Center(
          child: Text(rank),
        ),
      ),
    );
  }
}
