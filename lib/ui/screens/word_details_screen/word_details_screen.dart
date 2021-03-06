import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/word_bloc.dart';
import '../../../data/models/sentence.dart';
import '../../../data/models/word.dart';
import '../../widgets/floating_action_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/screen_layout.dart';
import '../../widgets/sentence_dialog.dart';
import './widgets/word_stats_tab.dart';
import './widgets/word_details_appbar.dart';
import './widgets/word_details_tab.dart';

/// A widget that displays the details and the statistics of a [Word] from the associated reviews.
///
/// A [TabBar] is used, where the word details are displayed in a [WordDetailsTab] and
/// the statistics associated with the word associated reviews are displayed in a [WordStatisticsTab].
class WordDetailsScreen extends StatefulWidget {
  /// Creates a word details widget.
  ///
  /// The [wordId] parameter is required and must not be null.
  const WordDetailsScreen({Key? key, required this.wordId}) : super(key: key);

  /// The [wordId] from which details and statistics will be displayed, must not be null.
  final int wordId;

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _sentenceTextController = TextEditingController();
  final TextEditingController _sentenceTranslationController =
      TextEditingController();
  WordBloc? _bloc;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    _bloc = BlocProvider.of<WordBloc>(context);
    _bloc?.add(WordRetrieved(wordId: widget.wordId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state is WordLoaded) {
            final word = state.word;

            return Scaffold(
              body: ScreenLayout(
                appBar: WordDetailsAppBar(
                  title: word.text,
                  tabController: _tabController,
                  word: word,
                ),
                padding: EdgeInsets.zero,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    WordDetailsTab(word: word),
                    WordStatisticsTab(word: word),
                  ],
                ),
              ),
              floatingActionButton: floatingActionButton(
                key: const Key("sentence-floating"),
                show: true,
                onPressed: () => showSentenceDialog(
                  context,
                  "Enter an example sentence",
                  _sentenceTextController,
                  _sentenceTranslationController,
                  () => _onAddSentencePressed(
                    context,
                    word,
                  ),
                ),
              ),
            );
          } else if (state is WordError) {
            return Text(state.message);
          } else {
            return const LoadingIndicator(message: "Loading...");
          }
        },
      ),
    );
  }

  Future<bool> _onBack() {
    _bloc?.add(const WordsRetrieved());

    return Future.value(true);
  }

  void _onAddSentencePressed(
    BuildContext context,
    Word word,
  ) {
    /// Adds a new example sentence
    final text = _sentenceTextController.text;
    final translation = _sentenceTranslationController.text;
    FocusScope.of(context).requestFocus(FocusNode());
    final sentences = word.sentences;
    final noEqualSentences = sentences.every((element) => element.text != text);
    if (text.isNotEmpty && translation.isNotEmpty && noEqualSentences) {
      setState(() {
        sentences.add(Sentence(text: text, translation: translation));
        _bloc?.add(WordAdded(word: word));
        _sentenceTextController.clear();
        _sentenceTranslationController.clear();
        Navigator.pop(context);
      });
    }
  }
}
