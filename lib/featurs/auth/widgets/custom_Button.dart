// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';

// ignore: non_constant_identifier_names
Widget CustomBotton({
  // ignore: non_constant_identifier_names
  required navigate_fun,
  required lable,
  required fontSize,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
    child: GestureDetector(
      onTap: navigate_fun,
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colours.LightBlue,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            lable,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    ),
  );
}
