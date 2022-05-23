import 'package:flutter/material.dart';

Widget floatingActionButton({bool show = false, VoidCallback? onPressed}) {
  if (show) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber,
        onPressed: onPressed,
      ),
    );
  }

  return const SizedBox();
}
