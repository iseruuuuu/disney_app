import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RankPicker extends StatelessWidget {
  const RankPicker({
    Key? key,
    required this.onTap,
    required this.rank,
  }) : super(key: key);

  final Function(double) onTap;
  final String rank;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
      //TODO ここを整数だけにしたい。
      child: RatingBar.builder(
        initialRating: 1,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: onTap,
      ),
    );
  }
}
