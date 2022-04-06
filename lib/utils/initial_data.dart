import '../data/models/review.dart';
import '../data/models/word.dart';

initializeDB(store) {
  createWord(text, meaning, reading) {
    final mRev = Review(
      id: 0,
      ef: 2.5,
      correctAnswers: 0,
      incorrectAnswers: 0,
      interval: 0,
      nextDate: null,
      repetition: 0,
      type: "meaning",
    );
    final rRev = Review(
      id: 0,
      ef: 2.5,
      correctAnswers: 0,
      incorrectAnswers: 0,
      interval: 0,
      nextDate: null,
      repetition: 0,
      type: "reading",
    );

    final word = Word(
      id: 0,
      jlpt: 5,
      text: text,
      meaning: meaning,
      reading: reading,
      pos: "",
    );

    word.meaningReview.target = mRev;
    word.readingReview.target = rRev;

    mRev.word.target = word;
    rRev.word.target = word;

    return store.box<Word>().put(word);
  }

  store.box<Word>().removeAll();
  store.box<Review>().removeAll();

  createWord("言葉", "word; phrase; expression; term", "ことば");
  createWord("復習", "review (of learned material); revision", "ふくしゅう");
  createWord("普通", "normal; ordinary; regular", " ふつう");
  createWord("学習", "study; learning; tutorial", "がくしゅう");
  createWord("利用", "use; utilization; application", "りよう");
}
