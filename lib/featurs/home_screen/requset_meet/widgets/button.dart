import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/Colors/coluors.dart';

class SmallButton extends StatelessWidget {
  SmallButton(
      {required this.condition,
      required this.color,
      required this.text,
      required this.fun,
      this.fontColor,
      this.widget,
      super.key});
  Color color;
  String text;
  Function fun;
  bool condition;
  Color? fontColor;
  Widget? widget;
  @override
  Widget build(BuildContext context) {
    return ConditionBuilder(
      condition: condition,
      ifFalse: InkWell(
        onTap: () => fun(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
          // width: 90.w,
          // height: 40.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget != null ? widget! : Container(),
              widget != null
                  ? SizedBox(
                      width: 10.w,
                    )
                  : Container(),
              Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fontColor ?? Colours.White,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
