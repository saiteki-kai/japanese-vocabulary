import 'package:flutter/material.dart';
import '../../../../data/models/word.dart';
import '../../word_details_screen/widgets/title_subtitle_widget.dart';

class WordDetailsTab extends StatelessWidget {
  final Word word;
  const WordDetailsTab({Key? key, required this.word}) : super(key: key);

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
                          child: Text(word.text, style: const TextStyle(fontSize: 24.0))),
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
