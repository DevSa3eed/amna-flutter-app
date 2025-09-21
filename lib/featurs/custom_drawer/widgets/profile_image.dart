import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/core/extensions/media_values.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../core/animated_navigation/animated_navigator.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../../home_screen/home_screen.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.r)),
        color: Colours.DarkBlue,
        image: const DecorationImage(
          image: AssetImage('assets/images/pngegg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      createRoute(const HomeScreen(), false),
                      (route) => false,
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
          Center(
            child: Column(
              children: [
                SizedBox(height: 25.h),
                image == null
                    ? Container()
                    : CircleAvatar(
                        radius: 80.r,
                        backgroundColor: Colours.White,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            width: 155.w,
                            height: 155.w,
                            fit: BoxFit.cover,
                            imageUrl: '$imageUrl$image',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            // While loading
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/account.png',
                              fit: BoxFit.contain,
                              width: 155.w,
                              height: 155.w,
                              color: Colours.White,
                            ), // If there is an error
                          ),
                        ),
                      ),
                SizedBox(height: 10.h),
                // Text(
                //   config.localization['welcome'],
                //   style: TextStyles.lightBlue16blod,
                // ),
                name != null
                    ? Column(
                        children: [
                          Text(
                            // cubit.userModel!.fullName!,
                            name!,
                            style: TextStyles.white20blod,
                          ),
                          Text(
                            // cubit.userModel!.email!,
                            userEmail!,
                            style: TextStyles.white16blod,
                          ),
                          SizedBox(height: 60.h),
                        ],
                      )
                    : Container(),
                SizedBox(height: 25.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
