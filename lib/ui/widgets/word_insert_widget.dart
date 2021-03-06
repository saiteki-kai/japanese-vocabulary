import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter/material.dart';
import '../../bloc/word_bloc.dart';
import '../../data/models/sentence.dart';
import '../../data/models/word.dart';
import 'screen_layout.dart';
import 'sentence_dialog.dart';
import 'sentence_item.dart';

/// A widget that allows the user to add a new [Word] they want to learn.
class WordInsert extends StatefulWidget {
  /// Creates a word insert widget.
  const WordInsert({Key? key, this.wordToAdd}) : super(key: key);

  /// Word passed to the widget in case the fields need to be pre-filled (i.e. edit functionality)
  final Word? wordToAdd;

  @override
  State<WordInsert> createState() => _WordInsertState();
}

class _WordInsertState extends State<WordInsert> {
  Word _wordToAdd = Word(jlpt: 5, text: "", reading: "", meaning: "", pos: "");
  Text titleInsert = const Text("Insert a word");

  /// The currently selected jlpt button index
  int _jlptIndex = -1;

  /// The list of selected pos
  final List<int> _posSelected = [];

  /// The list of selectable jlpt levels
  final List<String> _jlptNames = ["N5", "N4", "N3", "N2", "N1"];
  final _jlptValues = [5, 4, 3, 2, 1];

  /// The list of example sentences that will be associated to the word
  final List<Sentence> _sentences = [];

  /// The list of the selectable parts of speech names
  final List<String> _posNames = [
    "adj-i",
    "adj-na",
    "adj-no",
    "adv",
    "aux",
    "aux-adj",
    "aux-v",
    "conj",
    "ctr",
    "exp",
    "int",
    "n",
    "n-adv",
    "n-pr",
    "pn",
    "pref",
    "prt",
    "suf",
    "vi",
    "vs-s",
    "vt",
  ];

  WordBloc? _bloc;
  final _textController = TextEditingController();
  final _readingController = TextEditingController();
  final _meaningController = TextEditingController();
  final _sentenceTextController = TextEditingController();
  final _sentenceTranslationController = TextEditingController();
  final _posController = GroupButtonController();
  final _jlptController = GroupButtonController();
  final _sentenceEditTextController = TextEditingController();
  final _sentenceEditTranslationController = TextEditingController();

  @override
  void initState() {
    _bloc = BlocProvider.of<WordBloc>(context);
    super.initState();
    final wordToAdd = widget.wordToAdd;
    if (wordToAdd != null) {
      titleInsert = const Text("Edit a word");

      /// If a word has been passed, fill in the fields
      _wordToAdd.id = wordToAdd.id;
      _wordToAdd.readingReview.target = wordToAdd.readingReview.target;
      _wordToAdd.meaningReview.target = wordToAdd.meaningReview.target;
      _textController.text = wordToAdd.text;
      _readingController.text = wordToAdd.reading;
      _meaningController.text = wordToAdd.meaning;
      _jlptIndex = _jlptValues.indexOf(wordToAdd.jlpt);
      final posNamesToSelect = wordToAdd.pos.split(',');
      _posSelected.addAll(posNamesToSelect.map(_posNames.indexOf).toList());
      _posSelected.remove(-1);
      _posController.selectIndexes(_posSelected);

      _bloc?.add(WordRetrieved(wordId: _wordToAdd.id));
      _sentences.addAll(wordToAdd.sentences);
    }

    _jlptController.selectIndex(_jlptIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
        appBar: AppBar(
          elevation: 0,
          title: titleInsert,
          actions: [
            IconButton(
              key: const Key(
                "word-button",
              ),
              onPressed: _onPressed,
              icon: const Icon(Icons.check, color: Colors.white),
            ),
          ],
        ),
        padding: EdgeInsets.zero,
        child: BlocBuilder<WordBloc, WordState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      _FormItem(
                        title: "Text",
                        field: TextField(
                          key: const Key(
                            "text",
                          ),
                          controller: _textController,
                        ),
                      ),
                      _FormItem(
                        title: "Reading",
                        field: TextField(
                          key: const Key(
                            "reading",
                          ),
                          controller: _readingController,
                        ),
                      ),
                      _FormItem(
                        title: "Meaning",
                        field: TextField(
                          key: const Key(
                            "meaning",
                          ),
                          controller: _meaningController,
                        ),
                      ),
                      _FormItem(
                        title: "Part of speech",
                        field: Center(
                          child: GroupButton(
                            key: const Key(
                              "pos",
                            ),
                            options: GroupButtonOptions(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isRadio: false,
                            onSelected: _onPosSelected,
                            buttons: _posNames,
                            controller: _posController,
                          ),
                        ),
                      ),
                      _FormItem(
                        title: "JLPT",
                        field: Center(
                          child: GroupButton(
                            key: const Key(
                              "jlpt",
                            ),
                            options: GroupButtonOptions(
                              borderRadius: BorderRadius.circular(8),
                              buttonWidth: 50,
                            ),
                            isRadio: true,
                            enableDeselect: true,
                            controller: _jlptController,
                            onSelected: _onJlptSelected,
                            buttons: _jlptNames,
                          ),
                        ),
                      ),
                      _FormItem(
                        title: "Examples",
                        field: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    verticalDirection: VerticalDirection.down,
                                    children: [
                                      TextField(
                                        key: const Key(
                                          "sentence-text-i",
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: "Sentence",
                                        ),
                                        controller: _sentenceTextController,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      TextField(
                                        key: const Key(
                                          "sentence-translation-i",
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: "Translation",
                                        ),
                                        controller:
                                            _sentenceTranslationController,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  key: const Key(
                                    "sentence-button-i",
                                  ),
                                  onPressed: _onAddSentencePressed,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              key: const Key(
                                "sentence-listview",
                              ),
                              itemCount: _sentences.length,
                              itemBuilder: (context, index) {
                                final sentence = _sentences[index];

                                return SentenceItem(
                                  sentence: sentence,
                                  editCallback: () => showSentenceDialog(
                                    context,
                                    "Edit this example sentence",
                                    _sentenceEditTextController,
                                    _sentenceEditTranslationController,
                                    () => _onEditSentencePressed(
                                      index,
                                      sentence.text,
                                    ),
                                    sentence: sentence,
                                  ),
                                  deleteCallback: () => _onDeletePressed(index),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onEditSentencePressed(int index, String oldText) {
    final text = _sentenceEditTextController.text;
    final translation = _sentenceEditTranslationController.text;
    final noEqualSentences =
        _sentences.every((element) => element.text != text) || oldText == text;
    if (text.isNotEmpty && translation.isNotEmpty && noEqualSentences) {
      setState(() {
        _sentences[index] = _sentences[index].copyWith(
          text: text,
          translation: translation,
        );
      });
      _sentenceEditTextController.clear();
      _sentenceEditTranslationController.clear();
      Navigator.pop(context);
    }
  }

  void _onDeletePressed(int index) {
    setState(() {
      _sentences.removeAt(index);
    });
  }

  void _onPressed() {
    // A string built by concatenating the selected parts of speech names, following the format 'A,B,...,Z'
    _posSelected.remove(-1);
    final posTmp = _posSelected.map((e) => _posNames[e]).join(",");

    _wordToAdd = _wordToAdd.copyWith(
      text: _textController.text,
      reading: _readingController.text,
      meaning: _meaningController.text,
      jlpt: _jlptIndex == -1 ? null : _jlptValues[_jlptIndex],
      pos: posTmp,
    );

    // Just to check if all the mandatory fields are not empty
    // If the mandatory fields are not compiled it doesn't insert or edit.
    // Also doesn't change route.
    if (_wordToAdd.text.isNotEmpty &&
        _wordToAdd.reading.isNotEmpty &&
        _wordToAdd.meaning.isNotEmpty) {
      _wordToAdd.sentences.addAll(_sentences);
      _bloc?.add(WordAdded(word: _wordToAdd));

      AutoRouter.of(context).pop();
    }
  }

  void _onAddSentencePressed() {
    /// Adds a new example sentence.
    final text = _sentenceTextController.text;
    final translation = _sentenceTranslationController.text;
    FocusScope.of(context).requestFocus(FocusNode());

    if (text.isNotEmpty &&
        translation.isNotEmpty &&
        _sentences.every((element) => element.text != text)) {
      setState(() {
        _sentences.add(Sentence(text: text, translation: translation));
        _sentenceTextController.clear();
        _sentenceTranslationController.clear();
      });
    }
  }

  void _onPosSelected(int index, bool selected) {
    /// Updates the currently selected POS.
    setState(() {
      if (selected) {
        _posSelected.add(index);
      } else {
        _posSelected.remove(index);
      }
    });
  }

  void _onJlptSelected(int index, bool __) {
    /// Updates the currently selected JLPT level value
    _jlptController.selectedIndex!;
    _jlptIndex = index;
  }
}

class _FormItem extends StatelessWidget {
  const _FormItem({
    Key? key,
    required this.title,
    required this.field,
  }) : super(key: key);

  /// The name of the field placed on top.
  final String title;

  /// The form field.
  final Widget field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(title),
          ),
          field,
        ],
      ),
    );
  }
}
