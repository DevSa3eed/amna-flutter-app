import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../constants/cached_constants/cached_constants.dart';
import '../../../core/theme/Colors/coluors.dart';

class AddYourOpinion extends StatefulWidget {
  const AddYourOpinion({super.key});

  @override
  State<AddYourOpinion> createState() => _AddYourOpinionState();
}

class _AddYourOpinionState extends State<AddYourOpinion> {
  @override
  Widget build(BuildContext context) {
    return userID != null
        ? InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.addOpinionRoute);
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colours.DarkBlue)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconlyBroken.plus,
                      size: 80.w,
                      color: Colours.DarkBlue,
                    ),
                    Text(
                      config.localization['addOPinion'],
                      style: TextStyles.lightBlue16blod,
                    ),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.loginRoute);
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colours.DarkBlue)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconlyBroken.login,
                      size: 80.w,
                      color: Colours.DarkBlue,
                    ),
                    Text(
                      config.localization['loginOpinion'],
                      style: TextStyles.lightBlue16blod,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
