import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

/// Appbar of the [ReviewSession] screen.
class ReviewSessionAppBar extends StatelessWidget {
  /// Creates a custom appbar
  const ReviewSessionAppBar({
    Key? key,
    required this.current,
    required this.total,
  }) : super(key: key);

  final int current;
  final int total;

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Column(
            children: [
              Text(
                "$current/$total",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              // ignore: avoid-wrapping-in-padding, the wrapped widget does not allow vertical padding
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: LinearPercentIndicator(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  lineHeight: 10.0,
                  percent: total == 0 ? 0 : current / total,
                  barRadius: const Radius.circular(8.0),
                  backgroundColor: Colors.black.withOpacity(0.1),
                  progressColor: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
