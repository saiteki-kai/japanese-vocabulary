import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/routes.gr.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AutoTabsScaffold(
        routes: const [
          ReviewScreen(),
          WordsScreen(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(
                label: 'Reviews',
                icon: Icon(Icons.replay),
              ),
              BottomNavigationBarItem(
                label: 'Words',
                icon: Icon(Icons.list),
              ),
            ],
          );
        },
      ),
    );
  }
}
