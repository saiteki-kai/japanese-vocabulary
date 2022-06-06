import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/sentence.dart';
import 'package:japanese_vocabulary/data/models/settings.dart';
import 'package:japanese_vocabulary/data/models/sort_option.dart';
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

Word get word6 {
  return Word(
    text: "Mucho gracias",
    reading: "moo chow  gra see uhs",
    jlpt: 2,
    meaning: "thanks very much",
    pos: "n",
  );
}

Word get wordSentences {
  final word = Word(
    text: "普通",
    reading: "ふつう",
    jlpt: 4,
    meaning: "normal; ordinary; regular",
    pos: "n,adj-na",
  );
  word.sentences.add(Sentence(text: "text1", translation: "translation1"));
  word.sentences.add(Sentence(text: "text2", translation: "translation2"));
  return word;
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
  text: "Barbara",
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
  text: "Cane",
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
  text: "Anice",
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
  final review = Review(nextDate: date, type: type);

  if (word != null) {
    review.word.target = word;
  }

  return review;
}

Review get nullDateReview => createReviewByDate(null);
Review get nowReview => createReviewByDate(DateTime.now());
Review get review0 => createReviewByDate(DateTime(DateTime.now().year - 2));
Review get review1 => createReviewByDate(DateTime(DateTime.now().year - 1));
Review get review2 => createReviewByDate(DateTime(DateTime.now().year + 1));

final sentence1 = Sentence(
    text: '言葉と行動は一致すべきものだが、実行は難しい。',
    translation:
        'Your words are supposed to correspond to your actions, but that is not easy to put into practice.');
final sentence2 = Sentence(
    text: '彼女は図書館の利用許可を与えられた。',
    translation: 'She was accorded permission to use the library.');
final sentence3 = Sentence(
    text: '麺はふつう小麦粉から作られる。',
    translation: 'Noodles are usually made from wheat.');

Review get readingReviewWithWord {
  return createReviewByDate(
    null,
    type: "reading",
    word: word2,
  );
}

Review get meaningReviewWithWord {
  final Word word = word1;
  word.sentences.addAll([sentence1, sentence2, sentence3]);
  return createReviewByDate(
    null,
    type: "meaning",
    word: word,
  );
}

final expectedSorting = {
  SortField.date: [
    wordsWithReview1,
    wordsWithReview3,
    wordsWithReview2,
  ],
  SortField.streak: [
    wordsWithReview2,
    wordsWithReview1,
    wordsWithReview3,
  ],
  SortField.accuracy: [
    wordsWithReview1,
    wordsWithReview3,
    wordsWithReview2,
  ],
  SortField.text: [
    wordsWithReview3,
    wordsWithReview1,
    wordsWithReview2,
  ],
};

Settings get settings1 {
  return const Settings(
    sortOption: SortOption(descending: true, field: SortField.accuracy),
  );
}

SortOption get sortOption1 {
  return const SortOption(descending: false, field: SortField.streak);
}

Word get wordWith3Sentences {
  final word = Word(
    text: "言葉",
    reading: "ことば",
    jlpt: 5,
    meaning: "word; phrase; expression; term",
    pos: "Noun",
  );
  word.sentences.addAll([sentence1, sentence2, sentence3]);
  return word;
}

Word get wordWithoutSentences {
  return Word(
    text: "復習",
    reading: "ふくしゅう",
    jlpt: 4,
    meaning: "review (of learned material); revision",
    pos: "Noun, Suru verb",
  );
}

Word get wordReading1Char {
  return Word(
    text: "",
    reading: "あ",
    jlpt: 0,
    meaning: "",
    pos: "",
  );
}

Word get wordReading2Char {
  return Word(
    text: "",
    reading: "うん",
    jlpt: 0,
    meaning: "",
    pos: "",
  );
}

Word get wordReading4Char {
  return Word(
    text: "",
    reading: "たとえば",
    jlpt: 0,
    meaning: "",
    pos: "",
  );
}

Word get wordReading7Char {
  return Word(
    text: "",
    reading: "ユニットテスト",
    jlpt: 0,
    meaning: "",
    pos: "",
  );
}
