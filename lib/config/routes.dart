import 'package:auto_route/auto_route.dart';

import '../ui/screens/word_details_screen/word_details_screen.dart';
import '../ui/screens/home_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: HomeScreen),
    AutoRoute(path: '/words/:id', page: WordDetailsScreen),
  ],
)
class $AppRouter {}
