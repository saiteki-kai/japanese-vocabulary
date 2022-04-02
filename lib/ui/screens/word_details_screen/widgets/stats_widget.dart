import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'stats_item_widget.dart';
import 'title_subtitle_widget.dart';
import '../../../../data/models/review.dart';
import '../../../../utils/colors.dart';

class StatsWidget extends StatelessWidget {
  final Review? review;

  const StatsWidget({
    Key? key,
    required this.review,
  }) : super(key: key);

  double reviewAccuracy() {
    if (review == null) {
      return 0.0;
    } else {
      final totalAnswers = review!.correctAnswers + review!.incorrectAnswers;
      if (totalAnswers == 0.0) {
        return 0.0;
      } else {
        return review!.correctAnswers / totalAnswers;
      }
    }
  }

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
              review?.type.toUpperCase() ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.amber[400],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsItemWidget(
                  label: "Easiness", value: (review?.ef ?? 0).toString()),
              StatsItemWidget(
                  label: "Streak", value: (review?.repetition ?? 0).toString()),
              StatsItemWidget(
                  label: "Correct",
                  value: (review?.correctAnswers ?? 0).toString()),
              StatsItemWidget(
                  label: "Incorrect",
                  value: (review?.incorrectAnswers ?? 0).toString()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TitleSubtitleWidget(
                      title: "Next Review",
                      titleTextStyle:
                          const TextStyle(fontWeight: FontWeight.w500),
                      subtitle:
                          '${review?.nextDate?.day ?? '--'} / ${review?.nextDate?.month ?? '--'} / ${review?.nextDate?.year ?? '----'} ',
                      padding: const EdgeInsets.all(8.0)),
                  CircularPercentIndicator(
                    radius: 32,
                    lineWidth: 32 / 4,
                    circularStrokeCap: CircularStrokeCap.butt,
                    center: Text(
                      '${(reviewAccuracy() * 100).round()}%',
                      textAlign: TextAlign.center,
                    ),
                    percent: reviewAccuracy(),
                    progressColor: CustomColors.colorPercent(reviewAccuracy()),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
