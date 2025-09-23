import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/core/animated_navigation/animated_navigator.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/constant_widgets/circle_progress.dart';
import 'package:dr_sami/core/services/auth_service.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/custom_drawer/custom_drawer.dart';
import 'package:dr_sami/featurs/home_screen/baners/banners.dart';
import 'package:dr_sami/featurs/home_screen/clinic/clinics.dart';
import 'package:dr_sami/featurs/home_screen/opinions/all_opinions.dart';
import 'package:dr_sami/featurs/home_screen/opinions/cubit/opinions_cubit.dart';
import 'package:dr_sami/featurs/home_screen/teams/team_members.dart';
// Removed import for icons.dart - no longer needed
import 'package:dr_sami/routes/routes.dart';
import 'package:path/path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;

    return WillPopScope(
      onWillPop: () async {
        // Prevent back button from going to previous screen
        // Instead, show exit confirmation or minimize app
        return false;
      },
      child: Scaffold(
        backgroundColor: Colours.White,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false, // Hide back button
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    createRoute(const CustomDrawer(), true,
                        animationType: DrawerAnimationType.leftSlide));
              },
              icon: const Icon(
                Icons.menu,
              )),
          title: Text(
            config.localization['App Name'],
            style: TextStyles.lightBlue20blod,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(authService),
              SizedBox(
                height: 15.h,
                width: double.infinity,
              ),
              const BannersView(),

              // Show different content based on authentication status
              if (authService.isAuthenticated) ...[
                _buildSectionTitle(
                    config.localization['clincs'] ?? 'Our Clinics'),
                const Clinics(),
                _buildSectionTitle(config.localization['custmoerOpinion'] ??
                    'Customer Opinions'),
                BlocProvider(
                  create: (context) => OpinionsCubit()..getOpinions(),
                  child: BlocConsumer<OpinionsCubit, OpinionsState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return const OpinonBulider();
                    },
                  ),
                ),
                _buildSectionTitle(
                    config.localization['ourTeam'] ?? 'Our Team'),
                const TeamMembers(),
              ] else ...[
                _buildPublicContent(),
              ],
            ],
          ),
        ),
        floatingActionButton: authService.isAuthenticated
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.requsetMeatRoute);
                },
                shape: const CircleBorder(),
                backgroundColor: Colours.DarkBlue,
                child: Icon(
                  IconlyBroken.call,
                  size: 30.w,
                  color: Colours.White,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildWelcomeSection(AuthService authService) {
    return Row(
      children: [
        SizedBox(width: 15.w),
        authService.currentUserImage == null
            ? Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Image.asset(
                  'assets/images/account.png',
                  fit: BoxFit.contain,
                  width: 40.w,
                  height: 40.w,
                  color: Colours.LightBlue,
                ),
              )
            : ClipOval(
                child: CachedNetworkImage(
                  width: 55.w,
                  height: 55.w,
                  fit: BoxFit.cover,
                  imageUrl: '$imageUrl${authService.currentUserImage}',
                  placeholder: (context, url) => customLoader(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              config.localization['welcome'],
              style: TextStyles.lightBlue16blod,
            ),
            if (authService.currentUserName != null)
              Text(
                authService.currentUserName!,
                style: TextStyles.lightBlue16blod,
              ),
          ],
        )
      ],
    );
  }

  Widget _buildPublicContent() {
    return Column(
      children: [
        _buildSectionTitle(config.localization['clincs'] ?? 'Our Clinics'),
        const Clinics(),
        _buildSectionTitle(
            config.localization['custmoerOpinion'] ?? 'Customer Opinions'),
        BlocProvider(
          create: (context) => OpinionsCubit()..getOpinions(),
          child: BlocConsumer<OpinionsCubit, OpinionsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return const OpinonBulider();
            },
          ),
        ),
        _buildSectionTitle(config.localization['ourTeam'] ?? 'Our Team'),
        const TeamMembers(),
        SizedBox(height: 20.h),
        _buildLoginPrompt(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Text(
        title,
        style: TextStyles.lightBlue20blod.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colours.LightBlue, Colours.DarkBlue],
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.login,
            size: 40.w,
            color: Colours.White,
          ),
          SizedBox(height: 10.h),
          Text(
            'Get Full Access',
            style: TextStyles.white20blod.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Login to request meetings, add opinions, and access all features',
            style: TextStyles.white20blod.copyWith(
              fontSize: 14.sp,
              color: Colours.White.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context as BuildContext, Routes.loginRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.White,
                    foregroundColor: Colours.DarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    config.localization['login'],
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context as BuildContext, Routes.eulaRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colours.White,
                    side: BorderSide(color: Colours.White),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    config.localization['register'],
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
