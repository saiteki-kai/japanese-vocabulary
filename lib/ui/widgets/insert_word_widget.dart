import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter/material.dart';

import '../../bloc/word_bloc.dart';
import '../../data/repositories/word_repository.dart';
import '../../data/models/word.dart';

class InsertWord extends StatefulWidget {
  const InsertWord({Key? key}) : super(key: key);

  @override
  State<InsertWord> createState() => _InsertWordState();
}

class _InsertWordState extends State<InsertWord> {
  final WordRepository _wordRepository = WordRepository();

  List<int> _selectedPOS = [];
  Word _wordToAdd = Word(jlpt: 5, text: "", reading: "", meaning: "", pos: "");
  int _jlpt_value = 5;
  String? _meaning;
  String? _text;
  String? _reading;
  List<bool> _jlpt = [true, false, false, false, false];
  final List<bool> _jlpt_default = [true, false, false, false, false];
  List<bool> _pos = [
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
            const Text('Insert a new item'),
            IconButton(
                onPressed: () {
                  //WordBloc().add(event)
                  _wordToAdd.jlpt = _jlpt_value;
                  _wordToAdd.meaning = _meaningController.text;
                  _wordToAdd.reading = _readingController.text;
                  _wordToAdd.text = _textController.text;

                  String pos_tmp = "";
                  //build string from selected elements
                  for (int i = 0; i < _pos.length; i++) {
                    if (_pos[i]) pos_tmp += _pos_names[i] + ",";
                  }
                  //remove last ',' if any
                  if (pos_tmp.isNotEmpty) {
                    pos_tmp = pos_tmp.substring(0, pos_tmp.length - 1);
                  }
                  _wordToAdd.pos = pos_tmp;
                  print("meaning: ${_wordToAdd.meaning}");
                  print("pos: ${_wordToAdd.pos}");

                  FocusManager.instance.primaryFocus?.unfocus();

                  BlocProvider.of<WordBloc>(context)
                      .add(AddWordEvent(word: _wordToAdd));

                  //clean the UI
                  //removable once every module is assembled together (?)
                  _pos.clear();
                  _pos.addAll(_pos_default);
                  _jlpt.clear();
                  _jlpt.addAll(_jlpt_default);
                  _textController.clear();
                  _readingController.clear();
                  _meaningController.clear();
                  _selectedPOS = [];
                  _posController.selectedIndexes.clear();
                  _posController.selectIndexes([]);

                  //Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      body: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state is WordAdded) {
            //should return to home_screen
            return const Text("Added");
          } else if (state is WordInitial) {
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      const Text(
                        "Text",
                        style: TextStyle(
                            color: Color.fromARGB(255, 171, 127, 111)),
                      ),
                      TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        "Reading",
                        style: TextStyle(
                            color: Color.fromARGB(255, 171, 127, 111)),
                      ),
                      TextField(
                        controller: _readingController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        "Meaning",
                        style: TextStyle(
                            color: Color.fromARGB(255, 171, 127, 111)),
                      ),
                      TextField(
                        controller: _meaningController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        "Part of speech",
                        style: TextStyle(
                            color: Color.fromARGB(255, 171, 127, 111)),
                      ),
                      GroupButton(
                        isRadio: false,
                        onSelected: (index, isSelected) {
                          _selectedPOS.add(index);
                          _pos[index] = !_pos[index];
                          print('$index button is ${_pos[index]}');
                        },
                        buttons: _pos_names,
                        controller: _posController,
                      ),
                      const Text(
                        "JLPT",
                        style: TextStyle(
                            color: Color.fromARGB(255, 171, 127, 111)),
                      ),
                      ToggleButtons(
                        fillColor: const Color.fromARGB(255, 63, 81, 180),
                        selectedColor: Colors.white,
                        borderColor: Colors.transparent,
                        selectedBorderColor: Colors.transparent,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          Text("N5"),
                          Text("N4"),
                          Text("N3"),
                          Text("N2"),
                          Text("N1"),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < _jlpt.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                _jlpt[buttonIndex] = true;
                                _jlpt_value = index + 1;
                              } else {
                                _jlpt[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: _jlpt,
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Text("Something went wrong");
          }
        },
      ),
    );
  }
}
