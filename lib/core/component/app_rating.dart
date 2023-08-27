import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppRating extends StatelessWidget {
  const AppRating({
    super.key,
    required this.rank,
    required this.isSelect,
    this.onTap,
  });

  final int rank;
  final bool isSelect;
  final void Function(double)? onTap;

  @override
  Widget build(BuildContext context) {
    return isSelect
        ? Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: onTap!,
            ),
          )
        : RatingBarIndicator(
            rating: rank.toDouble(),
            itemSize: 35,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          );
  }
}
