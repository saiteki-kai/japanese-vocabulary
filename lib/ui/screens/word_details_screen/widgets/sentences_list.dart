import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/word_bloc.dart';
import 'sentence_item.dart';
import '../../../../data/models/sentence.dart';
import '../../../../data/models/word.dart';

/// A widget that displays the sentences associated to a [Word].
///
/// The sentences are displayed by using the [SentencesList] widget.
/// Text and traslation of sentences are show.
class SentencesList extends StatelessWidget {
  /// Creates a sentences widget.
  ///
  /// [word] parameter are required and must not be null.
  const SentencesList({
    Key? key,
    required this.word,
  }) : super(
          key: key,
        );

  /// [word] containing the sentences to show.
  final Word word;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WordBloc>(context).add(WordRetrieved(wordId: word.id));

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state is WordLoaded) {
            final sentences = state.word.sentences;
            if (sentences.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "No senteces found",
                    key: Key("noSentenceTest"),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: sentences.length,
              itemBuilder: (context, index) {
                final Sentence sentence = sentences[index];

                return SentenceItem(sentence: sentence);
              },
              padding: EdgeInsets.zero,
              shrinkWrap: true,
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
