import 'package:flutter/material.dart';

import '../../../../data/models/review.dart';

class ReviewAnswer extends StatelessWidget {
  const ReviewAnswer({
    Key? key,
    required this.review,
    required this.hidden,
  }) : super(key: key);

  final Review review;
  final ValueNotifier<bool> hidden;

  String get meaning => review.word.target?.meaning ?? "<NA>";
  String get reading => review.word.target?.reading ?? "<NA>";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hidden,
      builder: (BuildContext context, bool value, Widget? child) {
        return Visibility(
          visible: !value,
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          child: Text(
            review.type == "meaning" ? meaning : reading,
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 22.0),
          ),
        );
      },
    );
  }
}
