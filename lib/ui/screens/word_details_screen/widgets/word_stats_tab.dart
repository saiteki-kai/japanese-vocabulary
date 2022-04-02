import 'package:flutter/material.dart';
import '../../../../data/models/review.dart';
import '../../../../data/models/word.dart';
import 'stats_widget.dart';

class WordStatisticsTab extends StatelessWidget {
  final Word word;
  const WordStatisticsTab({Key? key, required this.word}) : super(key: key);

  Review? get _meaningReview => word.meaningReview.target;
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
              StatsWidget(review: _meaningReview),
              StatsWidget(review: _readingReview),
            ],
          ),
        ),
      ],
    );
  }
}
