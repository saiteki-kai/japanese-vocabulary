import 'package:flutter/material.dart';

class SentenceItem extends StatelessWidget {
  const SentenceItem({
    Key? key,
    required this.text,
    required this.translation,
    required this.deleteCallback,
  }) : super(key: key);

  final Widget text;
  final Widget translation;
  final VoidCallback deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
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
        ),
        const Spacer(),
        IconButton(
          onPressed: deleteCallback,
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
