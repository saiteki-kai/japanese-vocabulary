import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/review.dart';

/// A widget that displays the review answer.
///
/// The answer corresponds to the [meaning] or [reading] of a word
/// according to its type.
///
/// The answer can be shown or hidden by the [hidden] value.
class ReviewAnswer extends StatelessWidget {
  /// Create a widget that shows or hides the [review] answer based
  /// on the value [hidden].
  const ReviewAnswer({
    Key? key,
    required this.review,
    required this.hidden,
  }) : super(key: key);

  /// The [review] of which to show the [meaning] or [reading] of a word
  /// according to its type.
  final Review review;

  /// A boolean value that controls the visibility of this widget.
  final ValueListenable<bool> hidden;

  /// The [meaning] of the word associated with the [review].
  String get meaning => review.word.target?.meaning ?? "<NA>";

  /// The [reading] of the word associated with the [review].
  String get reading => review.word.target?.reading ?? "<NA>";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hidden,
      builder: (BuildContext context, bool value, Widget? child) {
        return Visibility(
          visible: !value,
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          child: Text(
            review.type == "meaning" ? meaning : reading,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 22.0),
          ),
        );
      },
    );
  }
}
