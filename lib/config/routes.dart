import 'package:auto_route/auto_route.dart';

import '../ui/screens/word_details_screen/word_details_screen.dart';
import '../ui/screens/home_screen.dart';
import '../../../ui/screens/home_screen.dart';
import '../../../ui/screens/review_screen/review_screen.dart';
import '../../../ui/screens/words_screen/words_screen.dart';
import '../ui/screens/review_session_screen/review_session_screen.dart';
import '../ui/screens/word_insert_screen/word_insert_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: HomeScreen,
      children: [
        AutoRoute(path: 'reviews', page: ReviewScreen),
        AutoRoute(path: 'words', page: WordScreen),
      ],
    ),
    AutoRoute(path: "session", page: ReviewSessionScreen),
    AutoRoute(path: '/insert', page: WordInsertScreen),
    AutoRoute(path: '/words/:id', page: WordDetailsScreen),
  ],
)
class $AppRouter {}
