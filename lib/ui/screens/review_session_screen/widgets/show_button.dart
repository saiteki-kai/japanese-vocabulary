import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A toggle button that allows you to show or hide the [ReviewAnswer].
class ShowButton extends StatelessWidget {
  /// Creates a button that changes the text based on the value [show],
  /// "SHOW" when the value is true, "HIDE" otherwise.
  /// A [onPressed] callback is provided to control when the button is tapped.
  const ShowButton({
    Key? key,
    required this.show,
    required this.onPressed,
  }) : super(key: key);

  /// A boolean value that controls the text of this button.
  final ValueListenable<bool> show;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: show,
      builder: (context, bool value, child) {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
          child: Text((value ? "show" : "hide").toUpperCase()),
          onPressed: onPressed,
        );
      },
    );
  }
}
