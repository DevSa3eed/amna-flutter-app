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
import 'core/guards/route_guard.dart';
import 'core/services/auth_service.dart';
import 'featurs/splash/splash_screen.dart';
import 'featurs/onboarding/onboarding_screen.dart';
import 'featurs/home_screen/home_screen.dart';
import 'featurs/landing/landing_page.dart';
import 'routes/app_routers.dart';

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
                  backgroundColor: Colours.White,
                )),
                debugShowCheckedModeBanner: false,
                builder: DevicePreview.appBuilder,
                initialRoute: Routes.splashRoute,
                onGenerateRoute: _onGenerateRoute,
                home: child,
              );
            },
          ),
        );
      },
    );
  }

  /// Generate route with authentication checks
  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    // Check route protection first
    final protectedRoute = RouteGuard.onGenerateRoute(settings);
    if (protectedRoute != null) {
      return protectedRoute;
    }

    // Handle splash route
    if (settings.name == Routes.splashRoute) {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    }

    // Handle initial route based on onboarding status
    if (settings.name == Routes.intialRoute) {
      if (!onBoarding) {
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      } else {
        // Redirect to appropriate page based on auth status
        final authService = AuthService.instance;
        if (authService.isAuthenticated) {
          return MaterialPageRoute(builder: (_) => const HomeScreen());
        } else {
          return MaterialPageRoute(builder: (_) => const LandingPage());
        }
      }
    }

    // Use default router for other routes
    return AppRouter.generateRoute(settings);
  }
}
