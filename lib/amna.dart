import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dr_sami/core/config/cubit/localization_cubit.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/cached_constants/cached_constants.dart';
import 'core/theme/Colors/coluors.dart';
import 'routes/App_routers.dart';

class AmnaApp extends StatelessWidget {
  const AmnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider(
          create: (context) => LocalizationCubit()..changeLanguage(lang!),
          child: BlocConsumer<LocalizationCubit, LocalizationState>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                // locale: state is Success
                //     ? state.isArabic
                //         ? const Locale('ar')
                //         : const Locale('en')
                //     : const Locale('en'),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData(
                    appBarTheme: AppBarTheme(
                  scrolledUnderElevation: 0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    statusBarColor: Colors.transparent,
                    // statusBarColor: Colours.White,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarColor: Colors.transparent,
                    // systemNavigationBarColor: Colours.White,
                    // systemNavigationBarIconBrightness: Brightness.dark,
                  ),
                  iconTheme: IconThemeData(
                    color: Colours.DarkBlue,
                    size: 26.r,
                  ),
                  color: Colours.White,
                )),
                debugShowCheckedModeBanner: false,
                builder: DevicePreview.appBuilder,
                initialRoute:
                    !onBoarding ? Routes.intialRoute : Routes.homeRoute,
                onGenerateRoute: AppRouter.generateRoute,
                home: child,
              );
            },
          ),
        );
      },
    );
  }
}
