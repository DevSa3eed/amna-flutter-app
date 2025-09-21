import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/config/config.dart';

// ignore: must_be_immutable
class SwitchLang extends StatelessWidget {
  SwitchLang({super.key});
  bool? isArabic;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0.w),
      child: Row(
        children: [
          SizedBox(
            width: 204.w,
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  size: 24.h,
                  color: Colours.LightBlue,
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  config.localization['drawerSwitch'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // BlocBuilder<PetFinderCubit, PetFinderState>(
          //   builder: (context, state) {
          //     var cubit = PetFinderCubit.get(context);
          //     return Switch(
          //       value: cacheHelper.getData('lang') ?? false,
          //       onChanged: (isSwitched) async {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => SearchPage(),
          //             ));
          //         cacheHelper.removeData('lang');
          //         if (isArabic == true) {
          //           isArabic = true;
          //           cubit.changeLanguage(isSwitched);
          //         } else {
          //           cubit.changeLanguage(isSwitched);
          //         }
          //         print(cacheHelper.getData('lang'));
          //       },
          //       activeColor: Colours.lightGreen,
          //       inactiveThumbColor: Colours.darkGreen,
          //       inactiveTrackColor: Colours.midGreen,
          //       activeTrackColor: Colours.midGreen,
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
