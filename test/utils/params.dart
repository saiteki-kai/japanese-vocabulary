import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';

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

Word get word1 {
  return Word(
    text: "言葉",
    reading: "ことば",
    jlpt: 5,
    meaning: "word; phrase; expression; term",
    pos: "Noun",
  );
}

Word get word2 {
  return Word(
    text: "復習",
    reading: "ふくしゅう",
    jlpt: 4,
    meaning: "review (of learned material); revision",
    pos: "Noun, Suru verb",
  );
}

Word get word3 {
  return Word(
    text: "普通",
    reading: "ふつう",
    jlpt: 4,
    meaning: "normal; ordinary; regular",
    pos: "Noun, Na-adjective",
  );
}

Word get word4 {
  return Word(
    text: "普通",
    reading: "ふつう",
    jlpt: 4,
    meaning: "normal; ordinary; regular",
    pos: "n,adj-na",
  );
}

Word get word5 {
  return Word(
    text: "gracias",
    reading: "gra see uhs",
    jlpt: 2,
    meaning: "thanks",
    pos: "n",
  );
}

Word createWordWithReview({
  String text = "",
  int jlpt = 0,
  int streak1 = 0,
  int streak2 = 0,
  int correctAnswers1 = 0,
  int correctAnswers2 = 0,
  int incorrectAnswers1 = 0,
  int incorrectAnswers2 = 0,
  DateTime? nextDate1,
  DateTime? nextDate2,
}) {
  final review1 = Review(
    correctAnswers: correctAnswers1,
    incorrectAnswers: incorrectAnswers1,
    ef: 2.5,
    interval: 0,
    repetition: streak1,
    type: "meaning",
    nextDate: nextDate1,
  );
  final review2 = Review(
    correctAnswers: correctAnswers2,
    incorrectAnswers: incorrectAnswers2,
    ef: 2.5,
    interval: 0,
    repetition: streak2,
    type: "meaning",
    nextDate: nextDate2,
  );

  final word = Word(
    jlpt: jlpt,
    meaning: "",
    pos: "",
    reading: "",
    text: text,
  );
  word.readingReview.target = review1;
  word.meaningReview.target = review2;

  return word;
}

// mean accuracy: 0,58
// max streak 4
final wordsWithReview1 = createWordWithReview(
  text: "B",
  nextDate1: DateTime(2022),
  nextDate2: null,
  streak1: 0,
  streak2: 4,
  correctAnswers1: 2,
  incorrectAnswers1: 1,
  correctAnswers2: 3,
  incorrectAnswers2: 3,
);

// mean accuracy: 0,83
// max streak 3
final wordsWithReview2 = createWordWithReview(
  text: "C",
  nextDate1: null,
  nextDate2: null,
  streak1: 3,
  streak2: 2,
  correctAnswers1: 1,
  incorrectAnswers1: 0,
  correctAnswers2: 2,
  incorrectAnswers2: 1,
);

// mean accuracy: 0,66
// max streak 5
final wordsWithReview3 = createWordWithReview(
  text: "A",
  nextDate1: DateTime(2025),
  nextDate2: DateTime(2024),
  streak1: 5,
  streak2: 2,
  correctAnswers1: 4,
  incorrectAnswers1: 2,
  correctAnswers2: 2,
  incorrectAnswers2: 1,
);

final wordsWithOneReview = word1.copyWith()
  ..readingReview.target = Review(
    correctAnswers: 2,
    incorrectAnswers: 7,
    ef: 2.5,
    interval: 2,
    nextDate: null,
    repetition: 2,
    type: "",
  );

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
    word: word2,
  );
}

Review get meaningReviewWithWord {
  return createReviewByDate(
    null,
    type: "meaning",
    word: word1,
  );
}
