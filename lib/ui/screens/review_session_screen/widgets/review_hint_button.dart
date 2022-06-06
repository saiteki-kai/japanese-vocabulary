import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../utils/hint.dart';

/// A Button for asking the next [hint] and displaying the number of remaning hints.
///
/// A [onPressed] callback is provided that is called when each hint is requested.
class ReviewHintButton extends StatelessWidget {
  const ReviewHintButton({
    Key? key,
    required this.hint,
    required this.onPressed,
  }) : super(key: key);

  /// A [Hint] value containing the hint to show.
  final ValueListenable<Hint> hint;

  /// Called when the [ReviewHintButton] is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hint,
      builder: (context, Hint hint, child) {
        final hintsLeft = hint.max - hint.n;

        return InkResponse(
          onTap: hintsLeft > 0 ? onPressed : null,
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline),
              const SizedBox(width: 4),
              Text(
                "$hintsLeft",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
