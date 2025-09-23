import 'package:dr_sami/core/extensions/media_values.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/services/auth_service.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../constants/cached_constants/cached_constants.dart';
import '../../core/animated_navigation/animated_navigator.dart';
import '../../core/config/cubit/localization_cubit.dart';
import '../../network/local/cache_helper.dart';
import '../auth/admin/add_admin.dart';
import '../auth/profile/cubit/profile_cubit.dart';
import '../auth/profile/widget/delete_confirm.dart';
import '../home_screen/requset_meet/cubit/meeting_cubit.dart';
import '../home_screen/requset_meet/widgets/button.dart';
import '../home_screen/teams/add_member.dart';
import '../home_screen/widgets/condition.dart';
import 'widgets/profile_image.dart';
import 'widgets/navigation_group.dart';
import 'widgets/navigation_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;

    return Scaffold(
      backgroundColor: Colours.White,
      body: BlocProvider(
        create: (context) => LocalizationCubit()..changeLanguage(isArabic!),
        child: BlocConsumer<LocalizationCubit, LocalizationState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(context, authService),
                Expanded(
                  child: _buildNavigationContent(context, authService),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthService authService) {
    return authService.currentUserImage != null
        ? Container(
            width: context.width,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(50.r)),
              color: Colours.DarkBlue,
              image: const DecorationImage(
                image: AssetImage('assets/images/pngegg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10.h,
                    left: 16.w,
                    right: 16.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App logo or title
                      Text(
                        config.localization['App Name'] ?? 'Amna',
                        style: TextStyles.white20blod.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      // Close button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colours.White,
                            size: 20.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile content
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ProfileImage(),
                      SizedBox(height: 16.h),
                      BlocProvider(
                        create: (context) => UserProfileCubit(),
                        child: BlocConsumer<UserProfileCubit, userProfileState>(
                          listener: (context, state) {
                            if (state is GetProfilesuccess) {
                              Navigator.pushReplacementNamed(
                                  context, Routes.updateProfileRoute);
                            }
                          },
                          builder: (context, state) {
                            return ConditionBuilder(
                              condition: state is GetProfileLoading,
                              ifFalse: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.w),
                                child: SmallButton(
                                  condition: false,
                                  color: Colours.White,
                                  text: config.localization['updateprofile'],
                                  fontColor: Colours.DarkBlue,
                                  fun: () async {
                                    context
                                        .read<UserProfileCubit>()
                                        .getUserInfo();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: context.width,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(50.r)),
              color: Colours.DarkBlue,
              image: const DecorationImage(
                image: AssetImage('assets/images/pngegg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10.h,
                    left: 16.w,
                    right: 16.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App logo or title
                      Text(
                        config.localization['App Name'] ?? 'Amna',
                        style: TextStyles.white20blod.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      // Close button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colours.White,
                            size: 20.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/account.png',
                        fit: BoxFit.contain,
                        width: 120.w,
                        height: 120.w,
                        color: Colours.White,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildNavigationContent(
      BuildContext context, AuthService authService) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
        return Column(
          children: [
            // Main Navigation Group
            NavigationGroup(
              title: config.localization['main'],
              items: [
                NavigationItem(
                  label: config.localization['home'],
                  icon: IconlyBold.home,
                  onTap: () async {
                    Navigator.pop(context); // Close drawer first
                    await Future.delayed(const Duration(milliseconds: 100));
                    if (context.mounted) {
                      Navigator.pushNamed(context, Routes.homeRoute);
                    }
                  },
                  isSelected:
                      ModalRoute.of(context)?.settings.name == Routes.homeRoute,
                ),
              ],
            ),

            // Features Group - Only show if authenticated
            if (authService.isAuthenticated)
              NavigationGroup(
                title: config.localization['features'],
                items: [
                  NavigationItem(
                    label: 'Find Doctors',
                    icon: IconlyBold.search,
                    onTap: () async {
                      Navigator.pop(context); // Close drawer first
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (context.mounted) {
                        Navigator.pushNamed(context, Routes.doctorSearchRoute);
                      }
                    },
                  ),
                  NavigationItem(
                    label: config.localization['requestMeeting'],
                    icon: IconlyBold.call,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.requsetMeatRoute);
                    },
                  ),
                  NavigationItem(
                    label: config.localization['addOPinion'],
                    icon: IconlyBold.plus,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.addOpinionRoute);
                    },
                  ),
                  NavigationItem(
                    label: config.localization['userequests'],
                    icon: IconlyBold.category,
                    onTap: () async {
                      Navigator.pop(context); // Close drawer first
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (context.mounted) {
                        Navigator.pushNamed(
                            context, Routes.userRequestsMeetRoute);
                      }
                    },
                  ),
                ],
              ),

            // Settings Group
            NavigationGroup(
              title: config.localization['settings'],
              items: [
                NavigationItem(
                  label: config.localization['lang'],
                  icon: Icons.language,
                  onTap: () {
                    isArabic = !(isArabic ?? false);
                    context.read<LocalizationCubit>().changeLanguage(isArabic!);
                    debugPrint(cacheHelper.getData('lang').toString());
                    if (isArabic!) {
                      context.setLocale(const Locale('ar'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                  },
                ),
              ],
            ),

            // Account Group - Only show if not authenticated
            if (!authService.isAuthenticated)
              NavigationGroup(
                title: config.localization['account'],
                items: [
                  NavigationItem(
                    label: config.localization['login'],
                    icon: IconlyBold.login,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.loginRoute);
                    },
                  ),
                  NavigationItem(
                    label: config.localization['register'],
                    icon: IconlyBold.login,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.eulaRoute);
                    },
                  ),
                ],
              ),

            // Admin Group - Only show if admin
            if (authService.isAdminUser)
              NavigationGroup(
                title: config.localization['admin'],
                items: [
                  NavigationItem(
                    label: 'Admin Dashboard',
                    icon: IconlyBold.category,
                    onTap: () async {
                      Navigator.pop(context); // Close drawer first
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (context.mounted) {
                        Navigator.pushNamed(
                            context, Routes.adminDashboardRoute);
                      }
                    },
                  ),
                  NavigationItem(
                    label: config.localization['addadmin'],
                    icon: IconlyLight.add_user,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        createRoute(const AddAdmin(), true),
                      );
                    },
                  ),
                  NavigationItem(
                    label: config.localization['addBanner'],
                    icon: IconlyBold.plus,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.addBannedRoute);
                    },
                  ),
                  NavigationItem(
                    label: config.localization['addMember'],
                    icon: IconlyBold.plus,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        createRoute(const AddMember(), true),
                      );
                    },
                  ),
                  NavigationItem(
                    label: config.localization['adminrequset'],
                    icon: IconlyBold.category,
                    onTap: () async {
                      Navigator.pop(context); // Close drawer first
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (context.mounted) {
                        Navigator.pushNamed(
                            context, Routes.allRequestsMeetRoute);
                      }
                    },
                  ),
                ],
              ),

            // User Actions Group - Only show if authenticated
            if (authService.isAuthenticated)
              NavigationGroup(
                title: config.localization['actions'],
                items: [
                  NavigationItem(
                    label: config.localization['signout'],
                    icon: IconlyBold.logout,
                    onTap: () async {
                      await authService.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.intialRoute,
                          (route) => false,
                        );
                      }
                    },
                  ),
                  NavigationItem(
                    label: config.localization['deleteAccount'],
                    icon: IconlyBold.delete,
                    onTap: () {
                      ConfirmaitionDialog(context);
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
