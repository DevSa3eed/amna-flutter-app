import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:device_preview/device_preview.dart';

import 'amna.dart';
import 'constants/cached_constants/cached_constants.dart';
import 'core/config/config.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that the binding is initialized
  await ScreenUtil.ensureScreenSize();

  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  DioHelper.init();
  await cacheHelper.init();
  lang = cacheHelper.getData('lang') ?? false;
  await config.LoadLanguage(lang!);
  userID = cacheHelper.getData('userID');
  token = cacheHelper.getData('token');
  isAdmin = cacheHelper.getData('isAdmin') ?? false;
  name = cacheHelper.getData('name');
  image = cacheHelper.getData('image');
  userEmail = cacheHelper.getData('email');
  username = cacheHelper.getData('username');
  phone = cacheHelper.getData('phone');
  onBoarding = cacheHelper.getData('onBoarding') ?? false;
  // cacheHelper.removeData('onBoarding');
  log('/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/');
  log(userID ?? '');
  log(token ?? '');
  log(name ?? '');
  log(image ?? '');
  log(userEmail ?? '');
  log(username ?? '');
  log(phone ?? '');
  log(isAdmin!.toString());
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
