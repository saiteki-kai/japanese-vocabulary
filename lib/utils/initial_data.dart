import '../data/models/review.dart';
import '../data/models/sentence.dart';
import '../data/models/word.dart';

initializeDB(store) {
  createWord(text, meaning, reading) {
    final mRev = Review(
      ef: 2.5,
      correctAnswers: 0,
      incorrectAnswers: 0,
      interval: 0,
      nextDate: null,
      repetition: 0,
      type: "meaning",
    );
    final rRev = Review(
      ef: 2.5,
      correctAnswers: 0,
      incorrectAnswers: 0,
      interval: 0,
      nextDate: null,
      repetition: 0,
      type: "reading",
    );

    final sentence1 = Sentence(
      text: '言葉と行動は一致すべきものだが、実行は難しい。',
      translation:
          'Your words are supposed to correspond to your actions, but that is not easy to put into practice.',
    );
    final sentence2 = Sentence(
      text: '彼女は図書館の利用許可を与えられた。',
      translation: 'She was accorded permission to use the library.',
    );
    final sentence3 = Sentence(
      text: '麺はふつう小麦粉から作られる。',
      translation: 'Noodles are usually made from wheat.',
    );

    final word = Word(
      id: 0,
      jlpt: 5,
      text: text,
      meaning: meaning,
      reading: reading,
      pos: "",
    );

    word.sentences.addAll(<Sentence>[sentence1, sentence2, sentence3]);

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
