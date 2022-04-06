import '../../objectbox.g.dart';
import '../app_database.dart';
import '../models/word.dart';

class WordRepository {
  Future<Store> get _store async => await AppDatabase.instance.store;

  Future<List<Word>> getWords() async {
    final box = (await _store).box<Word>();
    return box.getAll();
  }
}
