import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';

class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase _instance = AppDatabase._internal();

  /// Singleton
  static AppDatabase get instance => _instance;

  Completer<Store>? _completer;

  /// A database instance.
  /// The connection opens lazily when this property is accessed for the first time.
  Future<Store> get store async {
    if (_completer == null) {
      _completer = Completer();
      _openDatabase();
    }

    return _completer!.future;
  }

  Future<String> get _dbPath async {
    // Gets the application documents directory
    final dir = await getApplicationDocumentsDirectory();
    final dbDir = Directory(join(dir.path, "databases"));

    // Creates if not exists
    await dbDir.create(recursive: true);

    // Returns the database path
    return dbDir.path;
  }

  void _openDatabase() async {
    try {
      // Opens the database
      final store = await openStore(directory: await _dbPath);
      _completer!.complete(store);
    } catch (e) {
      _completer!.completeError(e);
    }
  }

  /// Deletes the database if exists.
  Future<void> deleteDatabase() async {
    final dir = Directory(await _dbPath);

    if (dir.existsSync()) {
      await dir.delete(recursive: true);
    }

    _completer = null;
  }

  static Future<Box<T>> getBox<T>() async {
    final store = await instance.store;

    return store.box<T>();
  }
}
