import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/word_bloc.dart';
import '../../../data/models/word.dart';
import '../../widgets/screen_layout.dart';
import 'widgets/word_item.dart';

/// A private widget that displays a list of [Word] and initialize database.
///
/// This widget initializes values in the database and also
/// allows you to view all the words in the dictionary through a scrolling list
/// that shows the text of the word,
/// the next revision date and an average of the accuracy of the last two revisions.
class WordScreen extends StatelessWidget {
  const WordScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WordBloc>(context).add(WordsRetrieved());

    return ScreenLayout(
      appBar: AppBar(title: const Text("Words"), elevation: 0),
      padding: EdgeInsets.zero,
      child: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state is WordsLoaded) {
            return ListView.builder(
              itemCount: state.words.length,
              itemBuilder: (context, index) {
                final Word word = state.words[index];

                return WordItem(word: word);
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
