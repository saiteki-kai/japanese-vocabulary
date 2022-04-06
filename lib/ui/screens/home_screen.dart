import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/routes.gr.dart';
import '../../data/models/word.dart';
import 'words_screen/words_screen.dart';

/// Widget for the basic definition of the [WordScreen].
///
/// This widget is called the [AppBar] and the [FloatingActionButton]
/// button to insert a new [Word] in the vocabulary.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
