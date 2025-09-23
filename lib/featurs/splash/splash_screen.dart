import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/services/auth_service.dart';
import '../../core/config/config.dart';
import '../../core/theme/Colors/coluors.dart';
import '../../core/theme/text_styles/text_styeles.dart';
import '../../routes/routes.dart';
import '../../constants/cached_constants/cached_constants.dart';

/// Splash screen that handles authentication initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize authentication service
      await AuthService.instance.initializeAuth();

      // Add a minimum splash duration for better UX
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      debugPrint('Error initializing app: $e');
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  void _navigateToNextScreen() {
    final authService = AuthService.instance;

    if (authService.isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.homeRoute);
    } else {
      // Navigate directly to the appropriate screen based on onboarding status
      if (!onBoarding) {
        Navigator.pushReplacementNamed(context, Routes.intialRoute);
      } else {
        Navigator.pushReplacementNamed(context, Routes.landingRoute);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.DarkBlue,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colours.DarkBlue,
              Colours.LightBlue,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Colours.White,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.asset(
                      'assets/images/splash_icon12.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // App Name
                Text(
                  config.localization['App Name'] ?? 'My Clinic',
                  style: TextStyles.white20blod.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10.h),

                // Tagline
                Text(
                  config.localization['clinicdes'] ?? 'Your Health Starts Here',
                  style: TextStyles.white20blod.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: Colours.White.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 50.h),

                // Loading Indicator
                SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colours.White.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
