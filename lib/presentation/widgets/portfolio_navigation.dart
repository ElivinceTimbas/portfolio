import 'dart:ui';

import 'package:flutter/material.dart';

import 'portfolio_motion.dart';

const sectionNames = ['About', 'Skills', 'Experience', 'Work'];

class PortfolioNavigation extends StatelessWidget {
  const PortfolioNavigation({
    super.key,
    required this.handle,
    required this.activeSection,
    required this.scrolled,
    required this.onSection,
    required this.onToggleTheme,
    required this.onMenu,
  });
  final String handle;
  final String? activeSection;
  final bool scrolled;
  final ValueChanged<String> onSection;
  final VoidCallback onToggleTheme;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mobile = MediaQuery.sizeOf(context).width < 600;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: scrolled ? 12 : 0,
          sigmaY: scrolled ? 12 : 0,
        ),
        child: AnimatedContainer(
          duration: reduceMotion(context)
              ? Duration.zero
              : const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(
              alpha: scrolled ? .92 : 0,
            ),
            border: Border(
              bottom: BorderSide(
                color: scrolled
                    ? theme.colorScheme.outline
                    : Colors.transparent,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1216),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mobile ? 24 : 48,
                    vertical: mobile ? 8 : 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'Elivince Timbas home',
                        child: Text(
                          handle.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: mobile
                            ? const SizedBox.shrink()
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Wrap(
                                  alignment: WrapAlignment.end,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 2,
                                  children: [
                                    for (final name in sectionNames)
                                      UnderlineLink(
                                        label: name,
                                        active: activeSection == name,
                                        onPressed: () => onSection(name),
                                      ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(width: 4),
                      ThemeToggle(onPressed: onToggleTheme),
                      if (mobile)
                        IconButton(
                          tooltip: 'Open navigation menu',
                          onPressed: onMenu,
                          icon: const Icon(Icons.menu_rounded, size: 22),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: dark ? 'Switch to light theme' : 'Switch to dark theme',
      onPressed: onPressed,
      icon: Icon(
        dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        size: 19,
      ),
    );
  }
}

class UnderlineLink extends StatefulWidget {
  const UnderlineLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.active = false,
    this.accent = false,
  });
  final String label;
  final VoidCallback onPressed;
  final bool active;
  final bool accent;
  @override
  State<UnderlineLink> createState() => _UnderlineLinkState();
}

class _UnderlineLinkState extends State<UnderlineLink> {
  bool _hover = false;
  bool _focus = false;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final highlighted = widget.active || _hover || _focus;
    return TextButton(
      onPressed: widget.onPressed,
      onHover: (value) => setState(() => _hover = value),
      onFocusChange: (value) => setState(() => _focus = value),
      style: TextButton.styleFrom(
        foregroundColor: widget.accent ? scheme.primary : scheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: _focus ? BorderSide(color: scheme.primary) : BorderSide.none,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(widget.label),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedFractionallySizedBox(
              alignment: Alignment.centerLeft,
              duration: reduceMotion(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              widthFactor: highlighted || widget.accent ? 1 : 0,
              child: SizedBox(
                height: 1,
                child: ColoredBox(color: scheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileNavigation extends StatelessWidget {
  const MobileNavigation({
    super.key,
    required this.handle,
    required this.onSection,
    required this.onToggleTheme,
  });
  final String handle;
  final ValueChanged<String> onSection;
  final VoidCallback onToggleTheme;
  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    child: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      handle.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  ThemeToggle(onPressed: onToggleTheme),
                  IconButton(
                    autofocus: true,
                    tooltip: 'Close navigation menu',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              Text('EXPLORE', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 20),
              for (var i = 0; i < sectionNames.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSection(sectionNames[i]);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.centerLeft,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '0${i + 1}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            sectionNames[i],
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
