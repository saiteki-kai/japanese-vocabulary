import 'package:flutter/material.dart';

import '../../data/models/sentence.dart';

void showSentenceDialog(
  BuildContext context,
  String title,
  TextEditingController sentenceTextController,
  TextEditingController sentenceTranslationController,
  VoidCallback callback, {
  Sentence? sentence,
}) {
  showDialog(
    context: context,
    builder: (_) => SimpleDialog(
      title: Text(title),
      key: const Key("sentence-dialog"),
      children: [
        SizedBox(
          width: 300.0,
          child: TextField(
            key: const Key("sentence-text-d"),
            decoration: const InputDecoration(
              hintText: "Sentence",
            ),
            controller: sentenceTextController,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextField(
          key: const Key("sentence-translation-d"),
          decoration: const InputDecoration(
            hintText: "Translation",
          ),
          controller: sentenceTranslationController,
        ),
        IconButton(
          key: const Key("sentence-button-d"),
          onPressed: callback,
          icon: const Icon(Icons.add, color: Colors.black),
        ),
      ],
    ),
  );
  sentenceTextController.text = sentence?.text ?? "";
  sentenceTranslationController.text = sentence?.translation ?? "";
}
