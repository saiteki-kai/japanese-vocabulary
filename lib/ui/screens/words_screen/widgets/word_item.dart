import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../config/routes.gr.dart';
import '../../../../data/models/word.dart';
import '../../../../utils/colors.dart';

/// A widget that displays a [Word].
///
/// In this widget we have the composition of each single [inkwell]
/// to show the word and date of the next review,
/// in addition an average of the accuracy of the last two reviews is shown.
class WordItem extends StatelessWidget {
  /// Creates a word item widget.
  ///
  /// The [word] parameter is required and must not be null.
  const WordItem({
    Key? key,
    required this.word,
  }) : super(key: key);

  /// The [word] from which details will be displayed, must not be null.
  final Word? word;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (word != null) {
          AutoRouter.of(context).push(WordDetailsScreen(wordId: word!.id));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
                  child: Text(word?.text ?? "Loading...",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(
                      '${word?.nextReview?.day ?? '--'} / ${word?.nextReview?.month ?? '--'} / ${word?.nextReview?.year ?? '----'} '),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircularPercentIndicator(
                    radius: 25,
                    lineWidth: 25 / 4,
                    circularStrokeCap: CircularStrokeCap.butt,
                    center: Text(
                      '${((word?.meanAccuracy ?? 0.0) * 100).round()}%',
                      textAlign: TextAlign.center,
                    ),
                    percent: word?.meanAccuracy ?? 0.0,
                    progressColor:
                        CustomColors.colorPercent(word?.meanAccuracy ?? 0.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
