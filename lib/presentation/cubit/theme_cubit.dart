import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/theme_preference.dart';
import '../../domain/repositories/theme_preferences_repository.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.preference, this.saveFailed = false});

  final ThemePreference preference;
  final bool saveFailed;

  @override
  List<Object> get props => [preference, saveFailed];
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(
    this._repository, {
    ThemePreference initialPreference = ThemePreference.system,
  }) : super(ThemeState(preference: initialPreference));

  final ThemePreferencesRepository _repository;
  Future<void> _pendingWrite = Future<void>.value();
  int _revision = 0;

  void toggle({required bool currentlyDark}) {
    final isDark = switch (state.preference) {
      ThemePreference.system => currentlyDark,
      ThemePreference.light => false,
      ThemePreference.dark => true,
    };
    setPreference(isDark ? ThemePreference.light : ThemePreference.dark);
  }

  Future<void> setPreference(ThemePreference preference) {
    if (isClosed) return Future<void>.value();
    final revision = ++_revision;
    emit(ThemeState(preference: preference));
    _pendingWrite = _pendingWrite.then((_) async {
      try {
        await _repository.save(preference);
      } catch (_) {
        if (!isClosed && revision == _revision) {
          emit(ThemeState(preference: preference, saveFailed: true));
        }
      }
    });
    return _pendingWrite;
  }
}
