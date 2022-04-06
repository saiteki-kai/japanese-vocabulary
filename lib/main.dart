import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'config/routes.gr.dart';

void main() {
  runApp(JapaneseVocabularyApp());
}

class JapaneseVocabularyApp extends StatelessWidget {
  JapaneseVocabularyApp({Key? key}) : super(key: key);

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Japanese Vocabulary',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          filled: true,
        ),
      ),
      routerDelegate: AutoRouterDelegate(_appRouter),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
