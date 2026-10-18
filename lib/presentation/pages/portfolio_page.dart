import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/portfolio.dart';
import '../widgets/portfolio_motion.dart';
import '../widgets/portfolio_navigation.dart';
import '../widgets/portfolio_sections.dart';
import '../widgets/project_card.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    super.key,
    required this.portfolio,
    required this.onToggleTheme,
  });
  final Portfolio portfolio;
  final VoidCallback onToggleTheme;
  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scroll = ScrollController();
  final _viewportKey = GlobalKey();
  final _headerKey = GlobalKey();
  final _sectionKeys = {for (final name in sectionNames) name: GlobalKey()};
  bool _scrolled = false;
  String? _activeSection;
  double _headerHeight = 72;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scroll.hasClients && _scroll.offset > 24;
    String? active;
    final viewport =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewport != null && viewport.hasSize) {
      final top = viewport.localToGlobal(Offset.zero).dy + _headerHeight + 48;
      for (final name in sectionNames) {
        final box =
            _sectionKeys[name]!.currentContext?.findRenderObject()
                as RenderBox?;
        if (box != null &&
            box.hasSize &&
            box.localToGlobal(Offset.zero).dy <= top) {
          active = name;
        }
      }
    }
    if (scrolled != _scrolled || active != _activeSection) {
      setState(() {
        _scrolled = scrolled;
        _activeSection = active;
      });
    }
  }

  Future<void> _goTo(String name) async {
    final target = _sectionKeys[name]?.currentContext;
    if (target == null || !_scroll.hasClients) return;
    final renderObject = target.findRenderObject();
    if (renderObject == null) return;
    final offset = RenderAbstractViewport.of(renderObject)
        .getOffsetToReveal(renderObject, 0)
        .offset;
    final destination = (offset - _headerHeight - 20).clamp(
      _scroll.position.minScrollExtent,
      _scroll.position.maxScrollExtent,
    );
    if (reduceMotion(context)) {
      _scroll.jumpTo(destination);
    } else {
      await _scroll.animateTo(
        destination,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _open(Uri uri, String label) async {
    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
      if (opened || !mounted) return;
    } catch (_) {
      if (!mounted) return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $label. Please try again.')),
    );
  }

  void _openMenu() {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      animationStyle: reduceMotion(context) ? AnimationStyle.noAnimation : null,
      builder: (_) => MobileNavigation(
        handle: widget.portfolio.handle,
        onSection: _goTo,
        onToggleTheme: widget.onToggleTheme,
      ),
    );
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = widget.portfolio;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final header =
          _headerKey.currentContext?.findRenderObject() as RenderBox?;
      if (header != null &&
          header.hasSize &&
          header.size.height != _headerHeight) {
        setState(() => _headerHeight = header.size.height);
      }
      _onScroll();
    });
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              key: _viewportKey,
              child: SelectionArea(
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: _headerHeight),
                      _Hero(
                        portfolio: portfolio,
                        onWork: () => _goTo('Work'),
                        onCv: () => _open(
                          Uri.base.resolve(portfolio.cvPath),
                          'your CV',
                        ),
                      ),
                      PortfolioSection(
                        key: _sectionKeys['About'],
                        label: '01 / About',
                        child: Reveal(
                          child: AboutContent(portfolio: portfolio),
                        ),
                      ),
                      PortfolioSection(
                        key: _sectionKeys['Skills'],
                        label: '02 / Skills',
                        child: Reveal(
                          child: SkillContent(groups: portfolio.skills),
                        ),
                      ),
                      PortfolioSection(
                        key: _sectionKeys['Experience'],
                        label: '03 / Experience',
                        child: ExperienceContent(
                          experience: portfolio.experience,
                        ),
                      ),
                      PortfolioSection(
                        key: _sectionKeys['Work'],
                        label: '04 / Selected work',
                        rail: false,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final columns =
                                MediaQuery.sizeOf(context).width < 600 ? 1 : 2;
                            final width =
                                (constraints.maxWidth - (columns - 1) * 24) /
                                columns;
                            return Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: [
                                for (
                                  var i = 0;
                                  i < portfolio.projects.length;
                                  i++
                                )
                                  SizedBox(
                                    width: width,
                                    child: Reveal(
                                      delay: Duration(
                                        milliseconds: i % columns * 90,
                                      ),
                                      child: ProjectCard(
                                        project: portfolio.projects[i],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      _Contact(
                        portfolio: portfolio,
                        onEmail: () => _open(
                          Uri(scheme: 'mailto', path: portfolio.email),
                          'your email app',
                        ),
                        onLinkedin: () =>
                            _open(Uri.parse(portfolio.linkedin), 'LinkedIn'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              key: _headerKey,
              child: PortfolioNavigation(
                handle: portfolio.handle,
                activeSection: _activeSection,
                scrolled: _scrolled,
                onSection: _goTo,
                onToggleTheme: widget.onToggleTheme,
                onMenu: _openMenu,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.portfolio,
    required this.onWork,
    required this.onCv,
  });
  final Portfolio portfolio;
  final VoidCallback onWork;
  final VoidCallback onCv;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;
    final nameSize = mobile
        ? 40.0
        : width < 900
        ? 60.0
        : 72.0;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1216),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            mobile ? 24 : 48,
            mobile ? 80 : 160,
            mobile ? 24 : 48,
            mobile ? 80 : 128,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Reveal(
                  duration: const Duration(milliseconds: 500),
                  child: Availability(label: portfolio.availability),
                ),
                const SizedBox(height: 28),
                Reveal(
                  delay: const Duration(milliseconds: 90),
                  duration: const Duration(milliseconds: 500),
                  child: Semantics(
                    headingLevel: 1,
                    child: Text(
                      portfolio.name,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: nameSize,
                        letterSpacing: mobile ? -1.4 : -2.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Reveal(
                  delay: const Duration(milliseconds: 180),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    portfolio.role,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: mobile ? 22 : 32,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Reveal(
                  delay: const Duration(milliseconds: 270),
                  duration: const Duration(milliseconds: 500),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Text(
                      portfolio.bio,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: mobile ? 17 : 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Reveal(
                  delay: const Duration(milliseconds: 360),
                  duration: const Duration(milliseconds: 500),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        onPressed: onWork,
                        child: const Text('View work'),
                      ),
                      OutlinedButton(
                        onPressed: onCv,
                        child: const Text('View CV'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Reveal(
                  delay: const Duration(milliseconds: 450),
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          portfolio.location,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({
    required this.portfolio,
    required this.onEmail,
    required this.onLinkedin,
  });
  final Portfolio portfolio;
  final VoidCallback onEmail;
  final VoidCallback onLinkedin;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mobile = MediaQuery.sizeOf(context).width < 600;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1216),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              mobile ? 24 : 48,
              mobile ? 56 : 80,
              mobile ? 24 : 48,
              32,
            ),
            child: Reveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HAVE A PROJECT IN MIND?',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(height: 18),
                  Semantics(
                    headingLevel: 2,
                    child: Text(
                      'Let’s build something.',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: mobile ? 26 : 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Text(
                      'Thoughtful software starts with a conversation.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 20,
                    runSpacing: 4,
                    children: [
                      UnderlineLink(
                        label: portfolio.email,
                        onPressed: onEmail,
                        accent: true,
                      ),
                      UnderlineLink(
                        label: 'LinkedIn',
                        onPressed: onLinkedin,
                        accent: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                  const Divider(),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 24,
                    runSpacing: 8,
                    children: [
                      Text(
                        '© ${DateTime.now().year} ${portfolio.name}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'Built with Flutter. Made with care.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
