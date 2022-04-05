import 'package:flutter/material.dart';

class ShowButton extends StatelessWidget {
  const ShowButton({Key? key, required this.show, required this.onToggleAnswer})
      : super(key: key);

  final bool show;
  final void Function()? onToggleAnswer;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
      child: Text((show ? "show" : "hide").toUpperCase()),
      onPressed: onToggleAnswer,
    );
  }
}
