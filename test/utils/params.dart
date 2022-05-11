import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';

Review createReviewByDate(
  DateTime? date, {
  Word? word,
  String type = "meaning",
}) {
  final review = Review(
    ef: 2.5,
    interval: 0,
    repetition: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
    nextDate: date,
    type: type,
  );

  if (word != null) {
    review.word.target = word;
  }

  return review;
}

Review get nullDateReview => createReviewByDate(null);
Review get nowReview => createReviewByDate(DateTime.now());
Review get review1 => createReviewByDate(DateTime(DateTime.now().year - 1));
Review get review2 => createReviewByDate(DateTime(DateTime.now().year + 1));

Review get readingReviewWithWord {
  return createReviewByDate(
    null,
    type: "reading",
    word: Word(
      jlpt: 3,
      meaning: "word; phrase; expression; term",
      pos: "noun",
      reading: "ことば",
      text: "言葉",
      id: 0,
    ),
  );
}

Review get meaningReviewWithWord {
  return createReviewByDate(
    null,
    type: "meaning",
    word: Word(
      jlpt: 3,
      meaning: "word; phrase; expression; term",
      pos: "noun",
      reading: "ことば",
      text: "言葉",
      id: 0,
    ),
  );
}

Word get emptyWord {
  return Word(
    jlpt: 0,
    meaning: "",
    pos: "",
    reading: "",
    text: "",
  );
}

Word get invalidWord {
  return Word(
    text: "言葉",
    reading: "",
    jlpt: 5,
    meaning: "",
    pos: "Noun",
  );
}

List<Word> get exampleWords {
  return [
    Word(
      text: "言葉",
      reading: "ことば",
      jlpt: 5,
      meaning: "word; phrase; expression; term",
      pos: "Noun",
    ),
    Word(
      text: "復習",
      reading: "ふくしゅう",
      jlpt: 4,
      meaning: "review (of learned material); revision",
      pos: "Noun, Suru verb",
    ),
    Word(
      text: "普通",
      reading: "ふつう",
      jlpt: 4,
      meaning: "normal; ordinary; regular",
      pos: "Noun, Na-adjective",
    )
  ];
}
