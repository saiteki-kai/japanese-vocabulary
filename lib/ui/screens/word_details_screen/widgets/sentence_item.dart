import 'package:flutter/material.dart';

import '../../../../data/models/sentence.dart';

/// A widget that displays the [sentence] associated to a [Word].
///
/// The sentence are displayed by using the [SentenceItem] widget.
/// Text and traslation of sentence are show.
class SentenceItem extends StatelessWidget {
  /// Creates a sentence widget.
  ///
  /// [sentence] parameter are required and must not be null.
  const SentenceItem({
    Key? key,
    required this.sentence,
  }) : super(key: key);

  /// [sentence] associated to a [word].
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
                    key: const Key("textSentenceTest"),
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

  void _onWordPressed(_) {
    return;
  }
}
