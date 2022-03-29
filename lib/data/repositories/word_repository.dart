import '../../objectbox.g.dart';
import '../app_database.dart';

class WordRepository {
  Future<Store> get _store async => await AppDatabase.instance.store;
}
