import 'package:flutter/material.dart';
import '../../../../data/models/review.dart';
import '../../../../data/models/word.dart';
import 'stats_widget.dart';

/// A widget that displays the statistics of a [Word] from the associated reviews.
///
/// Both the meaning and the reading review are displayed separately with a dedicated [StatsWidget].
class WordStatisticsTab extends StatelessWidget {
  /// Creates a word statistics tab widget.
  ///
  /// The [word] parameter is required and must not be null.
  const WordStatisticsTab({Key? key, required this.word}) : super(key: key);

  /// The [word] from which statistics will be displayed, must not be null.
  final Word word;

  /// The meaning review associated to the word.
  Review? get _meaningReview => word.meaningReview.target;

  /// The reading review associated to the word.
  Review? get _readingReview => word.readingReview.target;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_meaningReview != null) StatsWidget(review: _meaningReview!),
              if (_readingReview != null) StatsWidget(review: _readingReview!),
            ],
          ),
        ),
      ],
    );
  }
}
