import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NextReviewButton extends StatelessWidget {
  const NextReviewButton({
    Key? key,
    required this.selectedQuality,
    required this.isLast,
    required this.onPressed,
  }) : super(key: key);

  final bool isLast;
  final ValueListenable<int> selectedQuality;
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
