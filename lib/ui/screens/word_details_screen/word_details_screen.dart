import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../bloc/word_bloc.dart';
import '../../../data/models/word.dart';
import '../../../utils/colors.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/word_details_tab.dart';
import './widgets/word_stats_tab.dart';
import '../../widgets/screen_layout.dart';

/// A widget that displays the details and the statistics of a [Word] from the associated reviews.
///
/// A [TabBar] is used, where the word details are displayed in a [WordDetailsTab] and
/// the statistics associated with the word associated reviews are displayed in a [WordStatisticsTab].
class WordDetailsScreen extends StatefulWidget {
  /// Creates a word details widget.
  ///
  /// The [wordId] parameter is required and must not be null.
  const WordDetailsScreen({Key? key, required this.wordId}) : super(key: key);

  /// The [wordId] from which details and statistics will be displayed, must not be null.
  final int wordId;

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(vsync: this, length: 2);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: BlocBuilder<WordBloc, WordState>(
        bloc: BlocProvider.of(context)
          ..add(GetWordEvent(wordId: widget.wordId)),
        builder: (context, state) {
          if (state is WordLoaded) {
            final word = state.word;
            return Scaffold(
              body: ScreenLayout(
                appBar: SizedBox(
                  height: kToolbarHeight * 2,
                  child: AppBar(
                    elevation: 0,
                    title: Text(word.text),
                    actions: [
                      IconButton(
                          onPressed: () => {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () => {}, icon: const Icon(Icons.delete)),
                    ],
                    bottom: TabBar(
                      controller: _tabController,
                      indicator: MaterialIndicator(
                        height: 5,
                        topLeftRadius: 8,
                        topRightRadius: 8,
                        horizontalPadding: 50,
                        color: CustomColors.tabSelectionColor(),
                        tabPosition: TabPosition.bottom,
                      ),
                      tabs: const [
                        Tab(text: "Details"),
                        Tab(text: "Statistics"),
                      ],
                    ),
                  ),
                ),
                padding: EdgeInsets.zero,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    WordDetailsTab(word: word),
                    WordStatisticsTab(word: word),
                  ],
                ),
              ),
            );
          } else if (state is WordError) {
            return Text(state.message);
          } else {
            return const LoadingIndicator(message: "Loading...");
          }
        },
      ),
    );
  }

  Future<bool> _onBack() {
    _bloc?.add(WordRetrieved());

    return Future.value(true);
  }
}
