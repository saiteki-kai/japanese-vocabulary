import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/word_bloc.dart';
import '../../config/routes.gr.dart';
import '../../data/models/word.dart';

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
          floatingActionButton: _floatingActionButton(
            show: tabsRouter.activeIndex == 1,
            onPressed: () {
              AutoRouter.of(context).push(const WordInsertScreen());
            },
          ),
        );
      },
    );
  }

  Widget _floatingActionButton({bool show = false, VoidCallback? onPressed}) {
    if (show) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: onPressed,
        ),
      );
    }

    return const SizedBox();
  }

  void _onTap(context, int index, tabsRouter) {
    if (index == 1) {
      BlocProvider.of<WordBloc>(context).add(WordsRetrieved());
    }
    tabsRouter.setActiveIndex(index);
  }
}
