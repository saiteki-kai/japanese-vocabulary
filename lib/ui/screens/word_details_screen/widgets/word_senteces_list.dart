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

    return BlocBuilder<SentenceBloc, SentenceState>(
      builder: (context, state) {
        if (state is SentencesLoaded) {
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
    );
  }
}
