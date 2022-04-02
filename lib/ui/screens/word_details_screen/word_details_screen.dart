import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../data/models/word.dart';
import '../../../utils/colors.dart';
import 'widgets/word_details_tab.dart';
import './widgets/word_stats_tab.dart';
import '../../widgets/screen_layout.dart';

class WordDetailsScreen extends StatefulWidget {
  final Word word;

  const WordDetailsScreen({Key? key, required this.word})
      : super(key: key);

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(vsync: this, length: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
        appBar: SizedBox(
          height: kToolbarHeight * 2,
          child: AppBar(
            elevation: 0,
            title: Text(widget.word.text),
            actions: [
              IconButton(onPressed: () => {}, icon: const Icon(Icons.edit)),
              IconButton(onPressed: () => {}, icon: const Icon(Icons.delete)),
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
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            WordDetailsTab(word: widget.word),
            WordStatisticsTab(word: widget.word),
          ],
        ),
      ),
    );
  }
}
