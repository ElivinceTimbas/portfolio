import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/portfolio.dart';
import '../presentation/pages/portfolio_page.dart';

GoRouter createPortfolioRouter({
  required Portfolio portfolio,
  required void Function(BuildContext) onToggleTheme,
}) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => PortfolioPage(
          portfolio: portfolio,
          onToggleTheme: () => onToggleTheme(context),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'This page could not be found.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Back to portfolio'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
