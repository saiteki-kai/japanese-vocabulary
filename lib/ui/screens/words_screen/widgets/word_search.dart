import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes.gr.dart';
import '../../../../data/models/word.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/date.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/word_bloc.dart';
import '../../../../data/models/word.dart';
import '../../../widgets/screen_layout.dart';
import 'word_item.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/repositories/word_repository.dart';
import '../../../../data/models/word.dart';

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries",
  ];

  Future<List<Word>?> listWords() {
    WordRepository? repository;
    final words = repository!.getWords();

    return words;
  }

  // Clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // Pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // Show query result
  @override
  Widget buildResults(BuildContext context) {
    final List<String> matchQuery = [];
    for (var term in searchTerms) {
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(term);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  // Show the querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> matchQuery = [];
    for (var term in searchTerms) {
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(term);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
