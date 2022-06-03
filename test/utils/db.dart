import 'package:japanese_vocabulary/data/models/review.dart';
import 'package:japanese_vocabulary/data/models/word.dart';

Word addWordExpectedIds(Word w, int id, int meaningId, int readingId) {
  final word = w;
  word.id = id;
  word.meaningReview.targetId = meaningId;
  word.readingReview.targetId = readingId;

  return word;
}

Review addReviewExpectedIds(Review r, int id, int? wordId) {
  final review = r;
  review.id = id;
  if (wordId != null) {
    review.word.targetId = wordId;
  }

  return review;
}
