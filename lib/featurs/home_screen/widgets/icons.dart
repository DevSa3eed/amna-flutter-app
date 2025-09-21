// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:dr_sami/core/assets_getter/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';

class IconsVeiw extends StatelessWidget {
  IconsVeiw({required this.iconURL, super.key});
  String iconURL;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.5.w),
      height: 70.h,
      width: 70.w,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colours.LightBlue,
        borderRadius: BorderRadius.circular(20.r),
        // border: Border.all(

        //   width: 2.w,
        // )
      ),
      child: Image.asset(
        iconURL,
        color: Colours.White,
        width: 50.w,
        height: 50.h,
        // fit: BoxFit.cover,
      ),
    );
  }
}

const List<String> mohsen = [
  Assets.png1,
  Assets.png2,
  Assets.png3,
  Assets.png4,
  Assets.png5,
  Assets.png1,
  Assets.png2,
  Assets.png3,
  Assets.png4,
  Assets.png5,
  Assets.png1,
  Assets.png2,
  Assets.png3,
  Assets.png4,
  Assets.png5,
  Assets.png1,
  Assets.png2,
  Assets.png3,
  Assets.png4,
  Assets.png5,
];

class AllIcons extends StatelessWidget {
  AllIcons({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 70.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mohsen.length,
              itemBuilder: (context, index) => IconsVeiw(
                iconURL: mohsen[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
