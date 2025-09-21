import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_button.dart';
import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:dr_sami/featurs/home_screen/teams/cubit/teams_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';

class AddMember extends StatelessWidget {
  const AddMember({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController positionController = TextEditingController();
    return BlocProvider(
      create: (context) => TeamsCubit(),
      child: BlocConsumer<TeamsCubit, TeamsState>(
        listener: (context, state) {
          if (state is AddTeamsSuccess) {
            Navigator.pushNamed(context, Routes.homeRoute);
            showToast(content: state.message);
          } else if (state is AddTeamsFailed) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          var cubit = TeamsCubit().get(context);
          var addMemberKey = GlobalKey<FormState>();
          return Scaffold(
            backgroundColor: Colours.White,
            appBar: AppBar(
              title: Text(
                config.localization['addMember'],
                style: TextStyles.lightBlue20blod,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      cubit.imageFile == null
                          ? Padding(
                              padding: EdgeInsets.all(15.0.w),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Image.asset(
                                      'assets/images/placeholder.png')),
                            )
                          : Padding(
                              padding: EdgeInsets.all(15.0.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: Image.file(
                                  cubit.imageFile!,
                                  width: double.infinity,
                                  height: 200.h,
                                  fit: BoxFit.cover,
                                ),
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
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      // padding: EdgeInsets.all(16.0),
                                      color: Colours.White,
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
                                                      style: TextStyles
                                                          .lightBlue16blod,
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
                                                      Icons
                                                          .photo_size_select_actual,
                                                      color: Colours.DarkBlue,
                                                      size: 50.w,
                                                    ),
                                                    Text(
                                                      'From Gallery',
                                                      style: TextStyles
                                                          .lightBlue16blod,
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
                  ),
                  Form(
                    key: addMemberKey,
                    child: Column(
                      children: [
                        CustomTextFeild(
                          controller: nameController,
                          label: config.localization['name'],
                          isPassword: false,
                          iconPre: Icons.text_fields,
                          type: TextInputType.name,
                        ),
                        CustomTextFeild(
                          controller: positionController,
                          label: config.localization['position'],
                          isPassword: false,
                          iconPre: Icons.text_fields,
                          type: TextInputType.name,
                        ),
                        ConditionBuilder(
                          condition: state is AddTeamsLoading,
                          ifFalse: CustomBotton(
                            navigate_fun: () {
                              if (cubit.imageFile != null) {
                                if (addMemberKey.currentState!.validate()) {
                                  cubit.addTeamMembers(
                                    name: nameController.text,
                                    position: positionController.text,
                                  );
                                }
                              } else {
                                showToast(content: 'Add Image');
                              }
                            },
                            lable: config.localization['addMember'],
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
