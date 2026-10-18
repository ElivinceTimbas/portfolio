import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

bool reduceMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ||
    MediaQuery.accessibleNavigationOf(context);

class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.onVisible,
  });
  final Widget child;
  final Duration delay;
  final Duration duration;
  final VoidCallback? onVisible;
  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  late final Key _visibilityKey = UniqueKey();
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) _controller.value = 1;
  }

  Future<void> _reveal() async {
    if (!mounted || _started) return;
    _started = true;
    widget.onVisible?.call();
    if (widget.delay != Duration.zero && !reduceMotion(context)) {
      await Future<void>.delayed(widget.delay);
    }
    if (mounted && !reduceMotion(context)) _controller.forward();
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _visibilityKey,
    onVisibilityChanged: (info) {
      if (info.visibleFraction >= .15) _reveal();
    },
    child: FadeTransition(
      opacity: _curve,
      child: AnimatedBuilder(
        animation: _curve,
        child: widget.child,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, 24 * (1 - _curve.value)),
          child: child,
        ),
      ),
    ),
  );
}

class Availability extends StatefulWidget {
  const Availability({super.key, required this.label});
  final String label;
  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
    lowerBound: .4,
    upperBound: 1,
  );
  late final Key _key = UniqueKey();
  bool _visible = true;
  bool _foreground = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  void _sync() {
    if (_visible &&
        _foreground &&
        !reduceMotion(context) &&
        TickerMode.of(context)) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 1;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _key,
    onVisibilityChanged: (info) {
      if (!mounted) return;
      _visible = info.visibleFraction > 0;
      _sync();
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) => Container(
            width: 15,
            height: 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: reduceMotion(context)
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.primary
                        .withValues(alpha: .12 * _pulse.value),
            ),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            widget.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    ),
  );
}
