import '../../objectbox.g.dart';
import '../models/review.dart';

class ReviewRepository {
  const ReviewRepository({required Future<Box<Review>> box}) : _box = box;

  // A database instance.
  final Future<Box<Review>> _box;

  /// Returns all reviews.
  Future<List<Review>> getReviews() async {
    final box = await _box;

    return box.getAll();
  }

  /// Returns the reviews to be reviewed.
  ///
  /// These reviews contain those with a [DateTime] less than or equal
  /// to [DateTime.now] and those with a [DateTime] null.
  Future<List<Review>> getTodayReviews() async {
    final box = await _box;

    final now = DateTime.now().millisecondsSinceEpoch;

    return box
        .query(Review_.nextDate.lessOrEqual(now).or(Review_.nextDate.isNull()))
        .build()
        .find();
  }

  /// Updates the [review] in the database.
  ///
  /// Returns the [Review.id] of the [review].
  Future<int> updateReview(Review review) async {
    final box = await _box;

    return box.put(review);
  }
}
