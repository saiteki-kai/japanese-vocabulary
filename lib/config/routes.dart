import 'package:auto_route/auto_route.dart';

import '../../../ui/screens/home_screen.dart';
import '../../../ui/screens/review_screen/review_screen.dart';
import '../ui/screens/review_screen/widgets/review_session.dart';
import '../../../ui/screens/words_screen/words_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: HomeScreen,
      children: [
        AutoRoute(path: 'reviews', page: ReviewScreen),
        AutoRoute(path: 'words', page: WordsScreen),
      ],
    ),
    AutoRoute(path: "session", page: ReviewSession),
  ],
)
class $AppRouter {}
