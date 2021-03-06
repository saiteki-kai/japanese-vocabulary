import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/settings_bloc.dart';
import 'config/routes.gr.dart';
import 'bloc/review_bloc.dart';
import 'bloc/word_bloc.dart';
import 'data/app_database.dart';
import 'data/models/review.dart';
import 'data/models/word.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/word_repository.dart';

void main() {
  runApp(JapaneseVocabularyApp());
}

class JapaneseVocabularyApp extends StatelessWidget {
  JapaneseVocabularyApp({Key? key}) : super(key: key);

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WordRepository>(
          create: (context) => WordRepository(
            box: AppDatabase.getBox<Word>(),
          ),
        ),
        RepositoryProvider<ReviewRepository>(
          create: (context) => ReviewRepository(
            box: AppDatabase.getBox<Review>(),
          ),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepository(
            prefs: SharedPreferences.getInstance(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WordBloc(
              repository: RepositoryProvider.of<WordRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ReviewBloc(
              repository: RepositoryProvider.of<ReviewRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => SettingsBloc(
              repository: RepositoryProvider.of<SettingsRepository>(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Japanese Vocabulary',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              filled: true,
            ),
          ),
          routerDelegate: AutoRouterDelegate(_appRouter),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
