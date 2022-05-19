import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sentence_item.dart';
import '../../../../bloc/sentence_bloc.dart';
import '../../../../data/models/sentence.dart';
import '../../../../data/models/word.dart';

class SentencesList extends StatelessWidget {
  const SentencesList({
    Key? key,
    required this.word,
  }) : super(
          key: key,
        );

  final Word word;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SentenceBloc>(context).add(SentencesRetrieved(word: word));

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: BlocBuilder<SentenceBloc, SentenceState>(
        builder: (context, state) {
          if (state is SentencesLoaded) {
            if (state.sentences.isEmpty) {
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
              itemCount: state.sentences.length,
              itemBuilder: (context, index) {
                final Sentence sentence = state.sentences[index];

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
