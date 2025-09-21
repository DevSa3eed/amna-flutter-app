import 'dart:developer';

import 'package:dr_sami/featurs/auth/login_first.dart';
import 'package:dr_sami/featurs/eula/eula.dart';
import 'package:dr_sami/featurs/home_screen/baners/add_banner.dart';
import 'package:dr_sami/core/extensions/media_values.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/login/login.dart';
import 'package:dr_sami/featurs/custom_drawer/widgets/custom_listtile.dart';
import 'package:dr_sami/featurs/home_screen/opinions/create_opinion_form.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/user_requests.dart';
import 'package:dr_sami/featurs/home_screen/teams/add_member.dart';
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
import '../home_screen/home_screen.dart';
import '../home_screen/requset_meet/all_request.dart';
import '../home_screen/requset_meet/cubit/meeting_cubit.dart';
import '../home_screen/requset_meet/requst_meet.dart';
import '../home_screen/requset_meet/widgets/button.dart';
import '../home_screen/widgets/condition.dart';
import 'widgets/profile_image.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.White,
      body: BlocProvider(
        create: (context) => LocalizationCubit()..changeLanguage(isArabic!),
        child: BlocConsumer<LocalizationCubit, LocalizationState>(
          listener: (context, state) {},
          builder: (context, state) {
            // context.read<LocalizationCubit>().changeLanguage(isArabic!);
            return Column(
              children: [
                image != null
                    ? Stack(
                        children: [
                          const ProfileImage(),
                          Positioned(
                            bottom: 15.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: context.width,
                                ),
                                BlocProvider(
                                  create: (context) => UserProfileCubit(),
                                  child: BlocConsumer<UserProfileCubit,
                                      userProfileState>(
                                    listener: (context, state) {
                                      if (state is GetProfilesuccess) {
                                        Navigator.pushReplacementNamed(
                                            context, Routes.updateProfileRoute);
                                      }
                                    },
                                    builder: (context, state) {
                                      return ConditionBuilder(
                                        condition: state is GetProfileLoading,
                                        ifFalse: SizedBox(
                                          width: 200.w,
                                          child: SmallButton(
                                            condition: false,
                                            color: Colours.White,
                                            text: config
                                                .localization['updateprofile'],
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
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(
                        width: context.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(50.r)),
                          color: Colours.DarkBlue,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/pngegg.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 15.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        createRoute(const HomeScreen(), false),
                                      );
                                    },
                                    icon: Icon(
                                      IconlyBroken.close_square,
                                      // Icons.close_outlined,
                                      color: Colours.White,
                                      size: 22.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                  width: context.width,
                                ),
                                Image.asset(
                                  'assets/images/account.png',
                                  fit: BoxFit.contain,
                                  width: 155.w,
                                  height: 155.w,
                                  color: Colours.White,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Routes.loginRoute);
                                  },
                                  child: Text(
                                    config.localization['login'],
                                    style: TextStyles.white20blod,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  child: ListView(
                    children: [
                      CustomListTile(
                          label: config.localization['home'],
                          icon: IconlyBold.home,
                          widget: const HomeScreen(),
                          Context: context,
                          functinon: () {},
                          topDivider: false),
                      CustomListTile(
                          label: config.localization['requestMeeting'],
                          icon: IconlyBold.video,
                          widget: userID != null
                              ? const RequstMeet()
                              : const LoginFirst(),
                          Context: context,
                          functinon: () {},
                          topDivider: true),

                      CustomListTile(
                        label: config.localization[
                            'lang'], // Accessing localization text
                        icon: Icons.language,

                        Context: context,
                        functinon: () {
                          isArabic =
                              !(isArabic ?? false); // Handle nulls safely

                          context
                              .read<LocalizationCubit>()
                              .changeLanguage(isArabic!);
                          debugPrint(cacheHelper.getData('lang').toString());
                          if (isArabic!) {
                            context.setLocale(const Locale('ar'));
                          } else {
                            context.setLocale(const Locale('en'));
                          }
                        },
                      ),

                      CustomListTile(
                        label: config.localization['addOPinion'],
                        icon: IconlyBold.plus,
                        widget: userID != null
                            ? const AddOpinion()
                            : const LoginFirst(),
                        Context: context,
                        functinon: () {},
                      ),
                      BlocProvider(
                        create: (context) => MeetingCubit(),
                        child: CustomListTile(
                          label: config.localization['userequests'],
                          icon: IconlyBold.category,
                          widget: userID != null
                              ? const UserRequests()
                              : const LoginFirst(),
                          Context: context,
                          functinon: () async {
                            await context.read<MeetingCubit>().convertCurancy();
                          },
                        ),
                      ),

                      userID == null
                          ? Column(
                              children: [
                                CustomListTile(
                                  label: config.localization['login'],
                                  icon: IconlyBold.login,
                                  widget: const LoginPage(),
                                  Context: context,
                                  functinon: () {},
                                ),
                                CustomListTile(
                                  label: config.localization['register'],
                                  icon: IconlyBold.login,
                                  widget: const Eula(),
                                  Context: context,
                                  functinon: () {},
                                ),
                              ],
                            )
                          : Container(),
                      // BlocProvider(
                      //   create: (context) => LocalizationCubit(),
                      //   child:
                      //       BlocConsumer<LocalizationCubit, LocalizationState>(
                      //     listener: (context, state) {},
                      //     builder: (context, state) {
                      //       return CustomListTile(
                      //         label: config.localization[
                      //             'lang'], // Accessing localization text
                      //         icon: Icons.language,
                      //
                      //         Context: context,
                      //         functinon: () {
                      //           isArabic =
                      //               !(isArabic ?? false); // Handle nulls safely
                      //
                      //           context
                      //               .read<LocalizationCubit>()
                      //               .changeLanguage(isArabic!);
                      //           debugPrint(cacheHelper.getData('lang'));
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),

                      isAdmin!
                          ? Column(
                              children: [
                                CustomListTile(
                                  label: config.localization['addadmin'],
                                  icon: IconlyLight.add_user,
                                  widget: const AddAdmin(),
                                  Context: context,
                                  functinon: () {},
                                ),
                                CustomListTile(
                                  label: config.localization['addBanner'],
                                  icon: IconlyBold.plus,
                                  widget: const AddBanner(),
                                  Context: context,
                                  functinon: () {},
                                ),
                                CustomListTile(
                                  label: config.localization['addMember'],
                                  icon: IconlyBold.plus,
                                  widget: const AddMember(),
                                  Context: context,
                                  functinon: () {},
                                ),
                                BlocProvider(
                                  create: (context) => MeetingCubit(),
                                  child:
                                      BlocBuilder<MeetingCubit, MeetingState>(
                                    builder: (context, state) {
                                      return CustomListTile(
                                        label:
                                            config.localization['adminrequset'],
                                        icon: IconlyBold.category,
                                        widget: const AllReuests(),
                                        Context: context,
                                        functinon: () async {
                                          log('message');
                                          await context
                                              .read<MeetingCubit>()
                                              .convertCurancy();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      userID != null
                          ? Column(
                              children: [
                                CustomListTile(
                                  label: config.localization['signout'],
                                  icon: IconlyBold.logout,
                                  // widget: CustomDrawer(),
                                  Context: context,
                                  functinon: () {
                                    context.read<LocalizationCubit>().logOut();
                                  },
                                ),
                                CustomListTile(
                                  label: config.localization['deleteAccount'],
                                  icon: IconlyBold.delete,
                                  // widget: CustomDrawer(),
                                  Context: context,
                                  functinon: () {
                                    ConfirmaitionDialog(context);
                                  },
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
