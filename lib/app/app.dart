import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/portfolio.dart';
import '../domain/entities/theme_preference.dart';
import '../presentation/cubit/theme_cubit.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key, required this.portfolio, required this.themeCubit});

  final Portfolio portfolio;
  final ThemeCubit themeCubit;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createPortfolioRouter(
      portfolio: widget.portfolio,
      onToggleTheme: (context) => widget.themeCubit.toggle(
        currentlyDark: Theme.of(context).brightness == Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.themeCubit,
      child: BlocConsumer<ThemeCubit, ThemeState>(
        listenWhen: (previous, current) =>
            !previous.saveFailed && current.saveFailed,
        listener: (_, _) {
          _messengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text(
                'Theme changed for this visit. Your browser could not save it.',
              ),
            ),
          );
        },
        builder: (context, state) {
          final mediaQuery = MediaQuery.maybeOf(context);
          final accessibility =
              WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
          final reduceMotion =
              (mediaQuery?.disableAnimations ??
                  accessibility.disableAnimations) ||
              (mediaQuery?.accessibleNavigation ??
                  accessibility.accessibleNavigation);
          return MaterialApp.router(
            title: '${widget.portfolio.name} — Flutter Developer',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: _messengerKey,
            routerConfig: _router,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: switch (state.preference) {
              ThemePreference.system => ThemeMode.system,
              ThemePreference.light => ThemeMode.light,
              ThemePreference.dark => ThemeMode.dark,
            },
            themeAnimationDuration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 350),
            themeAnimationCurve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
