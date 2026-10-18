import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app/app.dart';
import 'package:portfolio/data/portfolio_content.dart';
import 'package:portfolio/domain/entities/theme_preference.dart';
import 'package:portfolio/domain/repositories/theme_preferences_repository.dart';
import 'package:portfolio/presentation/cubit/theme_cubit.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  for (final width in [375.0, 768.0, 1440.0]) {
    testWidgets('Portfolio renders and navigates at width $width', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 900);
      tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      final visibilityInterval =
          VisibilityDetectorController.instance.updateInterval;
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue();
        VisibilityDetectorController.instance.updateInterval =
            visibilityInterval;
      });
      final repository = MemoryThemePreferences();
      final cubit = ThemeCubit(
        repository,
        initialPreference: ThemePreference.light,
      );
      await tester.pumpWidget(
        App(portfolio: portfolioContent, themeCubit: cubit),
      );
      await tester.pumpAndSettle();

      expect(find.text('Elivince M. Timbas'), findsOneWidget);
      expect(find.text('01 / ABOUT'), findsOneWidget);
      expect(find.text('Lifesaver for Family'), findsOneWidget);
      expect(find.text('Lifesaver for Doctors'), findsOneWidget);
      expect(find.text('Food-Tripid'), findsOneWidget);
      expect(find.text('View CV'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byTooltip('Switch to dark theme').first);
      await tester.pumpAndSettle();
      expect(cubit.state.preference, ThemePreference.dark);
      expect(repository.saved, [ThemePreference.dark]);
      expect(find.byTooltip('Switch to light theme'), findsOneWidget);

      if (width < 600) {
        await tester.tap(find.byTooltip('Open navigation menu'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Close navigation menu'), findsOneWidget);
        await tester.tap(find.text('Work').last);
      } else {
        await tester.tap(find.text('Work').first);
      }
      await tester.pumpAndSettle();
      expect(find.byTooltip('Close navigation menu'), findsNothing);
      expect(tester.takeException(), isNull);
      final workHeading = find.text('04 / SELECTED WORK');
      expect(tester.getTopLeft(workHeading).dy, greaterThanOrEqualTo(0));
      expect(tester.getTopLeft(workHeading).dy, lessThan(900));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }

  test('Rapid theme changes persist in order', () async {
    final firstWrite = Completer<void>();
    final repository = MemoryThemePreferences(firstWrite: firstWrite);
    final cubit = ThemeCubit(repository);
    final first = cubit.setPreference(ThemePreference.dark);
    final last = cubit.setPreference(ThemePreference.light);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.preference, ThemePreference.light);
    expect(repository.saved, [ThemePreference.dark]);
    firstWrite.complete();
    await Future.wait([first, last]);
    expect(repository.saved, [ThemePreference.dark, ThemePreference.light]);
    await cubit.close();
  });

  test(
    'Storage failure retains session choice and later saves recover',
    () async {
      final repository = MemoryThemePreferences()..failNextSave = true;
      final cubit = ThemeCubit(repository);
      await cubit.setPreference(ThemePreference.dark);
      expect(cubit.state.preference, ThemePreference.dark);
      expect(cubit.state.saveFailed, isTrue);
      await cubit.setPreference(ThemePreference.light);
      expect(cubit.state.preference, ThemePreference.light);
      expect(cubit.state.saveFailed, isFalse);
      expect(repository.saved, [ThemePreference.dark, ThemePreference.light]);
      await cubit.close();
    },
  );
}

class MemoryThemePreferences implements ThemePreferencesRepository {
  MemoryThemePreferences({this.firstWrite});

  final Completer<void>? firstWrite;
  final saved = <ThemePreference>[];
  bool failNextSave = false;

  @override
  Future<ThemePreference> read() async => ThemePreference.system;

  @override
  Future<void> save(ThemePreference preference) async {
    saved.add(preference);
    if (saved.length == 1 && firstWrite != null) await firstWrite!.future;
    if (failNextSave) {
      failNextSave = false;
      throw StateError('Storage unavailable');
    }
  }
}
