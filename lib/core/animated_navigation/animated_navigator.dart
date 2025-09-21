import 'package:flutter/cupertino.dart';

Route createRoute(Widget nextScreen, bool? open) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = open!
          ? const Offset(-1.0, -1.0)
          : const Offset(1.0, 1.0); // Start position (right side of screen)
      const end = Offset.zero; // End position (center of the screen)
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}
