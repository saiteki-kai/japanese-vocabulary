import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

class SettingsRepository {
  const SettingsRepository({required this.prefs});

  /// A [SharedPreferences] instance.
  final Future<SharedPreferences> prefs;

  /// Returns the settings saved in the preferences if present, otherwise null.
  Future<Settings?> getSettings() async {
    final json = (await prefs).getString("settings");

    if (json != null) {
      return Settings.fromJson(json);
    }

    return null;
  }

  /// Updates the [settings] in the preferences.
  Future<bool> setSettings(Settings settings) async {
    return (await prefs).setString("settings", settings.toJson());
  }
}
