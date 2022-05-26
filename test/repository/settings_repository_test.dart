import 'package:flutter_test/flutter_test.dart';
import 'package:japanese_vocabulary/data/models/settings.dart';
import 'package:japanese_vocabulary/data/models/sort_option.dart';
import 'package:japanese_vocabulary/data/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  late SettingsRepository repo;

  setUpEmpty() {
    SharedPreferences.setMockInitialValues({});
    repo = SettingsRepository(prefs: SharedPreferences.getInstance());
  }

  setUpWithSettings(Settings settings) {
    SharedPreferences.setMockInitialValues({"settings": settings.toJson()});
    repo = SettingsRepository(prefs: SharedPreferences.getInstance());
  }

  test("get settings when already present", () async {
    setUpWithSettings(const Settings.initial());

    final settings = await repo.getSettings();
    expect(settings, equals(const Settings.initial()));
  });

  test("get settings when empty", () async {
    setUpEmpty();

    final settings = await repo.getSettings();
    expect(settings, isNull);
  });

  test("update settings", () async {
    setUpWithSettings(
      const Settings(sortOption: SortOption(field: SortField.date)),
    );

    final res = await repo.setSettings(
      const Settings(sortOption: SortOption(field: SortField.date)),
    );

    expect(res, equals(true));
  });
}
