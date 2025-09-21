// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/animated_navigation/animated_navigator.dart';
import '../../../core/theme/text_styles/text_styeles.dart';

Widget CustomListTile({
  required label,
  required IconData icon,
  Widget? widget,
  required Context,
  functinon,
  topDivider,
}) {
  bool divder = topDivider ?? true;
  return Column(
    children: [
      divder
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Container(
                height: 2.h,
                width: MediaQuery.sizeOf(Context).width - 35.w,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(31, 99, 99, 99),
                    borderRadius: BorderRadius.circular(5.r)),
              ),
            )
          : Container(),
      ListTile(
        title: Text(
          label,
          style: TextStyles.lightBlue16blod,
        ),
        onTap: () {
          functinon();
          widget != null
              ? Navigator.pushReplacement(
                  Context,
                  createRoute(widget, true),
                )
              : null;
        },
        leading: Icon(
          icon,
          size: 24.h,
          color: Colours.DarkBlue,
        ),
      ),
    ],
  );
}
