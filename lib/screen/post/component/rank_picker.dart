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
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF4A67AD)),
          borderRadius: BorderRadius.circular(5),
        ),
        tileColor: Colors.white,
        title: const Text(
          '得点',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width - 160,
          child: Text(
            rank,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
