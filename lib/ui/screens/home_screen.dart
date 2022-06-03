import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/review_bloc.dart';
import '../../bloc/word_bloc.dart';
import '../../config/routes.gr.dart';
import '../../data/models/word.dart';
import '../widgets/floating_action_button.dart';

/// Widget for the basic definition of the [WordScreen].
///
/// This widget is called the [AppBar] and the [FloatingActionButton]
/// button to insert a new [Word] in the vocabulary.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        ReviewScreen(),
        WordScreen(),
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) => _onTap(context, index, tabsRouter),
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
          ),
          floatingActionButton: floatingActionButton(
            show: tabsRouter.activeIndex == 1,
            onPressed: () {
              AutoRouter.of(context).push(WordInsertScreen());
            },
          ),
        );
      },
    );
  }

  void _onTap(context, int index, tabsRouter) {
    if (index == 0) {
      BlocProvider.of<ReviewBloc>(context).add(ReviewSessionStarted());
    } else if (index == 1) {
      BlocProvider.of<WordBloc>(context).add(WordsRetrieved());
    }

    tabsRouter.setActiveIndex(index);
  }
}
