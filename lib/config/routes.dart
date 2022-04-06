import 'package:auto_route/auto_route.dart';

import '../ui/screens/home_screen.dart';
import '../ui/screens/word_insert_screens/word_insert_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: HomeScreen),
    AutoRoute(path: '/insert', page: WordInsertScreen),

  ],
)
class $AppRouter {}
