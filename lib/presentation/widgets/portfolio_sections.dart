import 'package:flutter/material.dart';

import '../../domain/entities/portfolio.dart';
import 'portfolio_motion.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({
    super.key,
    required this.label,
    required this.child,
    this.rail = true,
  });
  final String label;
  final Widget child;
  final bool rail;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1216),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width < 600 ? 24 : 48,
              vertical: MediaQuery.sizeOf(context).width < 600 ? 72 : 128,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final title = Semantics(
                  headingLevel: 2,
                  child: Text(
                    label.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: MediaQuery.sizeOf(context).width < 600
                          ? 11
                          : 12,
                    ),
                  ),
                );
                if (rail && MediaQuery.sizeOf(context).width >= 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: title,
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(child: child),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, const SizedBox(height: 28), child],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

class AboutContent extends StatelessWidget {
  const AboutContent({super.key, required this.portfolio});
  final Portfolio portfolio;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final education = portfolio.education;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final paragraph in portfolio.about)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                paragraph,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: MediaQuery.sizeOf(context).width < 600 ? 17 : 18,
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final stat in portfolio.stats)
                SizedBox(
                  width:
                      constraints.maxWidth < 540 ||
                          MediaQuery.textScalerOf(context).scale(1) > 1.4
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 24) / 3,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stat.value, style: theme.textTheme.headlineLarge),
                        const SizedBox(height: 5),
                        Text(stat.label, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            Text(
              education.school,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text('· ${education.year}', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          '${education.degree} · ${education.honors}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class SkillContent extends StatelessWidget {
  const SkillContent({super.key, required this.groups});
  final List<SkillGroup> groups;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < groups.length; i++)
        Padding(
          padding: EdgeInsets.only(bottom: i == groups.length - 1 ? 0 : 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groups[i].name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TechnologyPills(items: groups[i].skills),
            ],
          ),
        ),
    ],
  );
}

class TechnologyPills extends StatelessWidget {
  const TechnologyPills({super.key, required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final item in items)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(item, style: Theme.of(context).textTheme.bodySmall),
        ),
    ],
  );
}

class ExperienceContent extends StatefulWidget {
  const ExperienceContent({super.key, required this.experience});
  final List<Experience> experience;
  @override
  State<ExperienceContent> createState() => _ExperienceContentState();
}

class _ExperienceContentState extends State<ExperienceContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) _line.value = 1;
  }

  @override
  void dispose() {
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Reveal(
    onVisible: () {
      if (mounted && !reduceMotion(context)) _line.forward();
    },
    child: Stack(
      children: [
        Positioned(
          left: 0,
          top: 4,
          bottom: 0,
          width: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: _line,
              builder: (context, _) => FractionallySizedBox(
                heightFactor: Curves.easeOutCubic.transform(_line.value),
                widthFactor: 1,
                child: ColoredBox(color: Theme.of(context).colorScheme.outline),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < widget.experience.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i == widget.experience.length - 1 ? 0 : 36,
                  ),
                  child: _ExperienceEntry(
                    experience: widget.experience[i],
                    current: i == 0,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ExperienceEntry extends StatelessWidget {
  const _ExperienceEntry({required this.experience, required this.current});
  final Experience experience;
  final bool current;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -31.5,
          top: 9,
          width: 8,
          height: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: current
                  ? theme.colorScheme.primary
                  : theme.scaffoldBackgroundColor,
              border: Border.all(
                color: current
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 20,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Semantics(
                      headingLevel: 3,
                      child: Text(
                        experience.role,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: MediaQuery.sizeOf(context).width < 600
                              ? 18
                              : 20,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    experience.period.toUpperCase(),
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              experience.company,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                experience.summary,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            TechnologyPills(items: experience.technologies),
          ],
        ),
      ],
    );
  }
}
