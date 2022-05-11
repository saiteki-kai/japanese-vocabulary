import 'package:flutter/material.dart';

/// A widget that displays an [appBar] and a [child] inside a container
/// with rounded top edges.
class ScreenLayout extends StatelessWidget {
  /// Creates a widget with an [appBar] and a [child].
  const ScreenLayout({
    Key? key,
    this.appBar,
    this.padding = const EdgeInsets.all(8.0),
    required this.child,
  }) : super(key: key);

  /// An app bar to display at the top of the screen layout.
  ///
  /// If null, only the [child] will be displayed.
  final Widget? appBar;

  /// The padding of the [child].
  final EdgeInsets? padding;

  /// The [child] contained by the screen layout.
  ///
  /// The [child] is expanded to vertically fill the screen layout.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          appBar ?? const SizedBox(),
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: padding,
              decoration: BoxDecoration(
                color: theme.canvasColor,
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
