import 'package:flutter/material.dart';

import '../../../../data/models/review.dart';

/// A widget that displays the type of a [review].
///
/// The [review] is displayed in uppercase and is wrapped in a decorated box.
class ReviewTypeTag extends StatelessWidget {
  /// Creates a that displays the type of a [review].
  const ReviewTypeTag({
    Key? key,
    required this.review,
  }) : super(key: key);

  /// The [review] to show the type.
  final Review review;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.amber.withOpacity(0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          review.type.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
