import 'package:flutter/material.dart';

import '../../../../data/models/sentence.dart';

class SentenceItem extends StatelessWidget {
  const SentenceItem({
    Key? key,
    required this.sentence,
  }) : super(key: key);

  final Sentence sentence;

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
                    sentence.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sentence.translation,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onWordPressed(context) {
    //AutoRouter.of(context).push(WordDetailsScreen(wordId: word.id));
  }
}
