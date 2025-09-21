import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/core/animated_navigation/animated_navigator.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/constant_widgets/circle_progress.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/custom_drawer/custom_drawer.dart';
import 'package:dr_sami/featurs/home_screen/baners/banners.dart';
import 'package:dr_sami/featurs/home_screen/clinic/clinics.dart';
import 'package:dr_sami/featurs/home_screen/opinions/all_opinions.dart';
import 'package:dr_sami/featurs/home_screen/opinions/cubit/opinions_cubit.dart';
import 'package:dr_sami/featurs/home_screen/teams/team_members.dart';
import 'package:dr_sami/featurs/home_screen/widgets/icons.dart';
import 'package:dr_sami/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, createRoute(const CustomDrawer(), true));
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
            Row(
              children: [
                SizedBox(
                  width: 15.w,
                ),
                image == null
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
                          imageUrl: '$imageUrl$image',
                          placeholder: (context, url) => customLoader(),
                          // While loading
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error), // If there is an error
                        ),
                      ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      config.localization['welcome'],
                      style: TextStyles.lightBlue16blod,
                    ),
                    name != null
                        ? Text(
                            name!,
                            style: TextStyles.lightBlue16blod,
                          )
                        : Container(),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15.h,
              width: double.infinity,
            ),
            const BannersView(),
            AllIcons(),

            const Clinics(),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w),
            //   child: Text(
            //     config.localization['custmoerOpinion'],
            //     style: TextStyles.lightBlue20blod,
            //   ),
            // ),
            BlocProvider(
              create: (context) => OpinionsCubit()..getOpinions(),
              child: BlocConsumer<OpinionsCubit, OpinionsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return const OpinonBulider();
                },
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w),
            //   child: Text(
            //     config.localization['ourTeam'],
            //     style: TextStyles.lightBlue20blod,
            //   ),
            // ),
            const TeamMembers(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userID != null) {
            Navigator.pushNamed(context, Routes.requsetMeatRoute);
          } else {
            Navigator.pushNamed(context, Routes.loginFirstRoute);
          }
        },
        shape: const CircleBorder(),
        backgroundColor: Colours.DarkBlue,
        child: Icon(
          IconlyBroken.video,
          size: 30.w,
          color: Colours.White,
        ),
      ),
    );
  }
}
