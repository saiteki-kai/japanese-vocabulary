import '../../objectbox.g.dart';
import '../app_database.dart';
import '../models/review.dart';

class ReviewRepository {
  /// A database instance.
  Future<Store> get _store async => await AppDatabase.instance.store;

  /// Returns all reviews
  Future<List<Review>> getAllReviews() async {
    final store = await _store;

    return store.box<Review>().getAll();
  }

  /// Returns the reviews to be reviewed.
  ///
  /// These reviews contain those with a [DateTime] less than or equal
  /// to [DateTime.now] and those with a [DateTime] null.
  Future<List<Review>> getTodayReviews() async {
    final store = await _store;

    final now = DateTime.now().millisecondsSinceEpoch;

    return store
        .box<Review>()
        .query(Review_.nextDate.lessOrEqual(now).or(Review_.nextDate.isNull()))
        .build()
        .find();
  }

  /// Updates the [review] in the database.
  ///
  /// Returns the [Review.id] of the [review].
  Future<int> updateReview(Review review) async {
    final store = await _store;

    return store.box<Review>().put(review);
  }
}
