import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../utils/hint.dart';

/// A Widget that displays the list of sentences associated with the [hint] of type [MeaningHint].
///
/// The list is shown with a [PageView] and a [DotsIndicator] is used to move to previous hints.
class ReviewMeaningHint extends StatefulWidget {
  ReviewMeaningHint({
    Key? key,
    required this.hint,
  })  : assert(hint.currSentences.isNotEmpty),
        super(key: key);

  /// A [Hint] value.
  final MeaningHint hint;

  @override
  State<ReviewMeaningHint> createState() => _ReviewMeaningHintState();
}

class _ReviewMeaningHintState extends State<ReviewMeaningHint> {
  /// The current page value.
  final ValueNotifier<int> page = ValueNotifier(0);

  /// The page controller of the hints.
  PageController? _controller;

  /// The number of sentences of the [widget.hint].
  int get _length => widget.hint.currSentences.length;

  @override
  void initState() {
    super.initState();
    final nextPageIndex = widget.hint.n - 1;
    _controller = PageController(initialPage: nextPageIndex);
    page.value = nextPageIndex;
  }

  @override
  void didUpdateWidget(covariant ReviewMeaningHint oldWidget) {
    if (widget.hint != oldWidget.hint && _controller != null) {
      final n = widget.hint.n;
      _controller?.jumpToPage(n - 1);
      page.value = n - 1;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 80.0,
          child: Container(
            color: Colors.grey.shade200,
            child: PageView.builder(
              controller: _controller,
              itemCount: _length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    (_length > 0) ? widget.hint.currSentences[index].text : "",
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onPageChanged: _onPageChanged,
            ),
          ),
        ),
        if (_length > 0)
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: page,
                builder: (context, int value, child) {
                  return DotsIndicator(
                    dotsCount: _length,
                    position: value.toDouble(),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  /// Changes the current page.
  _onPageChanged(i) {
    page.value = i;
  }
}
