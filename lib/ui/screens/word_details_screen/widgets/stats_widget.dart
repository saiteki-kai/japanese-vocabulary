import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../data/models/review.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/date.dart';
import 'stats_item_widget.dart';
import 'title_subtitle_widget.dart';

/// A widget that displays the statistics of a [Review] associated to a [Word].
///
/// The statistics are displayed by using the [StatsItem] widget.
/// The word statistics are: easiness, streak, correct and incorrect number of answers.
/// Other information are also displayed the type of the review (meaning/reading), the next review date and the accuracy of the Review.
class StatsWidget extends StatelessWidget {
  /// Creates a stats widget.
  ///
  /// The [review] parameter is required and must not be null.
  const StatsWidget({
    Key? key,
    required this.review,
  }) : super(key: key);

  /// The [review] from which statistics will be displayed.
  final Review review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              review.type.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.amber[400],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsItemWidget(
                label: "Easiness",
                value: review.ef.toStringAsPrecision(2),
              ),
              StatsItemWidget(
                label: "Streak",
                value: review.repetition.toString(),
              ),
              StatsItemWidget(
                label: "Correct",
                value: review.correctAnswers.toString(),
              ),
              StatsItemWidget(
                label: "Incorrect",
                value: review.incorrectAnswers.toString(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TitleSubtitleWidget(
                  title: "Next Review",
                  titleTextStyle: const TextStyle(fontWeight: FontWeight.w500),
                    titleTextStyle:
                        const TextStyle(fontWeight: FontWeight.w500),
                    subtitle:
                        '${review?.nextDate?.day ?? '--'} / ${review?.nextDate?.month ?? '--'} / ${review?.nextDate?.year ?? '----'} ',
                    padding: const EdgeInsets.all(8.0),
                  ),
                  CircularPercentIndicator(
                    radius: 32,
                    lineWidth: 32 / 4,
                    circularStrokeCap: CircularStrokeCap.butt,
                    center: Text(
                  padding: const EdgeInsets.all(8.0),
                ),
                CircularPercentIndicator(
                  radius: 32,
                  lineWidth: 32 / 4,
                  circularStrokeCap: CircularStrokeCap.butt,
                  center: Text(
                    '${(review.getReviewAccuracy() * 100).round()}%',
                    textAlign: TextAlign.center,
                  ),
                  percent: review.getReviewAccuracy(),
                  progressColor:
                      CustomColors.colorPercent(review.getReviewAccuracy()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
