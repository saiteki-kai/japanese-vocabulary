import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../utils/hint.dart';

class ReviewMeaningHint extends StatefulWidget {
  ReviewMeaningHint({
    Key? key,
    required this.hint,
  })  : assert(hint.currSentences.isNotEmpty),
        super(key: key);

  final MeaningHint hint;

  @override
  State<ReviewMeaningHint> createState() => _ReviewMeaningHintState();
}

class _ReviewMeaningHintState extends State<ReviewMeaningHint> {
  final ValueNotifier<int> page = ValueNotifier(0);

  PageController? _controller;

  int get _length => widget.hint.currSentences.length;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.hint.n - 1);
    page.value = widget.hint.n - 1;
  }

  @override
  void didUpdateWidget(covariant ReviewMeaningHint oldWidget) {
    if (widget.hint != oldWidget.hint && _controller != null) {
      _controller?.jumpToPage(widget.hint.n - 1);
      page.value = widget.hint.n - 1;
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
              onPageChanged: (i) {
                page.value = i;
              },
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
}
