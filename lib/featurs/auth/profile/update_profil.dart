// ignore_for_file: use_build_context_synchronously

import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/featurs/auth/profile/cubit/profile_cubit.dart';
import 'package:dr_sami/featurs/auth/profile/cubit/update_profile_cubit.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_button.dart';

import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../../../routes/routes.dart';
import '../../custom_drawer/custom_drawer.dart';
import '../widgets/goto_text.dart';
import 'widget/update_image_profile.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});
// if (state is UpdateProfilesuccess) {
//             showToast(content: state.message);
//           } else if (state is UpdateProfileFailed) {
//             showToast(content: state.message);
//           }
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    nameController.text = name!;
    phoneController.text = phone!;
    emailController.text = userEmail!;
    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        title: Text(
          config.localization['updateprofile'],
          style: TextStyles.lightBlue20blod,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 130.r,
                backgroundColor: Colours.DarkBlue,
                child: const UpdateImageProfile()),
            Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  CustomTextFeild(
                    controller: usernameController,
                    iconPre: IconlyBroken.profile,
                    label: "Username : ${username!}",
                    hint: username,
                    isPassword: false,
                    type: TextInputType.text,
                    disabled: false,
                  ),
                  CustomTextFeild(
                    controller: nameController,
                    iconPre: IconlyBroken.profile,
                    label: config.localization['name'],
                    isPassword: false,
                    type: TextInputType.text,
                  ),
                  CustomTextFeild(
                    controller: emailController,
                    iconPre: IconlyBroken.profile,
                    label: config.localization['email'],
                    isPassword: false,
                    type: TextInputType.emailAddress,
                  ),
                  CustomTextFeild(
                    controller: phoneController,
                    iconPre: Icons.phone_android_outlined,
                    label: config.localization['phone'],
                    isPassword: false,
                    type: TextInputType.phone,
                  ),
                  SizedBox(height: 10.h),
                  BlocProvider(
                    create: (context) => ProfileCubit(),
                    child: BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) async {
                        if (state is ProfileUpdateError) {
                          showToast(content: 'Try latter');
                        } else if (state is ProfileUpdated) {
                          await UserProfileCubit().getUserInfo();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CustomDrawer(),
                              ));
                          showToast(content: 'Profile Updated Sucessfully');
                          // BlocProvider.of<UserProfileCubit>(context)
                          //     .getUserInfo();
                        }
                      },
                      builder: (context, state) {
                        return ConditionBuilder(
                            condition: state is ProfileUpdating,
                            ifFalse: CustomBotton(
                                navigate_fun: () {
                                  BlocProvider.of<ProfileCubit>(context)
                                      .updateProfile(
                                    id: userID!, // Replace with the actual ID
                                    fullName: nameController.text,
                                    username: username!,
                                    email: emailController.text,
                                    password: '',
                                    phoneNumber: phoneController.text,
                                    isAdmin: isAdmin!,
                                    imageCover: updateFile,
                                  );
                                },
                                lable: config.localization['update'],
                                fontSize: 20.sp));
                      },
                    ),
                  ),
                  GotoText(
                      text: config.localization['forgetPassword'],
                      route: Routes.confirmEmail),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
CustomBotton(
                              navigate_fun: () async {
                                log(cubit.imageFile!.path);
                                cubit.updateSubProfile(
                                    id: userID!,
                                    email: emailController.text,
                                    fullName: nameController.text,
                                    phoneNumber: phoneController.text,
                                    imageCover: await MultipartFile.fromFile(
                                        cubit.imageFile!.path));
                              },
                              lable: config.localization['update'],
                              fontSize: 20.sp,
                            ),*/
