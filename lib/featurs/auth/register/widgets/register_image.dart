import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/register/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectImage extends StatelessWidget {
  SelectImage({this.image, super.key});
  Widget? image;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Stack(
          children: [
            cubit.imageFile == null
                ? image ??
                    Image.asset(
                      'assets/images/account.png',
                      fit: BoxFit.contain,
                      width: 250.w,
                      height: 250.w,
                      color: Colours.DarkBlue,
                    )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(150.r),
                    child: Image.file(
                      cubit.imageFile!,
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
    );
  }
}
