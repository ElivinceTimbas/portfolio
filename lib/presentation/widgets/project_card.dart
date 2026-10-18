import 'package:flutter/material.dart';

import '../../domain/entities/portfolio.dart';
import 'portfolio_motion.dart';
import 'portfolio_sections.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});
  final Project project;
  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hover =
        _hovered &&
        MediaQuery.sizeOf(context).width >= 900 &&
        !reduceMotion(context);
    final duration = reduceMotion(context)
        ? Duration.zero
        : const Duration(milliseconds: 220);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, hover ? -4 : 0, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          border: Border.all(
            color: hover
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: AnimatedScale(
                scale: hover ? 1.04 : 1,
                duration: duration,
                child: ProjectThumbnail(kind: widget.project.kind),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              widget.project.category.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 7),
            Semantics(
              headingLevel: 3,
              child: Text(
                widget.project.title,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 9),
            Text(widget.project.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            TechnologyPills(items: widget.project.technologies),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class ProjectThumbnail extends StatelessWidget {
  const ProjectThumbnail({super.key, required this.kind});
  final ProjectKind kind;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final health = kind == ProjectKind.family || kind == ProjectKind.doctors;
    final accent = theme.colorScheme.primary;
    final tint = health
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    return ExcludeSemantics(
      child: SizedBox(
        height: 188,
        width: double.infinity,
        child: ColoredBox(
          color: tint,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: -22,
                    top: -62,
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accent.withValues(alpha: .1)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -52,
                    bottom: -110,
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accent.withValues(alpha: .08),
                        ),
                      ),
                    ),
                  ),
                  if (health)
                    _HealthMotif(kind: kind, accent: accent, dark: dark)
                  else if (kind == ProjectKind.web)
                    _WebMotif(accent: accent, dark: dark)
                  else
                    _FoodMotif(accent: accent, dark: dark),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HealthMotif extends StatelessWidget {
  const _HealthMotif({
    required this.kind,
    required this.accent,
    required this.dark,
  });
  final ProjectKind kind;
  final Color accent;
  final bool dark;
  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Transform.translate(
        offset: const Offset(32, 13),
        child: Transform.rotate(
          angle: .1,
          child: Container(
            width: 106,
            height: 155,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: .2)),
            ),
          ),
        ),
      ),
      Transform.translate(
        offset: const Offset(-8, 14),
        child: Transform.rotate(
          angle: -.06,
          child: Container(
            width: 108,
            height: 164,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF1A2422) : const Color(0xFFFBFFFD),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: .4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: .25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        kind == ProjectKind.family
                            ? Icons.favorite_outline
                            : Icons.medical_services_outlined,
                        size: 15,
                        color: accent,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Line(color: accent, width: 35),
                          const SizedBox(height: 5),
                          _Line(
                            color: accent.withValues(alpha: .25),
                            width: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Container(
                  height: 35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CustomPaint(painter: _PulsePainter(accent)),
                ),
                const SizedBox(height: 12),
                _Line(color: accent.withValues(alpha: .25), width: 55),
                const SizedBox(height: 6),
                _Line(color: accent.withValues(alpha: .14), width: 74),
                const SizedBox(height: 6),
                _Line(color: accent.withValues(alpha: .14), width: 65),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        right: 32,
        bottom: 28,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            kind == ProjectKind.family
                ? Icons.people_outline
                : Icons.add_rounded,
            color: dark ? const Color(0xFF16302D) : Colors.white,
            size: 21,
          ),
        ),
      ),
    ],
  );
}

class _WebMotif extends StatelessWidget {
  const _WebMotif({required this.accent, required this.dark});
  final Color accent;
  final bool dark;
  @override
  Widget build(BuildContext context) => Transform.translate(
    offset: const Offset(0, 10),
    child: Container(
      width: 232,
      height: 142,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1A1817) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: .35)),
      ),
      child: Column(
        children: [
          Container(
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: accent.withValues(alpha: .15)),
              ),
            ),
            child: Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(alpha: .35),
                      ),
                    ),
                  ),
                const SizedBox(width: 15),
                _Line(color: accent.withValues(alpha: .12), width: 112),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Line(color: accent.withValues(alpha: .8), width: 77),
                        const SizedBox(height: 8),
                        _Line(color: accent.withValues(alpha: .8), width: 58),
                        const SizedBox(height: 12),
                        _Line(color: accent.withValues(alpha: .2), width: 92),
                        const SizedBox(height: 5),
                        _Line(color: accent.withValues(alpha: .2), width: 72),
                        const SizedBox(height: 12),
                        Container(
                          width: 43,
                          height: 12,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 64,
                    height: 80,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.public_rounded,
                      size: 34,
                      color: accent.withValues(alpha: .8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _FoodMotif extends StatelessWidget {
  const _FoodMotif({required this.accent, required this.dark});
  final Color accent;
  final bool dark;
  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 124,
        height: 124,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dark ? const Color(0xFF221F1E) : const Color(0xFFFAFAF9),
          border: Border.all(color: accent.withValues(alpha: .22), width: 8),
        ),
        child: Container(
          margin: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: .2)),
          ),
          child: Icon(Icons.ramen_dining_rounded, size: 42, color: accent),
        ),
      ),
      Transform.translate(
        offset: const Offset(65, 37),
        child: Transform.rotate(
          angle: -.12,
          child: Container(
            width: 49,
            height: 66,
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF1A1817) : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: accent.withValues(alpha: .3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 22, color: accent),
                const SizedBox(height: 5),
                _Line(color: accent.withValues(alpha: .4), width: 22),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _Line extends StatelessWidget {
  const _Line({required this.color, required this.width});
  final Color color;
  final double width;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: 4,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

class _PulsePainter extends CustomPainter {
  _PulsePainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(6, size.height * .55)
      ..lineTo(size.width * .29, size.height * .55)
      ..lineTo(size.width * .39, size.height * .3)
      ..lineTo(size.width * .49, size.height * .77)
      ..lineTo(size.width * .59, size.height * .39)
      ..lineTo(size.width * .68, size.height * .55)
      ..lineTo(size.width - 6, size.height * .55);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_PulsePainter oldDelegate) => oldDelegate.color != color;
}
