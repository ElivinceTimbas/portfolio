import '../entities/theme_preference.dart';

abstract interface class ThemePreferencesRepository {
  Future<ThemePreference> read();

  Future<void> save(ThemePreference preference);
}
