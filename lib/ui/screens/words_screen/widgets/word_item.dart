import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../config/routes.gr.dart';
import '../../../../data/models/word.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/date.dart';

/// A widget that displays a [Word].
///
/// In this widget we have the composition of each single [inkwell]
/// to show the word and date of the next review,
/// in addition an average of the accuracy of the last two reviews is shown.
class WordItem extends StatelessWidget {
  /// Creates a word item widget.
  ///
  /// The [word] parameter is required.
  const WordItem({
    Key? key,
    required this.word,
  }) : super(key: key);

  /// The [word] from which details will be displayed.
  final Word word;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => _onWordPressed(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(DatesUtils.format(word.nextReview)),
                ],
              ),
              CircularPercentIndicator(
                radius: 28,
                lineWidth: 28 / 4,
                circularStrokeCap: CircularStrokeCap.butt,
                center: Text(
                  '${((word.meanAccuracy) * 100).round()}%',
                  textAlign: TextAlign.center,
                ),
                percent: word.meanAccuracy,
                progressColor: CustomColors.colorPercent(word.meanAccuracy),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onWordPressed(context) {
    AutoRouter.of(context).push(WordDetailsScreen(wordId: word.id));
  }
}
