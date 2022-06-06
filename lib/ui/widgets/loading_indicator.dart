import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/// A widget that show a loading indicator.
///
/// A message can be displayed on the bottom of this component.
class LoadingIndicator extends StatelessWidget {
  /// Creates a widget that show a loading indicator.
  const LoadingIndicator({Key? key, this.message}) : super(key: key);

  /// The [message] displayed on the bottom of this.
  ///
  /// If the [message] is null only the loading indicator will be displayed.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 32.0,
          lineWidth: 8.0,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.transparent.withOpacity(0.2),
          percent: 1,
          animation: true,
          curve: Curves.ease,
          restartAnimation: true,
          animateFromLastPercent: true,
          animationDuration: 1000,
          progressColor: Colors.amber,
          // Theme.of(context).colorScheme.secondary,
          footer: _buildMessage(context),
        ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context) {
    if (message == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        message ?? "Loading...",
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
