import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/assets_getter/asset.dart';
import 'package:dr_sami/core/assets_getter/assets_getter.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/media_values.dart';

class Clinics extends StatelessWidget {
  const Clinics({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${config.localization['clincs']} ',
            style: TextStyles.lightBlue20blod,
          ),
          Container(
            width: context.width,
            height: context.height * .3,
            decoration: BoxDecoration(
              color: Colours.DarkBlue,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: AssetsGetter.GetImage(
                      imageUrI: Assets.clinic,
                      boxFit: BoxFit.cover,
                      imageWidth: double.infinity,
                      imageHeghit: double.infinity),
                ),
                Container(
                  width: context.width,
                  height: context.height * .3,
                  decoration: BoxDecoration(
                    color: Colours.DarkBlue.withOpacity(.7),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${config.localization['App Name']}",
                          // "${config.localization['App Name']} ${config.localization['clinc']}",
                          style: TextStyles.white26blod,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          config.localization['clinicdes'],
                          style: TextStyles.white18blod,
                          // maxLines: 5,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
