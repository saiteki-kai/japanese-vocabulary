import 'package:flutter/material.dart';

import '../../../../data/models/review.dart';

class ReviewTypeTag extends StatelessWidget {
  const ReviewTypeTag({
    Key? key,
    required this.review,
  }) : super(key: key);

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.amber.withOpacity(0.3),
      ),
      child: Text(
        review.type.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.amber,
        ),
      ),
    );
  }
}
