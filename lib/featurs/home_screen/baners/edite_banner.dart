import 'package:dr_sami/featurs/home_screen/baners/cubit/banners_cubit.dart';
import 'package:dr_sami/featurs/home_screen/baners/model/banner_model.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_button.dart';
import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/Colors/coluors.dart';
import '../../../../core/theme/text_styles/text_styeles.dart';

class EditBanner extends StatelessWidget {
  const EditBanner({required this.bannerModel, super.key});
  final Banners bannerModel;
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return BlocProvider(
      create: (context) => BannersCubit(),
      child: BlocConsumer<BannersCubit, BannersState>(
        listener: (context, state) {
          if (state is EditBannerSuccessful) {
            Navigator.pushNamed(context, Routes.homeRoute);
            showToast(content: state.message);
          } else if (state is EditBannerFailed) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          var cubit = BannersCubit().get(context);
          var EditBannerKey = GlobalKey<FormState>();
          titleController.text = bannerModel.titel!;
          descriptionController.text = bannerModel.description!;
          return Scaffold(
            backgroundColor: Colours.White,
            appBar: AppBar(
              title: Text(
                'up Date Banner',
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
                    key: EditBannerKey,
                    child: Column(
                      children: [
                        CustomTextFeild(
                          controller: titleController,
                          label: config.localization['title'],
                          isPassword: false,
                          iconPre: Icons.text_fields,
                          type: TextInputType.name,
                        ),
                        CustomTextFeild(
                          controller: descriptionController,
                          label: config.localization['desc'],
                          isPassword: false,
                          iconPre: Icons.text_fields,
                          type: TextInputType.name,
                        ),
                        ConditionBuilder(
                          condition: state is EditBannerLoading,
                          ifFalse: CustomBotton(
                            navigate_fun: () {
                              if (cubit.imageFile != null) {
                                if (EditBannerKey.currentState!.validate()) {
                                  cubit.EditBanner(
                                    bannerId: bannerModel.id!,
                                    title: titleController.text,
                                    desc: descriptionController.text,
                                  );
                                }
                              } else {
                                showToast(content: 'Add Image');
                              }
                            },
                            lable: 'up Date Banner',
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
