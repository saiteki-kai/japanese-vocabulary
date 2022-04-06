import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A button that allow you to move to the next review.
///
/// If the review session is finished go to the summary of the review.
class NextReviewButton extends StatelessWidget {
  /// Creates a button that allow you to move to the next review.
  ///
  /// The [selectedQuality], [onPressed] and [isLast] parameters are required and must not be null.
  const NextReviewButton({
    Key? key,
    required this.selectedQuality,
    required this.isLast,
    required this.onPressed,
  }) : super(key: key);

  /// A boolean to indicate weather or not the current review is the last one.
  final bool isLast;

  /// The selected quality value.
  final ValueListenable<int> selectedQuality;

  /// Called when this button is pressed, passing the quality value as argument.
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ValueListenableBuilder(
        valueListenable: selectedQuality,
        builder: (BuildContext _, int value, Widget? __) {
          final disabled = value == -1;

          return TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: const EdgeInsets.all(16.0),
            ).copyWith(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey[200];
                } else {
                  return Colors.amber[600];
                }
              }),
            ),
            onPressed: disabled ? null : () => onPressed(value),
            child: Text(isLast ? "SUMMARY" : "NEXT"),
          );
        },
      ),
    );
  }
}
