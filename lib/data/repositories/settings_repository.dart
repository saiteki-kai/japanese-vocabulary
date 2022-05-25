import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class SettingsRepository {
  const SettingsRepository({required this.prefs});

  final Future<SharedPreferences> prefs;

  Future<Settings?> getSettings() async {
    final json = (await prefs).getString("settings");

    if (json != null) {
      return Settings.fromJson(json);
    }

    return null;
  }

  Future setSettings(Settings settings) async {
    (await prefs).setString("settings", settings.toJson());
  }
}
