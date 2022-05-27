import 'package:flutter/material.dart';
import '../../../../data/models/word.dart';
import '../../../../data/repositories/word_repository.dart';

/// A widget that allows the user to search a [Word] they want to learn.
class SearchBar extends ListTile {
  const SearchBar({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();

    return ListTile(
      leading: const Icon(
        Icons.search,
        color: Colors.white,
        size: 28,
      ),
      title: TextField(
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: _textController,
      ),
      onTap: _onTapFunction,
    );
  }

  void _onTapFunction() {
    print("Searching onTap....");
  }
}
