import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:device_preview/device_preview.dart';

import 'amna.dart';
import 'constants/cached_constants/cached_constants.dart';
import 'core/config/config.dart';
import 'core/error_handler/error_handler.dart';
import 'core/services/auth_service.dart';
import 'core/services/notification_service.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that the binding is initialized

  // Initialize error handling
  ErrorHandler.init();

  await ScreenUtil.ensureScreenSize();

  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  DioHelper.init();
  await cacheHelper.init();
  lang = cacheHelper.getData('lang') ?? false;
  await config.LoadLanguage(lang!);
  onBoarding = cacheHelper.getData('onBoarding') ?? false;

  // Initialize authentication service
  await AuthService.instance.initializeAuth();

  // Initialize notification service
  await NotificationService.initialize();

  // Debug logging
  log('/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/');
  log('Auth Status: ${AuthService.instance.isAuthenticated}');
  log('User ID: ${AuthService.instance.currentUserID ?? 'null'}');
  log('Token: ${AuthService.instance.currentToken ?? 'null'}');
  log('Name: ${AuthService.instance.currentUserName ?? 'null'}');
  log('Email: ${AuthService.instance.currentUserEmail ?? 'null'}');
  log('Image: ${AuthService.instance.currentUserImage ?? 'null'}');
  log('Is Admin: ${AuthService.instance.isAdminUser}');
  log('/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/');

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode, // This disables DevicePreview in release mode.
  //     builder: (context) => EasyLocalization(
  //         supportedLocales: const [Locale('en'), Locale('ar')],
  //         path:
  //             'assets/localization', // <-- change the path of the translation files
  //         fallbackLocale: const Locale('en'),
  //         child: const AmnaApp()),
  //   ), // Wrap your app
  // );
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path:
            'assets/localization', // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
        child: const AmnaApp()),
  );
}
