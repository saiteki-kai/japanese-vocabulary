import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japanese_vocabulary/ui/widgets/word_insert_widget.dart';

import '../../bloc/word_bloc.dart';
import '../../data/repositories/word_repository.dart';
import 'word_insert_screens/word_insert_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WordBloc>(
          create: (BuildContext context) =>
              WordBloc(repository: WordRepository()),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            /// Removes the focus from the input fields when clicking outside of them
            currentFocus.unfocus();
          }
        },
        child: const Scaffold(
          body: Center(
            child: WordInsertScreen(),
          ),
        ),
      ),
    );
  }
}
