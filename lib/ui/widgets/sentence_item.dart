import 'package:flutter/widgets.dart';

class SentenceItem extends StatelessWidget {
  const SentenceItem({Key? key, required this.text, required this.translation})
      : super(key: key);

  final Widget text;
  final Widget translation;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: [
        Flexible(
          child: text,
        ),
        Flexible(
          child: translation,
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
