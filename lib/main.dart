import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'data/repositories/bundled_portfolio_repository.dart';
import 'data/repositories/shared_theme_preferences_repository.dart';
import 'domain/entities/theme_preference.dart';
import 'domain/repositories/portfolio_repository.dart';
import 'domain/repositories/theme_preferences_repository.dart';
import 'presentation/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    for (final family in ['SpaceGrotesk', 'Inter', 'JetBrainsMono']) {
      final license = await rootBundle.loadString(
        'assets/fonts/$family-OFL.txt',
      );
      yield LicenseEntryWithLineBreaks([family], license);
    }
  });

  final dependencies = GetIt.instance;
  dependencies.registerSingleton<PortfolioRepository>(
    const BundledPortfolioRepository(),
  );
  final themePreferences = SharedThemePreferencesRepository(
    SharedPreferencesAsync(),
  );
  dependencies.registerSingleton<ThemePreferencesRepository>(themePreferences);

  var initialPreference = ThemePreference.system;
  try {
    initialPreference = await themePreferences.read();
  } catch (_) {
    // Storage can be unavailable in private browsing; keep system appearance.
  }
  dependencies.registerFactory<ThemeCubit>(
    () => ThemeCubit(
      dependencies<ThemePreferencesRepository>(),
      initialPreference: initialPreference,
    ),
  );

  runApp(
    App(
      portfolio: dependencies<PortfolioRepository>().getPortfolio(),
      themeCubit: dependencies<ThemeCubit>(),
    ),
  );
}
