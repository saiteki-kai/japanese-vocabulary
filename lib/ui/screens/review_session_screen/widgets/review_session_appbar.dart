import 'package:flutter/material.dart';

/// Appbar of the [ReviewSession] screen.
class ReviewSessionAppBar extends StatelessWidget {
  /// Creates a custom appbar
  const ReviewSessionAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 2 + 32.0,
      child: AppBar(
        title: const Text("Reviews"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: go to summary page
            },
            icon: const Icon(Icons.pie_chart),
            tooltip: "Summary",
          ),
        ],
      ),
    );
  }
}
