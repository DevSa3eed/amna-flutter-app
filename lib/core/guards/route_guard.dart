import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../routes/routes.dart';
import '../../featurs/auth/login_first.dart';

/// Route guard for protecting authenticated routes
class RouteGuard {
  /// Generate route with authentication checks
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final authService = AuthService.instance;

    // Check if route requires authentication
    if (authService.requiresAuthentication(settings.name)) {
      if (!authService.isAuthenticated) {
        // Redirect to login first page
        return MaterialPageRoute(
          builder: (_) => const LoginFirst(),
          settings: RouteSettings(name: Routes.loginFirstRoute),
        );
      }
    }

    // Check if route requires admin privileges
    if (authService.requiresAdmin(settings.name)) {
      if (!authService.isAuthenticated || !authService.isAdminUser) {
        // Redirect to home or show error
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Access Denied'),
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You do not have permission to access this page.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          settings: RouteSettings(name: '/AccessDenied'),
        );
      }
    }

    // Route is accessible, return null to continue with normal routing
    return null;
  }

  /// Check if user can access a specific route
  static bool canAccessRoute(String? routeName) {
    final authService = AuthService.instance;

    if (authService.requiresAuthentication(routeName)) {
      return authService.isAuthenticated;
    }

    if (authService.requiresAdmin(routeName)) {
      return authService.isAuthenticated && authService.isAdminUser;
    }

    return true; // Public route
  }

  /// Get the appropriate initial route based on authentication status
  static String getInitialRoute() {
    final authService = AuthService.instance;

    if (authService.isAuthenticated) {
      return Routes.homeRoute;
    } else {
      return Routes.intialRoute;
    }
  }
}
