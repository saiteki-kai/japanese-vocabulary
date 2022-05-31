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
  String searchString = "";

  WordBloc? _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<WordBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      appBar: AppBar(
        title: Column(
          children: [
            title,
            TextField(
              onChanged: _onChanged,
              decoration: const InputDecoration(
                labelText: 'Search...',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
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

  void _onChanged(String value) {
    /// Updates the state of the search
    setState(() {
      searchString = value.toLowerCase();
      _bloc?.add(WordsRetrieved(search: searchString));
    });
  }
}
