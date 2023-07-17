import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppRating extends StatelessWidget {
  const AppRating({
    Key? key,
    required this.rank,
    required this.isSelect,
    this.onTap,
  }) : super(key: key);

  final int rank;
  final bool isSelect;
  final Function(double)? onTap;

  @override
  Widget build(BuildContext context) {
    return isSelect
        ? Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: onTap!,
            ),
          )
        : RatingBarIndicator(
            direction: Axis.horizontal,
            itemCount: 5,
            rating: rank.toDouble(),
            itemSize: 30,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          );
  }
}