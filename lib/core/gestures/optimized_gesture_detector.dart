import 'package:flutter/material.dart';

class OptimizedGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool enabled;
  final Duration tapTimeout;
  final double tapRadius;

  const OptimizedGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.enabled = true,
    this.tapTimeout = const Duration(milliseconds: 300),
    this.tapRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

class OptimizedInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? splashColor;
  final Color? highlightColor;
  final bool enabled;
  final BorderRadius? borderRadius;

  const OptimizedInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.splashColor,
    this.highlightColor,
    this.enabled = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: splashColor,
        highlightColor: highlightColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
