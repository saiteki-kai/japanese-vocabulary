import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/review.dart';
import 'review_type_tag.dart';
import 'show_button.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    Key? key,
    required this.review,
    required this.onToggleAnswer,
    required this.hidden,
  }) : super(key: key);

  final Review review;
  final ValueListenable<bool> hidden;
  final void Function()? onToggleAnswer;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ReviewTypeTag(review: review),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                review.word.target?.text ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: hidden,
              builder: (context, bool value, child) {
                return ShowButton(
                  show: value,
                  onToggleAnswer: onToggleAnswer,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
