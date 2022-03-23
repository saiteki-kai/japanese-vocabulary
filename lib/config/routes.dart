import 'package:auto_route/auto_route.dart';

import '../ui/screens/home_screen.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: HomeScreen),
  ],
)
class $AppRouter {}
