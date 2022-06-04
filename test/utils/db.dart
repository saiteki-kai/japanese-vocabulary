import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';

Word addWordExpectedIds(Word word, int id, int meaningId, int readingId) {
  word.id = id;

  final meaning = word.meaningReview;
  final reading = word.readingReview;

  meaning.target ??= Review(type: 'meaning', nextDate: DateTime.now());
  meaning.target?.id = meaningId;

  reading.target ??= Review(type: 'reading', nextDate: DateTime.now());
  reading.target?.id = readingId;

  return word;
}

Review addReviewExpectedIds(Review review, int id, int? wordId) {
  review.id = id;

  if (wordId != null) {
    review.word.target?.id = wordId;
  }

  return review;
}
