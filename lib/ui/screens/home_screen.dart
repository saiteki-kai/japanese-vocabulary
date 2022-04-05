import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/word_bloc.dart';
import '../../data/app_database.dart';
import '../../data/models/word.dart';
import '../../data/repositories/word_repository.dart';
import '../../utils/initial_data.dart';
import 'word_item.dart';

/// Widget for the basic definition of the [WordScreen].
///
/// This widget is called the [AppBar] and the [FloatingActionButton]
/// button to insert a new [Word] in the vocabulary.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View words"),
      ),
      body: BlocProvider(
        create: (context) => WordBloc(repository: WordRepository()),
        child: const WordScreen(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () {},
        ),
      ),
    );
  }
}

/// This widget initializes values in the database by calling [_WordScreenState].
class WordScreen extends StatefulWidget {
  const WordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WordScreen> createState() => _WordScreenState();
}

/// A private widget that displays a list of [Word] and initialize database.
///
/// This widget initializes values in the database and also
/// allows you to view all the words in the dictionary through a scrolling list
/// that shows the text of the word,
/// the next revision date and an average of the accuracy of the last two revisions.
class _WordScreenState extends State<WordScreen> {
  WordBloc? bloc;

  @override
  void initState() {
    AppDatabase.instance.store.then((store) {
      initializeDB(store);
      bloc = BlocProvider.of<WordBloc>(context);
      bloc?.add(WordRetrived());
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
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
