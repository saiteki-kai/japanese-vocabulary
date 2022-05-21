import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/review.dart';
import '../../../../utils/hints.dart';
import 'review_hint_button.dart';
import 'review_type_tag.dart';
import 'show_button.dart';

/// A widget that displays a card with the word related to a [review] and
/// provide a button to show or hide the [ShowButton] and the [ReviewAnswer], and
/// a button to show the [ReviewHint] and disable some quality values.
class ReviewItem extends StatelessWidget {
  /// Creates a widget that displays the word for a [review] to review and
  /// a button to show or hide the review answer based on the [hidden] value.
  /// A [onToggleAnswer] callback is provided to control when the button is
  /// tapped. A [onAskHint] callback is provided to control when the a hint button
  /// is tapped.
  const ReviewItem({
    Key? key,
    required this.review,
    required this.hidden,
    required this.onToggleAnswer,
    required this.hint,
    required this.onAskHint,
  }) : super(key: key);

  /// The [review] of the word to show.
  final Review review;

  /// A boolean value that show or hide the [ShowButton].
  final ValueListenable<bool> hidden;

  /// Called when the [ShowButton] is tapped.
  final VoidCallback? onToggleAnswer;

  /// A [Hint] value containing the current hint to show.
  final ValueListenable<Hint> hint;

  /// Called when the [ReviewHintButton] is tapped.
  final VoidCallback? onAskHint;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReviewHintButton(hint: hint, onPressed: onAskHint),
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
            ShowButton(
              show: hidden,
              onPressed: onToggleAnswer,
            ),
          ],
        ),
      ),
    );
  }
}
