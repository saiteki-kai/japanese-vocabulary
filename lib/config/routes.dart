import 'package:auto_route/auto_route.dart';

import '../ui/screens/home_screen.dart';
import '../ui/widgets/insert_word_widget.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: HomeScreen),
  ],
)
class $AppRouter {}
