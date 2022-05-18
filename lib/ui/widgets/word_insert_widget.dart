import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter/material.dart';
import '../../bloc/word_bloc.dart';
import '../../data/models/word.dart';
import 'screen_layout.dart';

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
  final _wordToAdd = Word(jlpt: 5, text: "", reading: "", meaning: "", pos: "");
  bool editing = false;

  /// The currently selected jlpt button index
  int _jlptIndex = -1;

  /// The list of seleected pos
  final List<int> _posSelected = [];

  /// The list of selectable jlpt levels
  final List<String> _jlptNames = ["N5", "N4", "N3", "N2", "N1"];
  final _jlptValues = [5, 4, 3, 2, 1];

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
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final GroupButtonController _posController = GroupButtonController();
  final GroupButtonController _jlptController = GroupButtonController();

  @override
  void initState() {
    _bloc = BlocProvider.of<WordBloc>(context);
    super.initState();
    final wordToAdd = widget.wordToAdd;
    if (wordToAdd != null) {
      editing = true;

      /// If a word has been passed, fill in the fields
      _wordToAdd.id = wordToAdd.id;
      _textController.text = wordToAdd.text;
      _readingController.text = wordToAdd.reading;
      _meaningController.text = wordToAdd.meaning;
      _jlptIndex = _jlptValues.indexOf(wordToAdd.jlpt);
      final posNamesToSelect = wordToAdd.pos.split(',');
      _posSelected.addAll(posNamesToSelect.map(_posNames.indexOf).toList());
      _posSelected.remove(-1);
      _posController.selectIndexes(_posSelected);

      _bloc?.add(WordRetrieved(wordId: _wordToAdd.id));
    }

    _jlptController.selectIndex(_jlptIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
        appBar: AppBar(
          elevation: 0,
          title: title(editing),
          actions: [
            IconButton(
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
                          key: const Key("text"),
                          controller: _textController,
                        ),
                      ),
                      _FormItem(
                        title: "Reading",
                        field: TextField(
                          key: const Key("reading"),
                          controller: _readingController,
                        ),
                      ),
                      _FormItem(
                        title: "Meaning",
                        field: TextField(
                          key: const Key("meaning"),
                          controller: _meaningController,
                        ),
                      ),
                      _FormItem(
                        title: "Part of speech",
                        field: Center(
                          child: GroupButton(
                            key: const Key("pos"),
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
                            key: const Key("jlpt"),
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

  void _onPressed() {
    _wordToAdd.jlpt = _jlptValues[_jlptIndex];
    _wordToAdd.meaning = _meaningController.text;
    _wordToAdd.reading = _readingController.text;
    _wordToAdd.text = _textController.text;

    // A string built by concatenating the selected parts of speech names, following the format 'A,B,...,Z'
    _posSelected.remove(-1);
    final posTmp = _posSelected.map((e) => _posNames[e]).join(",");
    _wordToAdd.pos = posTmp;

    if (editing) {
      // Edit
      _bloc?.add(WordEdited(word: _wordToAdd));
    } else {
      // Insert
      _bloc?.add(WordAdded(word: _wordToAdd));
    }

    AutoRouter.of(context).pop();
  }

  void _onPosSelected(int index, bool selected) {
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

  Text title(bool editing) {
    /// Updates the currently title
    if (editing) {
      return const Text('Edit a word');
    }

    return const Text('Insert a word');
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
