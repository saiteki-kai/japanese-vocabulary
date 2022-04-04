// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';

import '../../bloc/word_bloc.dart';
import '../../data/repositories/word_repository.dart';
import '../../data/models/word.dart';

class InsertWord extends StatefulWidget {
  const InsertWord({Key? key}) : super(key: key);

  @override
  State<InsertWord> createState() => _InsertWordState();
}

class _InsertWordState extends State<InsertWord> {
  Word _wordToAdd = Word(jlpt: 5, text: "", reading: "", meaning: "", pos: "");
  int _jlpt_value = 5;
  List<bool> _jlpt = [true, false, false, false, false];
  final List<bool> _jlpt_default = [true, false, false, false, false];
  final List<bool> _pos_default = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> _pos_names = [
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

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final GroupButtonController _posController = GroupButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordBloc, WordState>(builder: (context, state) {
      if (state is WordAdded) {
        return const Text("Added");
      } else if (state is WordInitial) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                //Navigator.pop(context);
              },
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("ciao");
                },
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Insert a word'),
                IconButton(
                    onPressed: () {
                      //WordBloc().add(event)
                      _wordToAdd.jlpt = _jlpt_value;
                      _wordToAdd.meaning = _meaningController.text;
                      _wordToAdd.reading = _readingController.text;
                      _wordToAdd.text = _textController.text;
                      final _pos_selected = _posController.selectedIndexes;
                      String posTmp =
                          _pos_selected.map((e) => _pos_names[e]).join(",");
                      //remove last ',' if any
                      if (posTmp.isNotEmpty) {
                        posTmp = posTmp.substring(0, posTmp.length - 1);
                      }
                      _wordToAdd.pos = posTmp;
                      print("meaning: ${_wordToAdd.meaning}");
                      print("pos: ${_wordToAdd.pos}");

                      FocusManager.instance.primaryFocus?.unfocus();

                      BlocProvider.of<WordBloc>(context)
                          .add(AddWordEvent(word: _wordToAdd));

/*
                      //clean the UI
                      //removable once every module is assembled together (?)
                      _jlpt.clear();
                      _jlpt.addAll(_jlpt_default);
                      _textController.clear();
                      _readingController.clear();
                      _meaningController.clear();
                      _posController.selectedIndexes.clear();
                      _posController.selectIndexes([]);
*/
                      //Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          body: Container(
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: const Text(
                        "Text",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: _textController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: const Text(
                        "Meaning",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: _meaningController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: const Text(
                        "Part of speech",
                      ),
                    ),
                    Center(
                      child: GroupButton(
                        options: GroupButtonOptions(
                            borderRadius: BorderRadius.circular(8)),
                        isRadio: false,
                        onSelected: (index, isSelected) {
                          print('$index button is ${index}');
                        },
                        buttons: _pos_names,
                        controller: _posController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: const Text(
                        "JLPT",
                      ),
                    ),
                    Center(
                      child: ChipsChoice<int>.single(
                        value: _jlpt_value,
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
                        choiceItems: [
                          C2Choice(value: 5, label: 'N5'),
                          C2Choice(value: 4, label: 'N4'),
                          C2Choice(value: 3, label: 'N3'),
                          C2Choice(value: 2, label: 'N2'),
                          C2Choice(value: 1, label: 'N1'),
                        ],
                        onChanged: (int value) {
                          setState(() => _jlpt_value = value);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return const Text("Error");
      }
    });
  }
}
