import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static void init() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      log('Flutter Error: ${details.exception}');
      log('Stack trace: ${details.stack}');

      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // Handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      log('Platform Error: $error');
      log('Stack trace: $stack');
      return true;
    };
  }

  static void handleError(dynamic error, StackTrace? stackTrace) {
    log('Error: $error');
    if (stackTrace != null) {
      log('Stack trace: $stackTrace');
    }
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
