import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppRating extends StatelessWidget {
  const AppRating({
    super.key,
    required this.rank,
    required this.isSelect,
    this.onTap,
  });

  final double rank;
  final bool isSelect;
  final void Function(double)? onTap;

  @override
  Widget build(BuildContext context) {
    return isSelect
        ? Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
            child: RatingBar.builder(
              allowHalfRating: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: onTap!,
            ),
          )
        : RatingBarIndicator(
            rating: rank,
            itemSize: 35,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          );
  }
}

class AppCellRating extends StatelessWidget {
  const AppCellRating({
    super.key,
    required this.rank,
  });

  final double rank;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rank,
      itemSize: 25,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }
}
