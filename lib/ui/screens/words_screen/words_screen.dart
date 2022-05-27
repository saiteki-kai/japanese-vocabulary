import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/word_bloc.dart';
import '../../../data/models/word.dart';
import '../../widgets/screen_layout.dart';
import 'widgets/word_item.dart';
import 'widgets/word_search.dart';

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
  _WordScreenState createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  Icon customIcon = const Icon(Icons.search);
  Widget title = const Text('Words');
  Widget searchBar = _setSearchBar();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WordBloc>(context).add(WordsRetrieved());

    return ScreenLayout(
      appBar: AppBar(
        title: Column(
          children: [
            title,
            searchBar,
          ],
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 105,
      ),
      padding: EdgeInsets.zero,
      child: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state is WordsLoaded) {
            return ListView.builder(
              itemCount: state.words.length,
              itemBuilder: (context, index) {
                final Word word = state.words[index];
                //print(word);
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

ListTile _setSearchBar() {
  return ListTile(
    leading: const Icon(
      Icons.search,
      color: Colors.white,
      size: 28,
    ),
    title: TextField(
      decoration: const InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
        border: InputBorder.none,
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: TextEditingController(),
    ),
    onTap: () => _onTapFunction(),
  );
}

void _onTapFunction() {
  print("Searching onTap....");
}
