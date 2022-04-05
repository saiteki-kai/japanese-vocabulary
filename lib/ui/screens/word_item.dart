import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../data/models/word.dart';

class WordItem extends StatelessWidget {
  const WordItem({
    Key? key,
    required this.word,
  }) : super(key: key);

  final Word? word;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 5, bottom: 8),
                child: Text(word?.text ?? "Error",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 8),
                child: Text(
                    '${word?.nextReview?.day ?? '--'} / ${word?.nextReview?.month ?? '--'} / ${word?.nextReview?.year ?? '----'} '),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4, bottom: 4),
                child: CircularPercentIndicator(
                  radius: 25,
                  lineWidth: 25 / 4,
                  circularStrokeCap: CircularStrokeCap.butt,
                  center: Text(
                    '${((word?.meanAccuracy ?? 0.0) * 100).round()}%',
                    textAlign: TextAlign.center,
                  ),
                  percent: word?.meanAccuracy ?? 0.0,
                  progressColor: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
