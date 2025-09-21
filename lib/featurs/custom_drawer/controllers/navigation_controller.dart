import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  String _currentRoute = '/';

  String get currentRoute => _currentRoute;

  void setCurrentRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      notifyListeners();
    }
  }

  bool isCurrentRoute(String route) {
    return _currentRoute == route;
  }

  void navigateToRoute(BuildContext context, String route) {
    setCurrentRoute(route);
    Navigator.pushNamed(context, route);
    // Don't pop here - let the calling widget handle drawer closing
  }
}
