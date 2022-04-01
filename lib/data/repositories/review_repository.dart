import '../../objectbox.g.dart';
import '../app_database.dart';
import '../models/review.dart';

class ReviewRepository {
  Future<Store> get _store async => await AppDatabase.instance.store;

  Future<List<Review>> getAllReviews() async {
    final store = await _store;
    return store.box<Review>().getAll();
  }

  Future<List<Review>> getTodayReviews() async {
    final store = await _store;

    final now = DateTime.now().millisecondsSinceEpoch;

    return store
        .box<Review>()
        .query(Review_.nextDate.lessOrEqual(now))
        .build()
        .find();
  }

  Future<int> updateReview(Review review) async {
    final store = await _store;

    return store.box<Review>().put(review);
  }
}
