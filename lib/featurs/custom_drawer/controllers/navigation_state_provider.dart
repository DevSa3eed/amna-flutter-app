import 'package:flutter/material.dart';

class NavigationStateProvider extends ChangeNotifier {
  String _currentRoute = '/';
  final Map<String, bool> _navigationStates = {};

  String get currentRoute => _currentRoute;
  Map<String, bool> get navigationStates => _navigationStates;

  void setCurrentRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      _updateNavigationStates();
      notifyListeners();
    }
  }

  void _updateNavigationStates() {
    _navigationStates.clear();
    _navigationStates[_currentRoute] = true;
  }

  bool isCurrentRoute(String route) {
    return _currentRoute == route;
  }

  void navigateToRoute(BuildContext context, String route) {
    setCurrentRoute(route);
    Navigator.pushNamed(context, route);
    // Don't pop here - let the calling widget handle drawer closing
  }

  void navigateToWidget(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, -1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
    // Don't pop here - let the calling widget handle drawer closing
  }
}
