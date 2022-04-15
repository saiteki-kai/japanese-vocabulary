import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../utils/colors.dart';

class WordDetailsAppBar extends StatelessWidget {
  const WordDetailsAppBar({
    Key? key,
    required this.title,
    required this.tabController,
  }) : super(key: key);

  final String title;
  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 2,
      child: AppBar(
        elevation: 0,
        title: Text(title),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () => {}, icon: const Icon(Icons.delete)),
        ],
        bottom: TabBar(
          controller: tabController,
          indicator: MaterialIndicator(
            height: 5,
            topLeftRadius: 8,
            topRightRadius: 8,
            horizontalPadding: 50,
            color: CustomColors.tabSelectionColor,
            tabPosition: TabPosition.bottom,
          ),
          tabs: const [
            Tab(text: "Details"),
            Tab(text: "Statistics"),
          ],
        ),
      ),
    );
  }
}
