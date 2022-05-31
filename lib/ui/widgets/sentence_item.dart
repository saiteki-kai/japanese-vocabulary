import 'package:flutter/material.dart';

import '../../data/models/sentence.dart';

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
    required this.deleteCallback,
  }) : super(key: key);

  /// [sentence] associated to a [word].
  final Sentence sentence;

  final VoidCallback deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Flexible(
                      child: Text(
                        sentence.text,
                        key: const Key("textSentenceTest"),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        sentence.translation,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key("sentence-delete"),
                onPressed: deleteCallback,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
