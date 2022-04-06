import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/word_bloc.dart';
import '../../../data/repositories/word_repository.dart';
import '../../widgets/word_insert_widget.dart';

/// A widget that displays the insert word widget
class WordInsertScreen extends StatefulWidget implements AutoRouteWrapper {
  const WordInsertScreen({Key? key}) : super(key: key);

  @override
  State<WordInsertScreen> createState() => _WordInsertScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => WordBloc(repository: WordRepository()),
      child: this,
    );
  }
}

class _WordInsertScreenState extends State<WordInsertScreen> {
  @override
  Widget build(BuildContext context) {
    /// Creates a word insert screen widget.
    return const WordInsert();
  }
}
