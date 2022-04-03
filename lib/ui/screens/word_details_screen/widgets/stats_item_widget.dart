import 'package:flutter/material.dart';

/// A widget that displays a statistic of a [Review] associated to a [Word].
/// 
/// A statistic is displayed in a vertical array consisting of two Text for the label and its corresponding value.
/// The statistics are: easiness, streak, correct and incorrect number of answers.
class StatsItemWidget extends StatelessWidget {
  /// Creates a stats item widget.
  /// 
  /// The [label] and [value] parameters are required and must not be null.
  const StatsItemWidget({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  /// The text to display for the label, must not be null.
  final String label;

  /// The text to display for the value field, must not be null.
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
