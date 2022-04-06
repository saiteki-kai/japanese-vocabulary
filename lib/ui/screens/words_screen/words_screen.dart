import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/word_bloc.dart';
import '../../../data/app_database.dart';
import '../../../data/models/word.dart';
import '../../../utils/initial_data.dart';
import '../word_item.dart';

/// A private widget that displays a list of [Word] and initialize database.
///
/// This widget initializes values in the database and also
/// allows you to view all the words in the dictionary through a scrolling list
/// that shows the text of the word,
/// the next revision date and an average of the accuracy of the last two revisions.
class WordScreen extends StatefulWidget {
  const WordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  WordBloc? bloc;

  @override
  void initState() {
    AppDatabase.instance.store.then((store) {
      //initializeDB(store);
      bloc = BlocProvider.of<WordBloc>(context);
      bloc?.add(WordRetrieved());
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    bloc?.add(WordRetrieved());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordBloc, WordState>(
      builder: (context, state) {
        if (state is WordLoaded) {
          return ListView.builder(
            itemCount: state.words.length,
            itemBuilder: (context, index) {
              final Word word = state.words[index];
              return WordItem(word: word);
            },
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
