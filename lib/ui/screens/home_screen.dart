import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../config/routes.gr.dart';
import '../../data/models/review.dart';
import '../../data/models/word.dart';
import 'words_screen/words_screen.dart';

/// Widget for the basic definition of the [WordScreen].
///
/// This widget is called the [AppBar] and the [FloatingActionButton]
/// button to insert a new [Word] in the vocabulary.
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final Word word = () {
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
  }();

  //AutoRouter.of(context).push(WordDetailsScreen(word: word)
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          /// Removes the focus from the input fields when clicking outside of them
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: const Center(
          child: WordScreen(),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Colors.amber,
            onPressed: () {
              AutoRouter.of(context).push(const WordInsertScreen());
            },
          ),
        ),
      ),
    );
  }
}
