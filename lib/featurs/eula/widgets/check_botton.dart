import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/config.dart';
import '../../../core/heights/height.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../../../routes/routes.dart';

class CheckBotton extends StatefulWidget {
  const CheckBotton({super.key});

  @override
  State<CheckBotton> createState() => _CheckBottonState();
}

bool isChecked = false;

class _CheckBottonState extends State<CheckBotton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: isChecked,
              tristate:
                  true, // Enables three states: checked, unchecked, and null.
              activeColor:
                  Colours.LightBlue, // Color of the checkbox when active.
              checkColor: Colors.white, // Color of the check mark.
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
              focusColor: Colours.LightBlue,
              hoverColor: Colours.LightBlue,
              side: BorderSide(color: Colours.LightBlue, width: 2.w),
            ),
            Expanded(
              child: Text(
                config.localization['EulaAgreamnt'],
                style: TextStyles.lightBlue16blod,
                maxLines: 3,
              ),
            ),
          ],
        ),
        SizedBox(
          height: Constant.h30,
        ),
        ElevatedButton(
          onPressed: isChecked
              ? () {
                  Navigator.pushNamed(context, Routes.registerRoute);
                }
              : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colours.LightBlue,
            // disabledForegroundColor: Colors.grey.withOpacity(0.38),
            disabledBackgroundColor: Colours.MidBlue.withOpacity(.5),
            minimumSize: Size(200.w, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            config.localization['register'],
            style: TextStyles.white18blod,
          ),
        ),
        SizedBox(
          height: Constant.h20,
        ),
      ],
    );
  }
}
