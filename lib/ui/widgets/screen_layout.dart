import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  final Widget? appBar;
  final Widget child;
  const ScreenLayout({Key? key, this.appBar, required this.child})
      : super(key: key);

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
