import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/featurs/auth/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant_widgets/circle_progress.dart';
import '../../../../core/theme/Colors/coluors.dart';
import '../../../../core/theme/text_styles/text_styeles.dart';

class UpdateImageProfile extends StatelessWidget {
  const UpdateImageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileCubit()..getUserInfo(),
      child: BlocConsumer<UserProfileCubit, userProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = UserProfileCubit.get(context);
          return Stack(
            children: [
              updateFile == null
                  // ? Image.asset(
                  //     'assets/images/account.png',
                  //     fit: BoxFit.contain,
                  //     width: 250.w,
                  //     height: 250.w,
                  //     color: Colours.DarkBlue,
                  //   )
                  ? ClipOval(
                      child: CachedNetworkImage(
                        width: 250.w,
                        height: 250.w,
                        fit: BoxFit.cover,
                        imageUrl: '$imageUrl$image',
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/account.png',
                          fit: BoxFit.contain,
                          width: 250.w,
                          height: 250.w,
                          color: Colours.DarkBlue,
                        ),
                        placeholder: (context, url) => customLoader(),
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
                        updateFile!,
                        width: 250.w,
                        height: 250.h,
                        fit: BoxFit.cover,
                      ),
                    ),
              Positioned(
                right: 10.w,
                bottom: 0.h,
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colours.DarkBlue,
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colours.White,
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              // padding: EdgeInsets.all(16.0),
                              height: 150.h,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'Select Your Photo',
                                    style: TextStyles.lightBlue20blod,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          cubit.pickImageFromCamera();
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              color: Colours.DarkBlue,
                                              size: 50.w,
                                            ),
                                            Text(
                                              'By Camera',
                                              style: TextStyles.lightBlue16blod,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          cubit.pickImageFromGallery();
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.photo_size_select_actual,
                                              color: Colours.DarkBlue,
                                              size: 50.w,
                                            ),
                                            Text(
                                              'From Gallery',
                                              style: TextStyles.lightBlue16blod,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colours.White,
                        // size: 25.r,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
