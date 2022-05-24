import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/sentence.dart';
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

Word get wordWith3Sentences {
  final word =  Word(
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