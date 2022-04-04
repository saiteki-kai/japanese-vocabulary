import 'package:flutter/material.dart';
import 'package:japanese_vocabulary/ui/screens/word_item.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../data/models/review.dart';
import '../../data/models/word.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Word word() {
    final Word word = Word(
      id: 0,
      text: "言葉",
      reading: "ことば",
      jlpt: 5,
      meaning: "word; phrase; expression; term",
      pos: "Noun",
    );

    final mRev = Review(
      id: 0,
      ef: 2.5,
      correctAnswers: 0,
      incorrectAnswers: 0,
      interval: 0,
      nextDate: null,
      repetition: 0,
      type: "meaning",
    );

    final rRev = Review(
      id: 0,
      ef: 2.5,
      correctAnswers: 0,
      incorrectAnswers: 0,
      interval: 0,
      nextDate: null,
      repetition: 0,
      type: "reading",
    );

    mRev.word.target = word;
    rRev.word.target = word;

    word.meaningReview.target = mRev;
    word.readingReview.target = rRev;

    return word;
  }

  @override
  Widget build(BuildContext context) {
    final List<Word> words = [word(), word(), word()];
    return Scaffold(
      appBar: AppBar(
        title: const Text("View words"),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (BuildContext, index) {
          final Word? word = words[index];
          return WordItem(word: word);
        },
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
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
