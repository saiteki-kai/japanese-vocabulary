import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/word_bloc.dart';
import '../../../widgets/sentence_dialog.dart';
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
  final _sentenceTextController = TextEditingController();
  final _sentenceTranslationController = TextEditingController();

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
                final word = widget.word;

                return SentenceItem(
                  sentence: sentence,
                  editCallback: () => showSentenceDialog(
                    context,
                    "Edit this example sentence",
                    _sentenceTextController,
                    _sentenceTranslationController,
                    () => setState(() {
                      _onEditSentencePressed(
                        context,
                        word,
                        index,
                        sentence,
                      );
                    }),
                    sentence: sentence,
                  ),
                  deleteCallback: () => _showAlertDialog(
                    context,
                    () => setState(() {
                      _deleteCallback(
                        word,
                        index,
                      );
                    }),
                    continueText: "Delete",
                    title: "Would you like to delete this sentence?",
                    message: sentence.text,
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

  void _onEditSentencePressed(
    BuildContext context,
    Word word,
    int index,
    Sentence sentence,
  ) {
    final text = _sentenceTextController.text.trim();
    final translation = _sentenceTranslationController.text.trim();
    FocusScope.of(context).requestFocus(FocusNode());
    final sentences = word.sentences;
    final noEqualSentences =
        sentences.every((element) => element.text != text) ||
            sentence.text == text;

    if (text.isNotEmpty && translation.isNotEmpty && noEqualSentences) {
      sentence.text = text;
      sentence.translation = translation;
      final sentenceToEdit = word.sentences.elementAt(index);
      sentenceToEdit.text = text;
      sentenceToEdit.translation = translation;

      _bloc?.add(WordAdded(word: word));
      _sentenceTextController.clear();
      _sentenceTranslationController.clear();
      Navigator.pop(context);
    }
  }

  void _deleteCallback(Word word, int index) {
    word.sentences.removeAt(index);
    _bloc?.add(WordAdded(word: word));
    _bloc?.add(WordRetrieved(wordId: word.id));
    Navigator.pop(context);
  }
}

_showAlertDialog(
  BuildContext context,
  VoidCallback continueCallback, {
  String continueText = "Continue",
  String title = "Are you sure?",
  String message = "",
}) {
  // set up the buttons
  final cancelButton = TextButton(
    key: const Key("alert-cancel"),
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  final continueButton = TextButton(
    key: const Key("alert-confirm"),
    child: Text(continueText),
    onPressed: continueCallback,
  );
  // set up the AlertDialog
  final alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
