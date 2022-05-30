import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/word_bloc.dart';
import '../../../widgets/sentence_item.dart';
import '../../../../data/models/sentence.dart';
import '../../../../data/models/word.dart';

/// A widget that displays the sentences associated to a [Word].
///
/// The sentences are displayed by using the [SentencesList] widget.
/// Text and traslation of sentences are show.
class SentencesList extends StatefulWidget {
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
  State<SentencesList> createState() => _SentencesListState();
}

class _SentencesListState extends State<SentencesList> {
  WordBloc? _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<WordBloc>(context);
    _bloc?.add(WordRetrieved(wordId: widget.word.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

                return SentenceItem(
                  sentence: sentence,
                  deleteCallback: () => setState(
                    () {
                      _onDeletePressed(_bloc, widget.word, sentence);
                    },
                  ),
                );
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

void _onDeletePressed(WordBloc? bloc, Word word, Sentence sentence) {
  word.sentences.remove(sentence);
  bloc?.add(WordAdded(word: word));
  bloc?.add(WordRetrieved(wordId: word.id));
}
