import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chips_choice/chips_choice.dart';
import '../../bloc/word_bloc.dart';
import '../../data/models/word.dart';

/// A widget that allows the user to add a new [Word] they want to learn.
class WordInsert extends StatefulWidget {
  /// Creates a word insert widget.
  const WordInsert({Key? key}) : super(key: key);

  @override
  State<WordInsert> createState() => _WordInsertState();
}

class _WordInsertState extends State<WordInsert> {
  final _wordToAdd = Word(jlpt: 5, text: "", reading: "", meaning: "", pos: "");

  /// The currently selected jlpt value
  int _jlptValue = 5;

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
    "vt"
  ];

  WordBloc? bloc;

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final GroupButtonController _posController = GroupButtonController();

  @override
  void initState() {
    bloc = BlocProvider.of<WordBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordBloc, WordState>(
      builder: (context, state) {
        if (state is WordLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Insert a word'),
                  IconButton(
                    onPressed: () {
                      _wordToAdd.jlpt = _jlptValue;
                      _wordToAdd.meaning = _meaningController.text;
                      _wordToAdd.reading = _readingController.text;
                      _wordToAdd.text = _textController.text;
                      final posSelected = _posController.selectedIndexes;

                      // A string built by concatenating the selected parts of speech names, following the format 'A,B,...,Z'
                      final posTmp =
                          posSelected.map((e) => _posNames[e]).join(",");
                      _wordToAdd.pos = posTmp;

                      bloc?.add(AddWordEvent(word: _wordToAdd));
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Text",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            controller: _textController,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Reading",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            controller: _readingController,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Meaning",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextField(
                            controller: _meaningController,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Part of speech",
                          ),
                        ),
                        Center(
                          child: GroupButton(
                            options: GroupButtonOptions(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isRadio: false,
                            onSelected: (index, isSelected) {},
                            buttons: _posNames,
                            controller: _posController,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "JLPT",
                          ),
                        ),
                        Center(
                          child: ChipsChoice<int>.single(
                            value: _jlptValue,
                            wrapped: true,
                            padding: EdgeInsets.zero,
                            choiceStyle: C2ChoiceStyle(
                              color: Colors.indigo,
                              borderColor: Colors.indigo[400],
                              brightness: Brightness.dark,
                              borderRadius: BorderRadius.circular(8.0),
                              margin: const EdgeInsets.only(
                                  left: 4.0, right: 4.0, bottom: 8.0),
                            ),
                            choiceItems: const [
                              C2Choice(value: 5, label: 'N5'),
                              C2Choice(value: 4, label: 'N4'),
                              C2Choice(value: 3, label: 'N3'),
                              C2Choice(value: 2, label: 'N2'),
                              C2Choice(value: 1, label: 'N1'),
                            ],
                            onChanged: (int value) {
                              /// Updates the currently selected value
                              setState(() => _jlptValue = value);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text("Error");
        }
      },
      listener: (context, state) {
        if (state is WordAdded) {
          bloc?.add(WordRetrieved());
          AutoRouter.of(context).pop();
        }
      },
      buildWhen: (previous, current) {
        return current is! WordAdded;
      },
    );
  }
}
