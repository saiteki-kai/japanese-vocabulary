import 'package:flutter/material.dart';

/// A widget that displays an [appBar] and a [child] inside a container
/// with rounded top edges.
class ScreenLayout extends StatelessWidget {
  /// Creates a widget with an [appBar] and a [child].
  const ScreenLayout({
    Key? key,
    this.appBar,
    required this.child,
  }) : super(key: key);

  /// An app bar to display at the top of the screen layout.
  ///
  /// If null, only the [child] will be displayed.
  final Widget? appBar;

  /// The [child] contained by the screen layout.
  ///
  /// The [child] is expanded to vertically fill the screen layout.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (appBar != null) appBar!,
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
