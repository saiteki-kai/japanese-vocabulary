import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'review_meaning_hint.dart';

import '../../../../utils/hint.dart';

class ReviewHint extends StatelessWidget {
  const ReviewHint({
    Key? key,
    required this.hint,
  }) : super(key: key);

  /// A [Hint] value containing the current hint to show.
  final ValueListenable<Hint> hint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
      valueListenable: hint,
      builder: (context, Hint hint, child) {
        return Visibility(
          visible: hint.n > 0,
          maintainAnimation: true,
          maintainState: true,
          maintainSize: true,
          child: Center(
            child: Column(
              children: [
                Text(
                  "Hint",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                if (hint is MeaningHint && hint.currSentences.isNotEmpty)
                  ReviewMeaningHint(hint: hint)
                else if (hint is ReadingHint) 
                  Text(
                    hint.text.padRight(hint.max, "＿"),
                    style: textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
