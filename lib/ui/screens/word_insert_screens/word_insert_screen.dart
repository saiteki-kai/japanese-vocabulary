import 'package:flutter/material.dart';
import '../../widgets/word_insert_widget.dart';

/// A widget that displays the insert word widget
class WordInsertScreen extends StatefulWidget {
  const WordInsertScreen({Key? key}) : super(key: key);

  @override
  State<WordInsertScreen> createState() => _WordInsertScreenState();
}

class _WordInsertScreenState extends State<WordInsertScreen> {
  @override
  Widget build(BuildContext context) {
    /// Creates a word insert screen widget.
    return const WordInsert();
  }
  
}
