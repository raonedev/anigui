import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedCustomGrid extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final int crossAxisCount;
  final double spacing;
  final Duration staggerDuration;
  final Duration animationDuration;

  const AnimatedCustomGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.gridDelegate,
    this.crossAxisCount = 2,
    this.spacing = 16.0,
    this.staggerDuration = Durations.short1,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedCustomGrid> createState() => _AnimatedCustomGridState();
}

class _AnimatedCustomGridState extends State<AnimatedCustomGrid> {
  bool _isReadyToAnimate = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation readiness slightly after build
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isReadyToAnimate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final delegate = widget.gridDelegate ??
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          crossAxisSpacing: widget.spacing,
          mainAxisSpacing: widget.spacing,
          childAspectRatio: 0.8,
        );

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: delegate,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        final child = widget.itemBuilder(context, index);
        return _AnimatedGridItem(
          delay: Duration(
            milliseconds: index * widget.staggerDuration.inMilliseconds,
          ),
          duration: widget.animationDuration,
          isReadyToAnimate: _isReadyToAnimate,
          child: child,
        );
      },
    );
  }
}
class _AnimatedGridItem extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final bool isReadyToAnimate;

  const _AnimatedGridItem({
    required this.child,
    required this.delay,
    required this.duration,
    required this.isReadyToAnimate,
  });

  @override
  State<_AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<_AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _blurAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );
    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)),
    );

    if (widget.isReadyToAnimate) _triggerAnimation();
  }

  void _triggerAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant _AnimatedGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReadyToAnimate && !_hasAnimated) {
      _triggerAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // ✅ Always reserve layout space using Transform, NOT Offstage or SizedBox
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value.clamp(0.0, 1.0),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: child,
            ),
          ),
        );
      },
      child: widget.child, // ✅ Pass as child to avoid rebuilds
    );
  }
}
