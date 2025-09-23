import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DrawerAnimationType {
  leftSlide, // Standard left slide (recommended)
  rightSlide, // Right slide
  topSlide, // Top slide
  bottomSlide, // Bottom slide
  scale, // Scale animation
  fade, // Fade animation
  diagonalSlide // Your current animation (not recommended)
}

Route createRoute(Widget nextScreen, bool? open,
    {DrawerAnimationType animationType = DrawerAnimationType.leftSlide}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (animationType) {
        case DrawerAnimationType.leftSlide:
          return _buildLeftSlideTransition(animation, child);
        case DrawerAnimationType.rightSlide:
          return _buildRightSlideTransition(animation, child);
        case DrawerAnimationType.topSlide:
          return _buildTopSlideTransition(animation, child);
        case DrawerAnimationType.bottomSlide:
          return _buildBottomSlideTransition(animation, child);
        case DrawerAnimationType.scale:
          return _buildScaleTransition(animation, child);
        case DrawerAnimationType.fade:
          return _buildFadeTransition(animation, child);
        case DrawerAnimationType.diagonalSlide:
          return _buildDiagonalSlideTransition(animation, child, open!);
      }
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// Left slide animation (most common for drawers)
Widget _buildLeftSlideTransition(Animation<double> animation, Widget child) {
  const begin = Offset(-1.0, 0.0); // Slide from left edge
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

// Right slide animation
Widget _buildRightSlideTransition(Animation<double> animation, Widget child) {
  const begin = Offset(1.0, 0.0); // Slide from right edge
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

// Top slide animation
Widget _buildTopSlideTransition(Animation<double> animation, Widget child) {
  const begin = Offset(0.0, -1.0); // Slide from top
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

// Bottom slide animation
Widget _buildBottomSlideTransition(Animation<double> animation, Widget child) {
  const begin = Offset(0.0, 1.0); // Slide from bottom
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

// Scale animation
Widget _buildScaleTransition(Animation<double> animation, Widget child) {
  const curve = Curves.easeInOut;
  final scaleAnimation = animation.drive(CurveTween(curve: curve));

  return ScaleTransition(
    scale: scaleAnimation,
    child: child,
  );
}

// Fade animation
Widget _buildFadeTransition(Animation<double> animation, Widget child) {
  const curve = Curves.easeInOut;
  final fadeAnimation = animation.drive(CurveTween(curve: curve));

  return FadeTransition(
    opacity: fadeAnimation,
    child: child,
  );
}

// Your current diagonal animation (kept for reference)
Widget _buildDiagonalSlideTransition(
    Animation<double> animation, Widget child, bool open) {
  final begin = open
      ? const Offset(-1.0, -1.0) // Top-left corner
      : const Offset(1.0, 1.0); // Bottom-right corner
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
