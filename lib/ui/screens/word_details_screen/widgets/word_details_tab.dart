import 'package:flutter/material.dart';
import '../../../../data/models/word.dart';
import '../../word_details_screen/widgets/title_subtitle_widget.dart';

/// A widget that displays the details of a [Word].
///
/// The details are the word text, meaning, reading, part of speech and the jlpt level.
class WordDetailsTab extends StatelessWidget {
  /// Creates a word details tab widget.
  ///
  /// The [word] parameter is required and must not be null.
  const WordDetailsTab({Key? key, required this.word}) : super(key: key);

  /// The [word] from which details will be displayed, must not be null.
  final Word word;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          word.text,
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ),
                      Text("N${word.jlpt}"),
                    ],
                  ),
                  TitleSubtitleWidget(
                    title: "Reading",
                    titleTextStyle: TextStyle(
                        color: Colors.deepOrange[600],
                        fontWeight: FontWeight.w300),
                    subtitle: word.reading,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  TitleSubtitleWidget(
                    title: "Meaning",
                    titleTextStyle: TextStyle(
                        color: Colors.deepOrange[600],
                        fontWeight: FontWeight.w300),
                    subtitle: word.meaning,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  TitleSubtitleWidget(
                    title: "Part of speech",
                    titleTextStyle: TextStyle(
                        color: Colors.deepOrange[600],
                        fontWeight: FontWeight.w300),
                    subtitle: word.pos,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}