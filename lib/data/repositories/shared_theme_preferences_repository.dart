import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/theme_preference.dart';
import '../../domain/repositories/theme_preferences_repository.dart';

class SharedThemePreferencesRepository implements ThemePreferencesRepository {
  SharedThemePreferencesRepository(this._preferences);

  final SharedPreferencesAsync _preferences;
  static const _key = 'portfolio.theme';

  @override
  Future<ThemePreference> read() async {
    final value = await _preferences.getString(_key);
    return switch (value) {
      'light' => ThemePreference.light,
      'dark' => ThemePreference.dark,
      _ => ThemePreference.system,
    };
  }

  @override
  Future<void> save(ThemePreference preference) {
    return _preferences.setString(_key, preference.name);
  }
}
